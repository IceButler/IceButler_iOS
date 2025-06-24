//
//  CameraViewController.swift
//  IceButler_iOS
//
//  Created by Claude on 2024/06/24.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate: AnyObject {
    func cameraViewController(_ viewController: CameraViewController, didCaptureImage image: UIImage)
    func cameraViewControllerDidCancel(_ viewController: CameraViewController)
}

class CameraViewController: UIViewController {
    
    weak var delegate: CameraViewControllerDelegate?
    
    // MARK: - Camera Properties
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var photoOutput: AVCapturePhotoOutput?
    
    // MARK: - UI Components
    private let previewView = UIView()
    
    private let guidanceView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let guidanceLabel: UILabel = {
        let label = UILabel()
        label.text = "영수증을 이 영역 안에 맞춰주세요"
        label.font = UIFont(name: "NanumSquareOTF", size: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    private let captureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.layer.cornerRadius = 35
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.systemGray3.cgColor
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NanumSquareOTFB", size: 16)
        return button
    }()
    
    private let flashButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bolt.slash"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 20
        return button
    }()
    
    private var isFlashOn = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startCameraSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCameraSession()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(previewView)
        view.addSubview(guidanceView)
        view.addSubview(guidanceLabel)
        view.addSubview(captureButton)
        view.addSubview(cancelButton)
        view.addSubview(flashButton)
        
        previewView.translatesAutoresizingMaskIntoConstraints = false
        guidanceView.translatesAutoresizingMaskIntoConstraints = false
        guidanceLabel.translatesAutoresizingMaskIntoConstraints = false
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            guidanceView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guidanceView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            guidanceView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            guidanceView.heightAnchor.constraint(equalTo: guidanceView.widthAnchor, multiplier: 1.4),
            
            guidanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guidanceLabel.topAnchor.constraint(equalTo: guidanceView.topAnchor, constant: -40),
            guidanceLabel.heightAnchor.constraint(equalToConstant: 28),
            guidanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            guidanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cancelButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            
            flashButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            flashButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            flashButton.widthAnchor.constraint(equalToConstant: 40),
            flashButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Button Actions
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        flashButton.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo
        
        // Video input
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: backCamera) else {
            showCameraError()
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        // Photo output
        photoOutput = AVCapturePhotoOutput()
        guard let photoOutput = photoOutput else { return }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        captureSession.commitConfiguration()
        
        // Preview layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.bounds
        
        if let videoPreviewLayer = videoPreviewLayer {
            previewView.layer.addSublayer(videoPreviewLayer)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = previewView.bounds
    }
    
    // MARK: - Camera Actions
    private func startCameraSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    private func stopCameraSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession?.stopRunning()
        }
    }
    
    @objc private func capturePhoto() {
        guard let photoOutput = photoOutput else { return }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = isFlashOn ? .on : .off
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func cancelTapped() {
        delegate?.cameraViewControllerDidCancel(self)
    }
    
    @objc private func toggleFlash() {
        isFlashOn.toggle()
        let imageName = isFlashOn ? "bolt" : "bolt.slash"
        flashButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func showCameraError() {
        let alert = UIAlertController(
            title: "카메라 오류",
            message: "카메라에 접근할 수 없습니다.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.delegate?.cameraViewControllerDidCancel(self!)
        })
        
        present(alert, animated: true)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        // 이미지 방향 수정
        let fixedImage = image.fixedOrientation()
        delegate?.cameraViewController(self, didCaptureImage: fixedImage)
    }
}

// MARK: - UIImage Extension
extension UIImage {
    func fixedOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? self
    }
}
//
//  BarCodeView.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/05.
//

import UIKit
import AVKit

enum ReaderStatus {
    case success(_code: String?)
    case fail
}

protocol BarCodeViewDelgate: AnyObject {
    func readerComplete(status: ReaderStatus)
}

class BarCodeView: UIView {
    
    
    weak var delegate: BarCodeViewDelgate?

    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    let metadataObjectTypes: [AVMetadataObject.ObjectType] = [.ean13]
    
    
    var isRunning: Bool {
        guard let captureSession = self.captureSession else {
            return false
        }
        
        return captureSession.isRunning
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalSetupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initalSetupView()
    }
    
    private func initalSetupView() {
        clipsToBounds = true
        
        captureSession = AVCaptureSession()
        
        guard let captureSession = self.captureSession else {
            fail()
            return
        }
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }else {
            fail()
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = metadataObjectTypes
        }else {
            fail()
            return
        }
        
        setPreviewLayer()
    }
    
    private func setPreviewLayer() {
      guard let captureSession = self.captureSession else {
        return
      }

      let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
      previewLayer.frame = self.layer.bounds

      self.layer.addSublayer(previewLayer)

      self.previewLayer = previewLayer
    }
    
}


extension BarCodeView {
    func start() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.startRunning()
        }
    }
    
    func stop() {
        self.captureSession?.stopRunning()
    }
    
    func fail() {
        self.delegate?.readerComplete(status: .fail)
        self.captureSession = nil
    }
    
    func found(code: String) {
        self.delegate?.readerComplete(status: .success(_code: code))
    }
}


extension BarCodeView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
          stop()
          guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue else {
            return
          }

          AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
          found(code: stringValue)
        }
      }
}

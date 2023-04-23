//
//  MyRefrigeratorTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/23.
//

import UIKit

class MyRefrigeratorTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var refrigeratorNameLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moreView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "RefriMemberCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RefriMemberCollectionViewCell")
    }
    
    private func setupLayout() {
        [containerView, moreView].forEach { view in
            view.backgroundColor = .white
            view.layer.shadowColor = UIColor.gray.cgColor
            view.layer.shadowOpacity = 0.15
            view.layer.shadowRadius = 10
            view.layer.shadowOffset = CGSize(width: 0, height: 5)
            view.layer.shadowPath = nil
        }
        moreView.layer.cornerRadius = 12
    }
    
    @IBAction func didTapMoreButton(_ sender: UIButton) {
        if moreView.isHidden { moreView.isHidden = false }
        else { moreView.isHidden = true }
    }
    
    @IBAction func didTapEditButton(_ sender: UIButton) {
        // TODO: 냉장고 수정 화면으로 전환
    }
    
    
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        // TODO: 냉장고 삭제 AlertVC 전환
    }
    
}

extension MyRefrigeratorTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4    // 임시 멤버수
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RefriMemberCollectionViewCell", for: indexPath) as? RefriMemberCollectionViewCell else { return UICollectionViewCell() }
        cell.setupLayout()
        if indexPath.row == 0 { cell.setupMainMemberProfile() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
    
}

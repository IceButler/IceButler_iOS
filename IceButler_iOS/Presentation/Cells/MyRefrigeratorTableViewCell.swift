//
//  MyRefrigeratorTableViewCell.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/04/23.
//

import UIKit

protocol MyRefrigeratorTableViewCellDelegate {
    func didTapEditButton(index: Int)
    func didTapDeleteButton(index: Int)
}

class MyRefrigeratorTableViewCell: UITableViewCell {

    var delegate: MyRefrigeratorTableViewCellDelegate?
    private var memberInfos: [FridgeUser] = []
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var refrigeratorNameLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moreView: UIView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
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
    
    public func configureFridge(data: Fridge?) {
        if let data = data {
            refrigeratorNameLabel.text = data.fridgeName
            memberNumLabel.text = "\(data.userCnt!)"
            commentLabel.text = data.comment
            memberInfos = data.users!
        }
    }
    
    public func configureMultiFridge(data: MultiFridgeRes?) {
        if let data = data {
            refrigeratorNameLabel.text = data.multiFridgeName
            memberNumLabel.text = "\(data.userCnt!)"
            commentLabel.text = data.comment
            memberInfos = data.users!
        }
    }
    
    @IBAction func didTapMoreButton(_ sender: UIButton) {
        if moreView.isHidden { moreView.isHidden = false }
        else { moreView.isHidden = true }
    }
    
    @IBAction func didTapEditButton(_ sender: UIButton) {
        delegate?.didTapEditButton(index: self.tag)
    }
    
    
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        delegate?.didTapDeleteButton(index: self.tag)
    }
    
}

extension MyRefrigeratorTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RefriMemberCollectionViewCell", for: indexPath) as? RefriMemberCollectionViewCell else { return UICollectionViewCell() }
        cell.setupLayout()
        cell.configure(data: memberInfos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
    
}

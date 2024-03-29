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
    func didTapAnyOfView()
}

class MyRefrigeratorTableViewCell: UITableViewCell {

    var fridgeOwnerIdx: Int = -1
    var delegate: MyRefrigeratorTableViewCellDelegate?
    private var memberInfos: [FridgeUser] = []
    private var isHighlightedComment = false
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var refrigeratorNameLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moreView: UIView!
    
    @IBOutlet var notOwnerMoreView: UIView!
    
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var commentDetailView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupLayout()
        setupGestureRecognizers()
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
        [containerView, moreView, notOwnerMoreView].forEach { view in
            view.backgroundColor = .white
            view.layer.shadowColor = UIColor.gray.cgColor
            view.layer.shadowOpacity = 0.2
            view.layer.shadowRadius = 10
            view.layer.shadowOffset = CGSize(width: 0, height: 5)
            view.layer.shadowPath = nil
        }
        containerView.layer.cornerRadius = 12
        moreView.layer.cornerRadius = 16
        notOwnerMoreView.layer.cornerRadius = 20
        commentDetailView.layer.cornerRadius = 12
    }
    
    private func setEventHandler() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCommentDetailView))
        commentDetailView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCommentDetailView))
        commentDetailView.addGestureRecognizer(tapGestureRecognizer)
        
        let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAnyOfView))
        self.containerView.addGestureRecognizer(viewTapGestureRecognizer)
    }
    
    public func configureFridge(data: Fridge?) {
        if let data = data {
            fridgeOwnerIdx = data.users![0].userIdx
            refrigeratorNameLabel.text = data.fridgeName
            memberNumLabel.text = "\(data.userCnt!)"
            commentTextView.text = data.comment
            commentDetailView.text = data.comment
            memberInfos = data.users!
        }
    }
    
    public func configureMultiFridge(data: MultiFridgeRes?) {
        if let data = data {
            fridgeOwnerIdx = data.users![0].userIdx
            refrigeratorNameLabel.text = data.multiFridgeName
            memberNumLabel.text = "\(data.userCnt!)"
            commentTextView.text = data.comment
            commentDetailView.text = data.comment
            memberInfos = data.users!
        }
    }
    
    public func setupViewIsHidden() {
        moreView.isHidden = true
        notOwnerMoreView.isHidden = true
    }
    
    @IBAction func didTapMoreButton(_ sender: UIButton) {
        /// 유저가 오너인 냉장고의 경우 moreView 히든 해제
        /// 유저가 오너가 아닌, 멤버인 경우 notOwnerMoreView 히든 해제
        UserService().getUserInfo { [weak self] userInfo in
            if userInfo.userIdx == self?.fridgeOwnerIdx {
                if ((self?.moreView.isHidden) == true) { self?.moreView.isHidden = false }
                else { self?.moreView.isHidden = true }
                
            } else {
                if ((self?.notOwnerMoreView.isHidden) == true) { self?.notOwnerMoreView.isHidden = false }
                else { self?.notOwnerMoreView.isHidden = true }
            }
        }
    }
    
    @IBAction func didTapEditButton(_ sender: UIButton) {
        delegate?.didTapEditButton(index: self.tag)
    }
    
    
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        delegate?.didTapDeleteButton(index: self.tag)
    }
    
    
    @IBAction func didTapViewCommentButton(_ sender: Any) {
        UIView.transition(with: self.commentDetailView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
            self.commentDetailView.isHidden = false },
                          completion: nil);
    }
    
    // MARK: @objc methods
    @objc private func didTapCommentDetailView() {
        UIView.transition(with: self.commentDetailView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
            self.commentDetailView.isHidden = true },
                          completion: nil);
    }
    @objc private func didTapAnyOfView() { delegate?.didTapAnyOfView() }
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

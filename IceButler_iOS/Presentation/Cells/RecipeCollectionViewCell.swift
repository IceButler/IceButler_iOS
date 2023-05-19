//
//  RecipeCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/29.
//

import UIKit
import Kingfisher

class RecipeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var recipeNameLabel: UILabel!
    var foodTypeLabel: BasePaddingLabel!
    var percentLabel: BasePaddingLabel!
    var idx: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    @IBAction func didTapBookmarkButton(_ sender: Any) {
        RecipeViewModel.shared.updateBookmarkStatus(recipeIdx: idx) { bookmarkStatus in
            self.setLikeStatus(status: bookmarkStatus)
        }
    }
    
    private func setupLayout() {
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 20
        layer.applyShadow(color: .black, alpha: 0.1, x: 0, y: 4, blur: 20, spread: 0)
        
        foodTypeLabel = {
            let foodTypeLabel = BasePaddingLabel()
            foodTypeLabel.backgroundColor = .navigationColor
            foodTypeLabel.textColor = .white
            foodTypeLabel.font = .systemFont(ofSize: 10, weight: .regular)
            foodTypeLabel.layer.masksToBounds = true
            return foodTypeLabel
        }()
        percentLabel = {
            let percentLabel = BasePaddingLabel()
            percentLabel.backgroundColor = .greenCell
            percentLabel.textColor = .white
            percentLabel.font = .systemFont(ofSize: 10, weight: .regular)
            percentLabel.layer.masksToBounds = true
            return percentLabel
        }()
        self.backView.addSubview(foodTypeLabel)
        self.backView.addSubview(percentLabel)
        foodTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            foodTypeLabel.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 5),
            foodTypeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 19),
            foodTypeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13),
            foodTypeLabel.heightAnchor.constraint(equalToConstant: 19),
            percentLabel.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 5),
            percentLabel.leadingAnchor.constraint(equalTo: foodTypeLabel.trailingAnchor, constant: 5),
            percentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13),
            percentLabel.heightAnchor.constraint(equalToConstant: 19),
        ])
        
        backView.layoutIfNeeded()
        setLabelCornerRadius()
    }
    
    private func setLabelCornerRadius() {
        foodTypeLabel.layer.cornerRadius = foodTypeLabel.frame.height / 2
        percentLabel.layer.cornerRadius = percentLabel.frame.height / 2
    }
    
    func setImage(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            recipeImageView.kf.setImage(with: url)
            recipeImageView.contentMode = .scaleAspectFill
        }
    }
    
    func setName(name: String) {
        recipeNameLabel.text = name
    }
    
    func setCategory(category: String) {
        foodTypeLabel.text = category
    }
    
    func setPercent(percent: Int) {
        percentLabel.text = String(percent) + "%"
        
        // 50%~79%:빨간색, 80%~99%:노란색, 100%:초록색
        if 50 <= percent, percent < 80 {
            percentLabel.backgroundColor = .pinkCell
        } else if 80 <= percent, percent < 100 {
            percentLabel.backgroundColor = .yellowCell
        } else {
            percentLabel.backgroundColor = .greenCell
        }
    }
    
    func setLikeStatus(status: Bool) {
        if status {
            bookmarkButton.setImage(UIImage(named: "smallStar"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named: "emptyStar"), for: .normal)
        }
    }
    
    func configure(idx: Int) { self.idx = idx }
}

extension CALayer {
    func applyShadow(
        color: UIColor,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat
    ) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / UIScreen.main.scale
        if spread == 0 {
            shadowPath = nil
        } else {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 8.0, right: 10.0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}

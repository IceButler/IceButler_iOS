//
//  RecipeCollectionViewCell.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/04/29.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var recipeNameLabel: UILabel!
    var foodTypeLabel: BasePaddingLabel!
    var percentLabel: BasePaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.layoutIfNeeded()
        setLabelCornerRadius()
    }
    
    private func setupLayout() {
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 20
        layer.applyShadow(color: .black, alpha: 0.1, x: 0, y: 4, blur: 20, spread: 0)
        
        foodTypeLabel = {
            let foodTypeLabel = BasePaddingLabel()
            foodTypeLabel.backgroundColor = .navigationColor
            foodTypeLabel.text = "한식"
            foodTypeLabel.textColor = .white
            foodTypeLabel.font = .systemFont(ofSize: 10, weight: .regular)
            foodTypeLabel.layer.masksToBounds = true
            return foodTypeLabel
        }()
        percentLabel = {
            let percentLabel = BasePaddingLabel()
            percentLabel.backgroundColor = .greenCell
            percentLabel.text = "50%"
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
    }
    
    private func setLabelCornerRadius() {
        foodTypeLabel.layer.cornerRadius = foodTypeLabel.frame.height / 2
        percentLabel.layer.cornerRadius = percentLabel.frame.height / 2
    }
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

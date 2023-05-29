//
//  UICollectionViewFlowLayout+.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/08.
//

import Foundation
import UIKit

class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 10
 
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 10.0
        self.sectionInset = UIEdgeInsets(top: 0, left: 17, bottom: 0.0, right: 0)
        let attributes = super.layoutAttributesForElements(in: rect)
 
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}


class FoodCollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 15
 
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 10
        self.sectionInset = UIEdgeInsets(top: 22, left: 18, bottom: 0.0, right: 21.05)
        let attributes = super.layoutAttributesForElements(in: rect)
 
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}

class RecipeCollectionViewFlowLayout: UICollectionViewFlowLayout {
    let columnCount = 2
    let lineSpacing = 18
    let itemSpacing = 16
    let sectionHorizontalSpacing: CGFloat = 16
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 16
        self.minimumInteritemSpacing = 14
        self.sectionInset = UIEdgeInsets(top: 13, left: sectionHorizontalSpacing, bottom: 18, right: sectionHorizontalSpacing)
 
        let width: CGFloat = UIScreen.main.bounds.width - CGFloat(itemSpacing * (columnCount - 1)) - CGFloat(sectionHorizontalSpacing * 2)
        let itemWidth: CGFloat = width / CGFloat(columnCount)
        self.itemSize = CGSize(width: itemWidth, height: 204)
        
        return super.layoutAttributesForElements(in: rect)
    }
}

class RecipeCollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 16
 
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 4
        self.minimumInteritemSpacing = 16
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes }
 
        var leftMargin = 0.0
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = 0
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}

//
//  TipsCollectionViewLayout.swift
//  NGSprots
//
//  Created by Jean on 1/12/2023.
//

import UIKit

class TipsCollectionViewLayout: UICollectionViewFlowLayout {
    
    //横向排列标签
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        var rowCollections = [CGFloat: [UICollectionViewLayoutAttributes]]()
        
        for attributes in layoutAttributes ?? [] {
            let minY = attributes.frame.minY
            if rowCollections[minY] == nil {
                rowCollections[minY] = [UICollectionViewLayoutAttributes]()
            }
            rowCollections[minY]?.append(attributes)
        }

        for (_, attributesArray) in rowCollections {
            var xOffset: CGFloat = sectionInset.left
            var rowHeight: CGFloat = 0
            
            for attributes in attributesArray {
                let itemWidth = attributes.frame.width
                let itemHeight = attributes.frame.height
                attributes.frame.origin.x = xOffset
                xOffset += itemWidth + minimumInteritemSpacing
                rowHeight = max(rowHeight, itemHeight)
                
                if attributesArray.count > 1 {
                    attributes.frame.size.height = rowHeight
                }
            }
        }
        return layoutAttributes
    }
}

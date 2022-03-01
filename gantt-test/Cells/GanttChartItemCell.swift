//
//  GanttChartItemCell.swift
//  gantt-test
//
//  Created by Kai on 2022/3/1.
//

import UIKit

class GanttChartItemCell: UICollectionViewCell {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let attributes = layoutAttributes as! GanttChartCollectionViewLayoutAttributes
        
        if attributes.isOffsetXLessThanCollectionView {
            roundCorners(corners: [.topRight, .bottomRight], radius: 12)
        } else {
            roundCorners(corners: [.topLeft, .bottomLeft], radius: 12)
        }
    }
    
    func applyConfiguration(title: String, bgColor: UIColor) {
        backgroundColor = bgColor
        
        var config = UIListContentConfiguration.cell()
        config.text = title
        config.textProperties.color = .white
        contentConfiguration = config
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

//
//  GanttChartItemCell.swift
//  gantt-test
//
//  Created by Kai on 2022/3/1.
//

import UIKit

class GanttChartItemCell: UICollectionViewCell {
    lazy var progressView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(progressView)
        contentView.roundCorners(corners: .allCorners, radius: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }
    
    func applyConfiguration(item: GanttChartItem) {
        contentView.backgroundColor = item.color.withAlphaComponent(0.5)
        
        let width = item.progress * bounds.width
        
        progressView.backgroundColor = item.color
        progressView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: width,
                                    height: bounds.height)
    }
}

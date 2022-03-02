//
//  GanttChartCycleFrameReusableView.swift
//  gantt-test
//
//  Created by Kai on 2022/3/2.
//

import UIKit

class GanttChartCycleFrameReusableView: UICollectionReusableView {
    lazy var frameView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(frameView)
    }
    
    func applyConfigurations() {
        frameView.frame = bounds
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let attributes = layoutAttributes as! GanttChartCollectionViewLayoutAttributes
            
        
    }
}

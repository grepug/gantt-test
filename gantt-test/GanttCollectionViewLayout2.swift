//
//  GanttCollectionViewLayout2.swift
//  gantt-test
//
//  Created by Kai on 2022/2/28.
//

import UIKit

class GanttCollectionViewLayout2: UICollectionViewLayout {
    var config: GanttChartConfiguration
    
    init(config: GanttChartConfiguration) {
        self.config = config
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var attributes: [[UICollectionViewLayoutAttributes]] = []
    
    override var collectionViewContentSize: CGSize {
        config.collectionViewContentSize
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let frame = config.cellFrame(at: indexPath)
        let cellType = config.cellType(at: indexPath)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        attributes.frame = frame
        
        if cellType == .itemCell {
            attributes.zIndex = 10
        } else {
            attributes.zIndex = 9
        }
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        var attributesArr: [UICollectionViewLayoutAttributes] = []
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                if let attributes = layoutAttributesForItem(at: .init(item: item, section: section)) {
                    if attributes.frame.intersects(rect) {
                        attributesArr.append(attributes)
                    }
                }
            }
        }
        
        return attributesArr
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}

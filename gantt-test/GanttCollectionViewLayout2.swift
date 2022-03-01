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
    
    var attributesArr: [[UICollectionViewLayoutAttributes]] = []
    
    override var collectionViewContentSize: CGSize {
        config.collectionViewContentSize
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        guard attributesArr.count != collectionView.numberOfSections else { return }
        
        for section in 0..<collectionView.numberOfSections {
            var sectionArributes: [UICollectionViewLayoutAttributes] = []
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let frame = config.cellFrame(at: indexPath)
                let cellType = config.cellType(at: indexPath)
                
                attributes.frame = frame
                
                if cellType == .itemCell {
                    attributes.zIndex = 10
                } else {
                    attributes.zIndex = 9
                }
                
                sectionArributes.append(attributes)
            }
            
            attributesArr.append(sectionArributes)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        attributesArr[indexPath.section][indexPath.item]
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

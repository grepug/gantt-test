//
//  GanttCollectionViewLayout2.swift
//  gantt-test
//
//  Created by Kai on 2022/2/28.
//

import UIKit

class GanttCollectionViewLayout2: UICollectionViewLayout {
    typealias Attributes = GanttChartCollectionViewLayoutAttributes
    
    var config: GanttChartConfiguration {
        didSet {
            shouldPrepare = true
        }
    }
    var shouldPrepare = true
    
    init(config: GanttChartConfiguration) {
        self.config = config
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cachedAttributesArr: [[Attributes]] = []
    var cachedFrames: [[CGRect]] = []
    
    override var collectionViewContentSize: CGSize {
        config.collectionViewContentSize
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        guard shouldPrepare else { return }
        
        shouldPrepare = false
        cachedAttributesArr.removeAll()
        cachedFrames.removeAll()
        
        for section in 0..<collectionView.numberOfSections {
            var sectionArributes: [Attributes] = []
            var sectionFrames: [CGRect] = []
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = Attributes(forCellWith: indexPath)
                let frame = config.cellFrame(at: indexPath)
                let cellType = config.cellType(at: indexPath)
                
                attributes.frame = frame
                
                switch cellType {
                case .todayVerticalLine:
                    attributes.zIndex = 11
                case .itemCell:
                    attributes.zIndex = 10
                default:
                    attributes.zIndex = 9
                }
                
                sectionArributes.append(attributes)
                sectionFrames.append(frame)
            }
            
            cachedAttributesArr.append(sectionArributes)
            cachedFrames.append(sectionFrames)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        print("layout")
        return cachedAttributesArr[indexPath.section][indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        var attributesArr: [UICollectionViewLayoutAttributes] = []
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = cachedAttributesArr[indexPath.section][indexPath.item]
                let frame = cachedFrames[indexPath.section][indexPath.item]
                let collectionViewOffsetX = collectionView.contentOffset.x
                
                if frame.intersects(rect) {
                    if config.cellType(at: indexPath) == .itemCell {
                        if frame.origin.x <= collectionViewOffsetX {
                            let translationX = collectionViewOffsetX - frame.origin.x
                            let width = frame.width - translationX
                            let newFrame = CGRect(x: collectionViewOffsetX,
                                                  y: frame.origin.y,
                                                  width: width,
                                                  height: frame.height)
                            
                            attributes.frame = newFrame
                            attributes.isOffsetXLessThanCollectionView = true
                        } else {
                            attributes.frame = frame
                            attributes.isOffsetXLessThanCollectionView = false
                        }
                    }
                    
                    attributesArr.append(attributes)
                }
            }
        }
        
        return attributesArr
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}

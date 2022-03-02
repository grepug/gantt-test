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
    
    var cachedSupplementaryViewAttributesArr: [Attributes] = []
    
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
        cachedSupplementaryViewAttributesArr.removeAll()
        
        for section in 0..<collectionView.numberOfSections {
            var sectionArributes: [Attributes] = []
            var sectionFrames: [CGRect] = []
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = Attributes(forCellWith: indexPath)
                let frame = config.cellFrame(at: indexPath)
                let cellType = config.cellType(at: indexPath)
                
                attributes.frame = frame
                attributes.zIndex = cellType.zIndex
                
                sectionArributes.append(attributes)
                sectionFrames.append(frame)
            }
            
            cachedAttributesArr.append(sectionArributes)
            cachedFrames.append(sectionFrames)
        }
        
        for kind in GanttChartConfiguration.ElementKind.allCases {
            let frame = config.supplementaryViewFrame(for: kind)
            let attributes = Attributes(forSupplementaryViewOfKind: kind.rawValue, with: kind.indexPath)
            
            attributes.frame = frame
            attributes.zIndex = kind.zIndex
            
            cachedSupplementaryViewAttributesArr.append(attributes)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedAttributesArr[indexPath.section][indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        var attributesArr: [UICollectionViewLayoutAttributes] = []
        
        for section in 0..<collectionView.numberOfSections {
            var currentItemCellFrame: CGRect?
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let cellType = config.cellType(at: indexPath)
                let attributes = cachedAttributesArr[indexPath.section][indexPath.item]
                let frame = cachedFrames[indexPath.section][indexPath.item]
                
                switch cellType {
                case .itemCell:
                    currentItemCellFrame = attributes.frame
                    
                    if frame.intersects(rect) {
                        attributesArr.append(attributes)
                    }
                case .itemLabelCell:
                    layoutItemLabelCell(itemCellFrame: currentItemCellFrame!,
                                        itemLabelCellOriginalFrame: frame,
                                        itemLabelCellAttributes: attributes,
                                        in: rect,
                                        at: indexPath)
                    
                    attributesArr.append(attributes)
                default:
                    if frame.intersects(rect) {
                        attributesArr.append(attributes)
                    }
                }
            }
        }
        
        for attributes in cachedSupplementaryViewAttributesArr {
            if attributes.frame.intersects(rect) {
                attributesArr.append(attributes)
            }
        }
        
        return attributesArr
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print(elementKind)
        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}

private extension GanttCollectionViewLayout2 {
    func layoutItemLabelCell(itemCellFrame: CGRect,
                             itemLabelCellOriginalFrame: CGRect,
                             itemLabelCellAttributes: Attributes,
                             in rect: CGRect,
                             at indexPath: IndexPath) {
        let collectionView = collectionView!
        let collectionViewOffsetX = collectionView.contentOffset.x
        let collectionViewWidth = collectionView.bounds.width
        let collectionViewTrailingOffsetX = collectionViewOffsetX + collectionViewWidth
        let labelFrame = itemLabelCellAttributes.frame
        let rect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let itemIntersectedFrame = itemCellFrame.intersection(rect)
        
        let x: CGFloat
        
        if itemIntersectedFrame.width > labelFrame.width {
            itemLabelCellAttributes.isIntersectedWithItemCell = true
            x = itemIntersectedFrame.minX
        } else {
            itemLabelCellAttributes.isIntersectedWithItemCell = false
            
            if itemIntersectedFrame.width > 0 {
                if collectionViewOffsetX > itemCellFrame.minX {
                    x = itemCellFrame.maxX
                } else {
                    x = itemCellFrame.minX - labelFrame.width
                }
            }
            
            else if collectionViewOffsetX > itemCellFrame.maxX {
                x = collectionViewOffsetX
            }
            
            else {
                x = collectionViewTrailingOffsetX - labelFrame.width
            }
        }
        
        itemLabelCellAttributes.frame = CGRect(x: x,
                                               y: labelFrame.minY,
                                               width: labelFrame.width,
                                               height: labelFrame.height)
    }
}

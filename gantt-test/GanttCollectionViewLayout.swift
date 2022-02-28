//
//  GanttCollectionViewLayout.swift
//  gantt-test
//
//  Created by Kai on 2022/2/24.
//

import UIKit

protocol GanttCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, sizeForColumn column: Int) -> CGSize
    func numberOfColumns() -> Int
    func safeAreaTop() -> CGFloat
    func contentSizeDidCalcualte(contentSize: CGSize)
}

class GanttCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: GanttCollectionViewLayoutDelegate!
    
    var itemAttributes: [[UICollectionViewLayoutAttributes]] = []
    var contentSize: CGSize = .zero {
        didSet {
            delegate.contentSizeDidCalcualte(contentSize: contentSize)
        }
    }
    var itemsSizes: [CGSize] = []
    
    var safeAreaTop: CGFloat {
        delegate.safeAreaTop()
    }
    
    override var collectionViewContentSize: CGSize {
        contentSize
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        if collectionView.numberOfSections == 0 {
            return
        }
        
        if itemAttributes.count != collectionView.numberOfSections {
            makeItemAttributes()
            return
        }
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                if section != 0 && item != 0 {
                    continue
                }

                let attributes = layoutAttributesForItem(at: .init(item: item, section: section))!
                if section == 0 {
                    attributes.frame.origin.y = collectionView.contentOffset.y + safeAreaTop

                    print("y", collectionView.contentOffset.y,
                          attributes.frame.origin.y,
                          collectionView.frame.maxY,
                          collectionView.frame.height,
                          collectionView.frame.minY)
                }

                if item == 0 {
                    attributes.frame.origin.x = collectionView.contentOffset.x
                }
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        
        for section in itemAttributes {
            for item in section {
                if rect.intersects(item.frame) {
                    attributes.append(item)
                }
            }
        }
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        itemAttributes[indexPath.section][indexPath.item]
    }
}

private extension GanttCollectionViewLayout {
    func makeItemAttributes() {
        let columns = delegate.numberOfColumns()
        let collectionView = collectionView!
        
        if itemsSizes.count != columns {
            calculateItemSizes()
        }
        
        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        
        itemAttributes = []
        
        for section in 0..<collectionView.numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []
            
            for index in 0..<columns {
                let itemSize = itemsSizes[index]
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                
                switch (section, index) {
                case (0, 0):
                    attributes.zIndex = 1024
                case (_, 0), (0, _):
                    attributes.zIndex = 1023
                default: break
                }
                
                if section == 0 {
                    attributes.frame.origin.y = collectionView.contentOffset.y + safeAreaTop
                }
                
                if index == 0 {
                    attributes.frame.origin.x = collectionView.contentOffset.x
                }
                
                sectionAttributes.append(attributes)
                
                xOffset += itemSize.width
                column += 1
                
                if column == columns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }
            
            itemAttributes.append(sectionAttributes)
        }
        
        if let attributes = itemAttributes.last?.last {
            contentSize = .init(width: contentWidth, height: attributes.frame.maxY)
        }
    }
    
    func calculateItemSizes() {
        itemsSizes = []
        
        let columns = delegate.numberOfColumns()
            
        for index in 0..<columns {
            let itemSize = delegate.collectionView(collectionView!,
                                                   sizeForColumn: index)
            
            itemsSizes.append(itemSize)
        }
    }
}

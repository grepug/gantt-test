//
//  GanttChartCollectionViewLayoutAttributes.swift
//  gantt-test
//
//  Created by Kai on 2022/3/1.
//

import UIKit

final class GanttChartCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var isIntersectedWithItemCell = false
    
    override func copy(with zone: NSZone?) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? GanttChartCollectionViewLayoutAttributes else {
            return super.copy(with: zone)
        }
        
        copiedAttributes.isIntersectedWithItemCell = isIntersectedWithItemCell
        return copiedAttributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? GanttChartCollectionViewLayoutAttributes else {
            return false
        }
        
        if otherAttributes.isIntersectedWithItemCell != isIntersectedWithItemCell {
            return false
        }
        
        return super.isEqual(object)
    }
}

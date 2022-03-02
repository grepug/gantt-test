//
//  GanttChartCollectionView.swift
//  gantt-test
//
//  Created by Kai on 2022/3/2.
//

import UIKit


class GanttChartCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    typealias ElementKind = GanttChartConfiguration.ElementKind
    
    var chartConfig: GanttChartConfiguration
    var layout: GanttCollectionViewLayout
    
    var contextMenuConfiguration: ((GanttChartItem, Int) -> UIContextMenuConfiguration?)?
    
    init(frame: CGRect, chartConfig: GanttChartConfiguration) {
        self.layout = GanttCollectionViewLayout()
        self.chartConfig = chartConfig
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        layout.config = chartConfig
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GanttChartCollectionView {
    func setup() {
        
    }
    
    func scrollsToToday() {
        let point = chartConfig.todayPoint(in: bounds, y: contentOffset.y)
        setContentOffset(point, animated: true)
    }
}

private extension GanttChartCollectionView {
    func registerCells() {
        for kind in GanttChartCellType.allCases {
            switch kind {
            case .itemCell:
                register(GanttChartItemCell.self,
                                        forCellWithReuseIdentifier: kind.rawValue)
            case .itemLabelCell:
                register(GanttChartItemLabelCell.self,
                                        forCellWithReuseIdentifier: kind.rawValue)
            default:
                register(UICollectionViewCell.self,
                                        forCellWithReuseIdentifier: kind.rawValue)
            }
        }
        
        register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: ElementKind.todayVerticalLine.rawValue,
                                withReuseIdentifier: "1")
    }
}

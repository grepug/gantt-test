//
//  GanttCollectionViewController.swift
//  gantt-test
//
//  Created by Kai on 2022/2/28.
//

import UIKit

class GanttCollectionViewController: UICollectionViewController {
    var chartConfig: GanttChartConfiguration
    var layout: GanttCollectionViewLayout2
    
    init() {
        let date1 = "2022-01-01 12:00:00".toDate()!
        let date2 = "2022-02-28 13:00:00".toDate()!
        
        let date3 = "2022-02-05 12:00:00".toDate()!
        let date4 = "2022-04-28 13:00:00".toDate()!
        
        let date5 = "2022-01-20 12:00:00".toDate()!
        let date6 = "2022-03-05 13:00:00".toDate()!
        
        let date7 = "2021-12-05 12:00:00".toDate()!
        let date8 = "2022-04-28 13:00:00".toDate()!
        
        let config = GanttChartConfiguration(items: [
            .init(startDate: date1, endDate: date2, title: "第一个目标", progress: 0, color: .systemRed),
            .init(startDate: date3, endDate: date4, title: "健康身体棒", progress: 0, color: .systemGreen),
            .init(startDate: date5, endDate: date6, title: "健康身体棒", progress: 0, color: .systemBlue),
            .init(startDate: date7, endDate: date8, title: "健康身体棒", progress: 0, color: .systemPink),
        ], leadingCompensatedMonths: 1, trailingCompensatedMonths: 1)
        
        let layout = GanttCollectionViewLayout2(config: config)
        
        self.layout = layout
        self.chartConfig = config
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Gantt Chart"
        
        for kind in GanttChartCellType.allCases {
            collectionView.register(UICollectionViewCell.self,
                                    forCellWithReuseIdentifier: kind.rawValue)
        }
        
        collectionView.reloadData()
    }
}

extension GanttCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        chartConfig.items.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chartConfig.collectionViewNumberOfItem(in: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = chartConfig.cellType(at: indexPath)
        let kind = cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kind, for: indexPath)
        
        switch cellType {
        case .itemCell:
            let item = chartConfig.chartItem(at: indexPath)
            cell.backgroundColor = item.color
            cell.layer.cornerRadius = 12
            var config = UIListContentConfiguration.cell()
            config.text = item.title
            cell.contentConfiguration = config
        case .fixedHeaderCell:
            let config = FixedHeaderCellConfiguration(date: chartConfig.bgCell(at: indexPath).dateOfStart)
            cell.contentConfiguration = config
        case .bgCell, .fixedColumnCell:
            cell.contentConfiguration = BgCellConfiguration(index: indexPath.section)
        default: break
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let cellType = chartConfig.cellType(at: indexPath)
        
        guard cellType == .itemCell else { return nil }
        
        return .init(identifier: indexPath as NSCopying,
                     previewProvider: nil) { _ in
                .init(children: [
                    UIAction(title: "编辑", image: .init(systemName: "pencil"), handler: { _ in
                        
                    })
                ])
        }
    }
}

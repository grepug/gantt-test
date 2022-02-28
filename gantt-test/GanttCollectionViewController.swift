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
        
        let config = GanttChartConfiguration(items: [
            .init(startDate: date1, endDate: date2, title: "第一个目标", progress: 0, color: .systemRed),
            .init(startDate: date3, endDate: date4, title: "健康身体棒", progress: 0, color: .systemGreen),
        ], leadingCompensatedMonths: 2, trailingCompensatedMonths: 2)
        
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
        
        var config = UIListContentConfiguration.cell()
        config.text = kind
        
        if cellType == .itemCell {
            let item = chartConfig.chartItem(at: indexPath)
            
            cell.backgroundColor = item.color
            cell.layer.cornerRadius = 12
            config.text = item.title
        } else {
            cell.layer.cornerRadius = 0
            
            if indexPath.section % 2 != 0 {
                cell.backgroundColor = UIColor(white: 242/255, alpha: 1)
            } else {
                cell.backgroundColor = .white
            }
        }
        
        cell.contentConfiguration = config
        
        return cell
    }
}

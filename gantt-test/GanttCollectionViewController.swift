//
//  GanttCollectionViewController.swift
//  gantt-test
//
//  Created by Kai on 2022/2/28.
//

import UIKit

class GanttCollectionViewController: UICollectionViewController {
    typealias ElementKind = GanttChartConfiguration.ElementKind
    
    var chartConfig: GanttChartConfiguration
    var layout: GanttCollectionViewLayout2
    let chartStyleBarItem: UIBarButtonItem = .init(title: "")
    
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
            .init(startDate: date1, endDate: date2, title: "第一个目标第一个目标第一个目标第一个目标第一个目标", progress: 0.5, color: .systemMint),
            .init(startDate: date3, endDate: date4, title: "健康身体棒", progress: 0.2, color: .systemGreen),
            .init(startDate: date5, endDate: date6, title: "健康身体棒", progress: 0.8, color: .systemBlue),
            .init(startDate: date7, endDate: date8, title: "健康身体棒", progress: 0.3, color: .systemPurple),
        ], cycles: [.init(startDate: date1, endDate: date8)])
        
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
            switch kind {
            case .itemCell:
                collectionView.register(GanttChartItemCell.self,
                                        forCellWithReuseIdentifier: kind.rawValue)
            case .itemLabelCell:
                collectionView.register(GanttChartItemLabelCell.self,
                                        forCellWithReuseIdentifier: kind.rawValue)
            default:
                collectionView.register(UICollectionViewCell.self,
                                        forCellWithReuseIdentifier: kind.rawValue)
            }
        }
        
        collectionView.register(GanttChartCycleFrameReusableView.self,
                                forSupplementaryViewOfKind: ElementKind.cycleFrame.rawValue,
                                withReuseIdentifier: "1")
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: ElementKind.todayVerticalLine.rawValue,
                                withReuseIdentifier: "1")
        
        collectionView.reloadData()
        
        chartStyleBarItem.menu = UIMenu(children: GanttCalendarHeaderStyle.allCases.map { style in
            UIAction(title: style.text) { [weak self] _ in
                self?.changeChartStyle(to: style)
            }
        })
        chartStyleBarItem.title = chartConfig.headerStyle.text
        
        let backToTodayButton = UIBarButtonItem(title: "回到今天", primaryAction: .init { [weak self] _ in
            guard let self = self else { return }
            
            let navTop = self.navigationController!.navigationBar.frame.maxY
            let point = self.chartConfig.todayPoint(in: self.collectionView.bounds,
                                                    y: -navTop)
            self.collectionView.setContentOffset(point, animated: true)
        })
        
        navigationItem.rightBarButtonItems = [chartStyleBarItem, backToTodayButton]
    }
    
    func changeChartStyle(to style: GanttCalendarHeaderStyle) {
        let chartConfig = GanttChartConfiguration(style: style,
                                                  items: chartConfig.items,
                                                  cycles: chartConfig.cycles)
        chartStyleBarItem.title = style.text
        layout.config = chartConfig
        self.chartConfig = chartConfig
        
        collectionView.reloadData()
    }
}

extension GanttCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        chartConfig.items.count + 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = chartConfig.collectionViewNumberOfItem(in: section)
        
        print(section, count)
        
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = chartConfig.cellType(at: indexPath)
        let kind = cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kind, for: indexPath)
        
        switch cellType {
        case .itemCell:
            let cell = cell as! GanttChartItemCell
            let item = chartConfig.chartItem(at: indexPath)
            
            cell.applyConfiguration(item: item)
        case .itemLabelCell:
            let cell = cell as! GanttChartItemLabelCell
            let item = chartConfig.chartItem(at: indexPath)
            
            cell.applyConfigurations(item: item)
        case .fixedHeaderCell:
            cell.contentConfiguration = chartConfig.fixedHeaderTopCellConfiguration(at: indexPath)
        case .bgCell, .fixedColumnCell:
            cell.contentConfiguration = BgCellConfiguration(index: indexPath.section)
        case .fixedHeaderDayCell:
            let day = chartConfig.dayCell(at: indexPath)
            let textLabel: UILabel
            
            if let label = cell.contentView.subviews.first(where: { $0.tag == 1 }) as? UILabel {
                textLabel = label
            } else {
                textLabel = UILabel()
                textLabel.tag = 1
                cell.contentView.addSubview(textLabel)
                textLabel.frame = cell.contentView.bounds
                textLabel.textAlignment = .center
                textLabel.adjustsFontSizeToFitWidth = true
                textLabel.font = .preferredFont(forTextStyle: .footnote)
            }

            textLabel.text = "\(day.day)"
        case .fixedFirstCell: break
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "1", for: indexPath)
        let kindEnum = ElementKind(rawValue: kind)!
        
        switch kindEnum {
        case .cycleFrame:
            let view = view as! GanttChartCycleFrameReusableView
            
            view.applyConfigurations()
        case .todayVerticalLine:
            view.backgroundColor = .systemRed.withAlphaComponent(0.8)
        }
        
        return view
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let cellType = chartConfig.cellType(at: indexPath)
        
        guard cellType == .itemCell else { return nil }
        
        let item = chartConfig.chartItem(at: indexPath)
        
        return .init(identifier: indexPath as NSCopying,
                     previewProvider: {
            GanttChartItemPreviewView.makeViewController(title: item.title)
        }) { _ in
                .init(children: [
                    UIAction(title: "编辑", image: .init(systemName: "pencil"), handler: { _ in
                        
                    })
                ])
        }
    }
}

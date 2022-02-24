//
//  ViewController.swift
//  gantt-test
//
//  Created by Kai on 2022/2/22.
//

import UIKit

class ViewController: UIViewController {
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = GanttCollectionViewLayout()
        layout.delegate = self
        
        collectionView = .init(frame: view.bounds,
                               collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "hi")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        title = "Gantt"
    }
}


extension ViewController: GanttCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForColumn column: Int) -> CGSize {
        .init(width: 100, height: 50)
    }
    
    func numberOfColumns() -> Int {
        8
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        50
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hi", for: indexPath)
        
        var config = UIListContentConfiguration.cell()
        config.text = "1"
            
        if indexPath.section % 2 != 0 {
            cell.backgroundColor = UIColor(white: 242/255, alpha: 1)
        } else {
            cell.backgroundColor = .white
        }
        
//        switch (indexPath.section, indexPath.section) {
//        case (0, 0): config.text = "Date"
//        case (0, _): config.text = "Section"
//        case (_, 0): config.text = String(indexPath.section)
//        default: config.text = "Content"
//        }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                config.text = "Date"
            } else {
                config.text = "Section"
            }
        } else {
            if indexPath.row == 0 {
                config.text = String(indexPath.section)
            } else {
                config.text = "Content"
            }
        }
        
        cell.contentConfiguration = config
        
        return cell
    }
}

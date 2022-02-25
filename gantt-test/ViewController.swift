//
//  ViewController.swift
//  gantt-test
//
//  Created by Kai on 2022/2/22.
//

import UIKit

class ViewController: UICollectionViewController {
    let layout = GanttCollectionViewLayout()
    lazy var dividerLayer = CALayer()
    
    init() {
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "hi")
        view.layer.addSublayer(dividerLayer)
        
        title = "Gantt"
    }
    
    func configDividerLayer(height: CGFloat) {
        dividerLayer.frame = CGRect(x: 60, y: safeAreaTop(), width: 2, height: height)
        dividerLayer.backgroundColor = UIColor.green.cgColor
    }
}


extension ViewController: GanttCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForColumn column: Int) -> CGSize {
        if column == 0 {
            return .init(width: 60, height: 50)
        }
        
        return .init(width: 100, height: 50)
    }
    
    func numberOfColumns() -> Int {
        400
    }
    
    func safeAreaTop() -> CGFloat {
        navigationController?.navigationBar.frame.maxY ?? 0
    }
    
    func contentSizeDidCalcualte(contentSize: CGSize) {
        configDividerLayer(height: contentSize.height - safeAreaTop())
    }
}

extension ViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        20
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        400
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hi", for: indexPath)
        
        var config = UIListContentConfiguration.cell()
        config.text = "1"
            
        if indexPath.section % 2 != 0 {
            cell.backgroundColor = UIColor(white: 242/255, alpha: 1)
        } else {
            cell.backgroundColor = .white
        }
        
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
        
        
//        if !(indexPath.item == 0 && indexPath.section == 0) {
//            if indexPath.item == 0 {
//                cell.addRightBorder(with: .lightGray, andWidth: 2)
//            } else {
//                cell.subviews.forEach {
//                    if $0.tag == 1 {
//                        $0.removeFromSuperview()
//                    }
//                }
//            }
//
//            if indexPath.section == 0 {
//                cell.addBottomBorder(with: .lightGray, andWidth: 2)
//            } else {
//                cell.subviews.forEach {
//                    if $0.tag == 2 {
//                        $0.removeFromSuperview()
//                    }
//                }
//            }
//        }
        cell.addTopAndBottomBorders()
        
        cell.contentConfiguration = config
        
        return cell
    }
}

extension UIView {
    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.tag = 1
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }
    
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.tag = 2
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    
    func addTopAndBottomBorders() {
       let thickness: CGFloat = 2.0
       let topBorder = CALayer()
       let bottomBorder = CALayer()
       topBorder.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: thickness)
       topBorder.backgroundColor = UIColor.red.cgColor
       bottomBorder.frame = CGRect(x:0, y: frame.size.height - thickness, width: frame.size.width, height:thickness)
       bottomBorder.backgroundColor = UIColor.red.cgColor
       layer.addSublayer(topBorder)
       layer.addSublayer(bottomBorder)
    }
}

//
//  FixedHeaderCellConfiguration.swift
//  gantt-test
//
//  Created by Kai on 2022/2/28.
//

import UIKit

import UIKit

struct FixedHeaderCellConfiguration: UIContentConfiguration {
    var date: Date
    
    func makeContentView() -> UIView & UIContentView {
        View(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        self
    }
}

extension FixedHeaderCellConfiguration {
    class View: UIView & UIContentView {
        typealias Config = FixedHeaderCellConfiguration
        
        lazy var stackView = UIStackView()
        lazy var topLabel = makeTopLabel()
        lazy var bottomView = makeBottomView()
        
        var configuration: UIContentConfiguration {
            didSet {
                let config = configuration as! Config
                
                apply(config: config)
            }
        }
        
        var config: Config {
            configuration as! Config
        }
        
        init(configuration: Config) {
            self.configuration = configuration
            super.init(frame: .zero)
            
            setupViews(config: configuration)
            apply(config: configuration)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension FixedHeaderCellConfiguration.View {
    func setupViews(config: Config) {
        stackView = UIStackView(frame: bounds)
        stackView.addArrangedSubview(topLabel)
        stackView.addArrangedSubview(bottomView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
    }
    
    func apply(config: Config) {
        stackView.frame = bounds
        
        let components = Calendar.current.dateComponents([.month, .year], from: config.date)
        let month = components.month!
        let year = components.year!
        let yearText = month == 1 ? "\(year)年" : ""
        topLabel.text = yearText + "\(month)月"
        topLabel.font = .preferredFont(forTextStyle: .headline)
    }
}

private extension FixedHeaderCellConfiguration.View {
    func makeTopLabel() -> UILabel {
        let label = UILabel()
 
        
        return label
    }
    
    func makeBottomView() -> UIView {
        let stackView = UIStackView()
        let daysLabelViews = makeDayLabelViews()
        
        stackView.axis = .horizontal
        
        daysLabelViews.forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.distribution = .fillEqually
        
        return stackView
    }
    
    func makeDayLabelViews() -> [UILabel] {
        var views: [UILabel] = []
        
        for day in 1...config.date.daysInMonth() {
            let label = UILabel()
            label.text = "\(day)"
            label.textAlignment = .center
            views.append(label)
            
            if !(day % 7 == 0 || day == 1) {
                label.textColor = .clear
            }
        }
        
        return views
    }
}

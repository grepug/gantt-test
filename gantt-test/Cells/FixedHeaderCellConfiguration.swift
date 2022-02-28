//
//  FixedHeaderCellConfiguration.swift
//  gantt-test
//
//  Created by Kai on 2022/2/28.
//

import UIKit

import UIKit

struct FixedHeaderCellConfiguration: UIContentConfiguration {
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
        
        var configuration: UIContentConfiguration {
            didSet {
                let config = configuration as! Config
                
                apply(config: config)
            }
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
        
    }
    
    func apply(config: Config) {
        
    }
}


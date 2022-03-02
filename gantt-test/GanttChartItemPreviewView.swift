//
//  GanttChartItemPreviewView.swift
//  gantt-test
//
//  Created by Kai on 2022/3/2.
//

import SwiftUI

struct GanttChartItemPreviewView: View {
    var title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
        }
    }
}

extension GanttChartItemPreviewView {
    static func makeViewController(title: String) -> UIViewController {
        let view = GanttChartItemPreviewView(title: title)
        
        return UIHostingController(rootView: view)
    }
}

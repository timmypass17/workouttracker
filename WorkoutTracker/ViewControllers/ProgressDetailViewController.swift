//
//  ProgressDetailViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/8/23.
//

import UIKit
import SwiftUI

class ProgressDetailViewController: UIViewController {
    
    let data: ProgressData
    
    init?(coder: NSCoder, data: ProgressData) {
        self.data = data
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = data.name
        
        let progressDetailView = ProgressDetailView(data: data)
        let hostingController = UIHostingController(rootView: progressDetailView)
        
        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Set up layout constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
    }
}

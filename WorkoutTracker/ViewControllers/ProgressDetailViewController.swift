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
        
        let sampleData = ProgressData(
            name: "Squat",
            data: [
                Exercise(name: "Squat", sets: "3", reps: "5", weight: "45", date: Date()),
                Exercise(name: "Squat", sets: "3", reps: "5", weight: "65", date: Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())),
                Exercise(name: "Squat", sets: "3", reps: "5", weight: "50", date: Calendar.current.date(byAdding: .weekOfYear, value: 2, to: Date())),
                Exercise(name: "Squat", sets: "3", reps: "5", weight: "55", date: Calendar.current.date(byAdding: .weekOfYear, value: 3, to: Date())),
                Exercise(name: "Squat", sets: "3", reps: "5", weight: "60", date: Calendar.current.date(byAdding: .weekOfYear, value: 4, to: Date())),
                Exercise(name: "Squat", sets: "3", reps: "5", weight: "60", date: Calendar.current.date(byAdding: .weekOfYear, value: 5, to: Date())),
                Exercise(name: "Squat", sets: "3", reps: "5", weight: "65", date: Calendar.current.date(byAdding: .weekOfYear, value: 6, to: Date()))
            ].reversed()
        )
        
        let progressDetailView = ProgressDetailView(data: data) // TODO: Use data
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

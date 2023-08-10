//
//  ProgressTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/7/23.
//

import UIKit
import SwiftUI

class ProgressData: ObservableObject {
    @Published var name: String
    @Published var data: [Exercise]
    
    init(name: String, data: [Exercise]) {
        self.name = name
        self.data = data
    }
}

class ProgressTableViewController: UITableViewController {
    
    // TODO: Use array instead of dict
    var data: [ProgressData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = LoggedWorkout.shared.loggedWorkoutsBySection.values
            .flatMap { $0 }
            .flatMap { $0.exercises }
            .reduce(into: [String: [Exercise]]()) { dict, exercise in
                dict[exercise.name, default: []].append(exercise)
            }
            .map { ProgressData(name: $0.key, data: $0.value)}
            .sorted { $0.name < $1.name }
        
        for progress in data {
            print("\(progress.name): \(progress.data)")
        }
        
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(handleLogDataChanged),
            name: LoggedWorkout.logUpdatedNotification, object: nil
        )
    }
    
    @objc func handleLogDataChanged() {
        print("handleLogDataChanged")
        data = LoggedWorkout.shared.loggedWorkoutsBySection.values
            .flatMap { $0 }
            .flatMap { $0.exercises }
            .reduce(into: [String: [Exercise]]()) { dict, exercise in
                dict[exercise.name, default: []].append(exercise)
            }
            .map { ProgressData(name: $0.key, data: $0.value)}
            .sorted { $0.name < $1.name }
        

        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let sectionIndex = Array(data.keys)[section]
//        return data[sectionIndex]?.count ?? 0
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseProgressCell", for: indexPath)
        let exercisesInSection = data[indexPath.row]
        
        // Create custom cells using SwiftUI
        cell.contentConfiguration = UIHostingConfiguration {
            ExerciseProgressCellView(data: exercisesInSection.data)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Exercises"
    }
    
    @IBSegueAction func showProgressDetail(_ coder: NSCoder, sender: Any?) -> ProgressDetailViewController? {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let item = data[indexPath.row]
        return ProgressDetailViewController(coder: coder, data: item)
        
    }
}

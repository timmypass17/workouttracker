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
    
    @IBOutlet var sortBarButton: UIBarButtonItem!
    
    var data: [ProgressData] = []
    
    var sortByWeight: (ProgressData, ProgressData) -> Bool = { exercise, otherExercise in
        let maxWeightExercise = exercise.data.max(by: { $0.weight < $1.weight })?.weight ?? "0"
        let maxWeightOtherExercise = otherExercise.data.max(by: { $0.weight < $1.weight })?.weight ?? "0"
        return Float(maxWeightExercise) ?? 0 > Float(maxWeightOtherExercise) ?? 0
    }
    
    var sortByRecentlyUpdated: (ProgressData, ProgressData) -> Bool = { exercise, otherExercise in
        let mostRecentExercise = exercise.data.max(by: { $0.date! < $1.date! })!
        let mostRecentOtherExercise = otherExercise.data.max(by: { $0.date! < $1.date! })!
        return mostRecentExercise.date! > mostRecentOtherExercise.date!
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Alphabetical (A-Z)", image: UIImage(systemName: "a.square.fill")) { _ in
                // Handle sorting alphabetically
                self.data.sort { $0.name < $1.name }
                self.tableView.reloadData()
                Settings.shared.sortingPreference = .alphabetically
            },
            UIAction(title: "Weight", image: UIImage(systemName: "dumbbell")) { _ in
                // Handle sorting by weight
                self.data.sort(by: self.sortByWeight)
                self.tableView.reloadData()
                Settings.shared.sortingPreference = .weight
            },
            UIAction(title: "Recently Updated", image: UIImage(systemName: "clock")) { _ in
                // Handle sorting by weight
                self.data.sort(by: self.sortByRecentlyUpdated)
                self.tableView.reloadData()
                Settings.shared.sortingPreference = .recent
            }
        ]
    }

    var demoMenu: UIMenu {
        return UIMenu(title: "Sort By", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    func updateUI() {
        data = LoggedWorkout.shared.loggedWorkoutsBySection.values
            .flatMap { $0 }
            .flatMap { $0.exercises }
            .reduce(into: [String: [Exercise]]()) { dict, exercise in
                dict[exercise.name, default: []].append(exercise)
            }
            .map { ProgressData(name: $0.key, data: $0.value)}
        
        switch Settings.shared.sortingPreference {
        case .alphabetically:
            self.data.sort { $0.name < $1.name }
        case .weight:
            self.data.sort(by: self.sortByWeight)
        case .recent:
            self.data.sort(by: self.sortByRecentlyUpdated)
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        sortBarButton.menu = demoMenu

        NotificationCenter.default.addObserver(self,
            selector: #selector(handleLogDataChanged),
            name: LoggedWorkout.logUpdatedNotification, object: nil
        )
    }
    
    @objc func handleLogDataChanged() {
        print("handleLogDataChanged")
        updateUI()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseProgressCell", for: indexPath)
        let exercisesInSection = data[indexPath.row]
        exercisesInSection.data.sort(by: { $0.date! > $1.date! })

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
        var item = data[indexPath.row]
        item.data.sort(by: { $0.date! > $1.date! })
        return ProgressDetailViewController(coder: coder, data: item)
    }
}

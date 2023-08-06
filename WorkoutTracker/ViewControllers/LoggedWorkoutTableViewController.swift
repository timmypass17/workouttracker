//
//  LogTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/4/23.
//

import UIKit

class LoggedWorkoutTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        NotificationCenter.default.addObserver(tableView!,
            selector: #selector(UITableView.reloadData),
            name: LoggedWorkout.logUpdatedNotification, object: nil
        )
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoggedWorkout.shared.loggedWorkouts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoggedWorkoutCell", for: indexPath) as! LoggedWorkoutTableViewCell
        let workout = LoggedWorkout.shared.loggedWorkouts[indexPath.row]
        cell.update(with: workout)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            LoggedWorkout.shared.loggedWorkouts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            LoggedWorkout.saveWorkoutLogs(LoggedWorkout.shared.loggedWorkouts)
        }
    }

}

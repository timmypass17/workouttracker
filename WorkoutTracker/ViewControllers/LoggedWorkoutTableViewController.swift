//
//  LogTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/4/23.
//

import UIKit

class LoggedWorkoutTableViewController: UITableViewController {
        
    var workoutLogs: [String: [Workout]] {
        get {
            return LoggedWorkout.shared.loggedWorkoutsBySection
        }
        set {
            LoggedWorkout.shared.loggedWorkoutsBySection = newValue
        }
    }
    
    var sortedMonths: [String]  {
        return workoutLogs.keys.sorted { (string1, string2) -> Bool in
            if let date1 = monthYearDateFormatter.date(from: string1), let date2 = monthYearDateFormatter.date(from: string2) {
                return date1 > date2
            }
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()

        NotificationCenter.default.addObserver(self,
            selector: #selector(updateView),
            name: LoggedWorkout.logUpdatedNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(tableView!,
            selector: #selector(UITableView.reloadData),
            name: WeightType.weightUnitUpdatedNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(tableView!,
            selector: #selector(UITableView.reloadData),
            name: AccentColor.accentColorUpdatedNotification, object: nil
        )
    }
    
    @objc func updateView() {
        tableView.backgroundView = emptyWorkoutDataLabel
        let isWorkoutDataEmpty = workoutLogs.isEmpty
        tableView.backgroundView?.isHidden = isWorkoutDataEmpty ? false : true
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        clearBadge()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return workoutLogs.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let month = sortedMonths[section]
        return workoutLogs[month]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoggedWorkoutCell", for: indexPath) as! LoggedWorkoutTableViewCell
        
        let month = sortedMonths[indexPath.section]
        let workout = workoutLogs[month]![indexPath.row]
        cell.update(with: workout)
        
        return cell
    }

    @IBSegueAction func showWorkoutDetail(_ coder: NSCoder, sender: Any?) -> AddEditWorkoutTableViewController? {
        let cell = sender as! UITableViewCell
        
        let indexPath = tableView.indexPath(for: cell)!
        let month = sortedMonths[indexPath.section]
        let workoutLog = workoutLogs[month]![indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        let addEditWorkoutTableViewController = AddEditWorkoutTableViewController(coder: coder, state: .log(workoutLog))
        return addEditWorkoutTableViewController
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let month = sortedMonths[indexPath.section]
            workoutLogs[month]?.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)

            if workoutLogs[month]!.isEmpty {
                workoutLogs[month] = nil
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else {
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
                        
            LoggedWorkout.saveWorkoutLogs(workoutLogs)
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CustomHeaderView()
        let month = sortedMonths[section]
        headerView.leadingLabel.text = month
        headerView.trailingLabel.text = "\(workoutLogs[month]!.count) Workouts"
        return headerView
    }
    
    @IBAction func unwindToLoggedWorkoutTableView(segue: UIStoryboardSegue) {
        // Capture the new or updated workout from the AddEditWorkoutTableViewController and save it to the workouts property
        guard segue.identifier == "updateUnwind",
              let sourceViewController = segue.source as? AddEditWorkoutTableViewController else {
            return
        }
        
        let workout = sourceViewController.workout
        let sectionKey = formatDateMonthYear(workout.startTime!) // "August 2023"
        
        if let indexOfExistingWorkout = workoutLogs[sectionKey]?.firstIndex(of: workout) {
            workoutLogs[sectionKey]?[indexOfExistingWorkout] = workout
            tableView.reloadRows(at: [IndexPath(row: indexOfExistingWorkout, section: 0)], with: .automatic)
        }
    }
    
    func clearBadge() {
        guard Settings.shared.logBadgeValue > 0 else { return }
        tabBarItem.badgeValue = nil
        Settings.shared.logBadgeValue = 0
        NotificationCenter.default.post(name: LoggedWorkout.logUpdatedNotification, object: nil)
    }
}

//
//  LogTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/4/23.
//

import UIKit

class LoggedWorkoutTableViewController: UITableViewController, AddEditWorkoutTableViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(tableView!,
            selector: #selector(UITableView.reloadData),
            name: LoggedWorkout.logUpdatedNotification, object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        clearBadge()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
        return LoggedWorkout.shared.loggedWorkoutsBySection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return LoggedWorkout.shared.loggedWorkouts.count
        let sectionKey = Array(LoggedWorkout.shared.loggedWorkoutsBySection.keys)[section]
        return LoggedWorkout.shared.loggedWorkoutsBySection[sectionKey]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoggedWorkoutCell", for: indexPath) as! LoggedWorkoutTableViewCell
        
        let sectionKey = Array(LoggedWorkout.shared.loggedWorkoutsBySection.keys)[indexPath.section]
        let workout = LoggedWorkout.shared.loggedWorkoutsBySection[sectionKey]![indexPath.row]
        cell.update(with: workout)
        return cell
    }

    @IBSegueAction func showWorkoutDetail(_ coder: NSCoder, sender: Any?) -> AddEditWorkoutTableViewController? {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!

        let sectionKey = Array(LoggedWorkout.shared.loggedWorkoutsBySection.keys)[indexPath.section]
        let workout = LoggedWorkout.shared.loggedWorkoutsBySection[sectionKey]![indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let addEditWorkoutTableViewController = AddEditWorkoutTableViewController(coder: coder, workout: workout, isLogged: true)
        addEditWorkoutTableViewController?.delegate = self
        return addEditWorkoutTableViewController
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sectionKey = Array(LoggedWorkout.shared.loggedWorkoutsBySection.keys)[indexPath.section]
            LoggedWorkout.shared.loggedWorkoutsBySection[sectionKey]!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            LoggedWorkout.saveWorkoutLogs(LoggedWorkout.shared.loggedWorkoutsBySection)
            
            Settings.shared.logBadgeValue = max(Settings.shared.logBadgeValue - 1, 0)
            NotificationCenter.default.post(name: LoggedWorkout.logUpdatedNotification, object: nil)
        }
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let cell = tableView.cellForRow(at: indexPath) as! LoggedWorkoutTableViewCell
//        
//        let isExpanded = cell.exercisesLabel.numberOfLines == 0
//        cell.exercisesLabel.numberOfLines = isExpanded ? 3 : 0
//        
//        tableView.beginUpdates()
//        tableView.endUpdates()
//    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CustomHeaderView()
        // Configure the leading and trailing labels as needed
        let sectionKey = Array(LoggedWorkout.shared.loggedWorkoutsBySection.keys)[section]
        headerView.leadingLabel.text = sectionKey
        headerView.trailingLabel.text = "\(LoggedWorkout.shared.loggedWorkoutsBySection[sectionKey]!.count) Workouts"
        return headerView
    }
    
    @IBAction func unwindToLoggedWorkoutTableView(segue: UIStoryboardSegue) {
        print("unwindToLoggedWorkoutTableView")
        // Capture the new or updated workout from the AddEditWorkoutTableViewController and save it to the workouts property
        guard segue.identifier == "updateUnwind",
              let sourceViewController = segue.source as? AddEditWorkoutTableViewController,
              let workout = sourceViewController.workout else {
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let sectionKey = dateFormatter.string(from: workout.startTime!) // "August 2023"
        
        if let indexOfExistingWorkout = LoggedWorkout.shared.loggedWorkoutsBySection[sectionKey]?.firstIndex(of: workout) {
            print(workout)
            LoggedWorkout.shared.loggedWorkoutsBySection[sectionKey]![indexOfExistingWorkout] = workout
            tableView.reloadRows(at: [IndexPath(row: indexOfExistingWorkout, section: 0)], with: .automatic)
        }
    }

//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50.0 // Adjust the header height as needed
//    }
    
    func updateWorkout(sender: AddEditWorkoutTableViewController, workout: Workout) {
        // Do nothing. Updates shouldn't happen automatically when viewing logs. User should explicity press "save" to update log
    }
    
    func clearBadge() {
        // Don't want to send notification if badge isn't 0
        guard Settings.shared.logBadgeValue != 0 else { return }
        tabBarItem.badgeValue = nil
        Settings.shared.logBadgeValue = 0
        NotificationCenter.default.post(name: LoggedWorkout.logUpdatedNotification, object: nil)
    }
}

extension String {
    var numberOfLines: Int {
        return self.components(separatedBy: "\n").count
    }
}

class CustomHeaderView: UIView {
    let leadingLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.font = UIFont(name: "AvenirNext-Regular", size: 14.0)

//        label.textColor = .darkText
        return label
    }()

    let trailingLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        label.textAlignment = .right
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStackView()
    }

    private func setupStackView() {
        // Create a horizontal stack view and add the labels to it
        let stackView = UIStackView(arrangedSubviews: [leadingLabel, trailingLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        // Add the stack view to the header view
        addSubview(stackView)

        // Set the constraints for the stack view to fill the header view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        backgroundColor = .systemGroupedBackground

    }
}

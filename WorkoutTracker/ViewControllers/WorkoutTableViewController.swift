//
//  WorkoutTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/26/23.
//

import UIKit

class WorkoutTableViewController: UITableViewController, AddEditWorkoutTableViewControllerDelegate {
    var workouts: [Workout] = []
    
    var emptyLabel: UILabel {
        let label = UILabel()
        label.text = "Your workout data will appear here.\nTap the '+' button to add your first workout."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedWorkouts = Workout.loadWorkouts() {
            workouts = savedWorkouts
        } else {
            workouts = Workout.sampleWorkouts
        }
        
        updateView()
    }
    
    func updateView() {
        tableView.backgroundView = emptyLabel
        tableView.backgroundView?.isHidden = workouts.isEmpty ? false : true
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as! WorkoutTableViewCell
        let workout = workouts[indexPath.row]
        cell.update(with: workout)
        return cell
    }
    
    // MARK: - Editing methods

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            workouts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            Workout.saveWorkouts(workouts)
            updateView()
        }
    }
    
    // MARK: - Naviation methods
    
    @IBSegueAction func showNewWorkout(_ coder: NSCoder) -> AddEditWorkoutTableViewController? {
        // Note: Separated addWorkout and showWorkoutDetail because i want to show one modally and the other as a detail
        // Make sure you drag correct segue (the one between the nav controller and new workout vc) or else u get error
        return AddEditWorkoutTableViewController(coder: coder, state: .new)
    }

    @IBSegueAction func showWorkoutDetail(_ coder: NSCoder, sender: Any?) -> AddEditWorkoutTableViewController? {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let workout = workouts[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            let addEditWorkoutTableViewController = AddEditWorkoutTableViewController(coder: coder, state: .add(workout))
            addEditWorkoutTableViewController?.delegate = self
            return addEditWorkoutTableViewController
        }
        return nil
    }
    
    // User pressed "save" from newWorkout screen
    @IBAction func unwindToWorkoutTableView(segue: UIStoryboardSegue) {
        // Capture the new or updated workout from the AddEditWorkoutTableViewController and save it to the workouts property
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEditWorkoutTableViewController
        else {
            return
        }
        
        let state = sourceViewController.state
        let updatedWorkout = sourceViewController.workout
        
        // tableView.indexPathForSelectedRow
        if case .add(let originalWorkout) = state, let indexOfExistingWorkout = workouts.firstIndex(of: originalWorkout) {
            // Edit existing workout
            workouts[indexOfExistingWorkout] = updatedWorkout
            tableView.reloadRows(at: [IndexPath(row: indexOfExistingWorkout, section: 0)], with: .automatic)
        } else if case .new = state {
            // Add new workout
            let newIndexPath = IndexPath(row: workouts.count, section: 0)
            workouts.append(updatedWorkout)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        Workout.saveWorkouts(workouts)
    }
    
    func addEditWorkoutTableViewController(_ controller: AddEditWorkoutTableViewController, didUpdateWorkout workout: Workout) {
        if let indexOfExistingWorkout = workouts.firstIndex(of: workout) {
            workouts[indexOfExistingWorkout] = workout
            tableView.reloadRows(at: [IndexPath(row: indexOfExistingWorkout, section: 0)], with: .automatic)
        }
    }
}

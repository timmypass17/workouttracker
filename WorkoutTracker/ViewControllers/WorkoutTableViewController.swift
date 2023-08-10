//
//  WorkoutTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/26/23.
//

import UIKit

class WorkoutTableViewController: UITableViewController, AddEditWorkoutTableViewControllerDelegate {
    
    var workouts: [Workout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedWorkouts = Workout.loadWorkouts() {
            workouts = savedWorkouts
        } else {
            workouts = Workout.sampleWorkouts
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Step 1: Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as! WorkoutTableViewCell
        
        // Step 2: Fetch model object to display
        let workout = workouts[indexPath.row]

        // Step 3: Configure cell
        cell.update(with: workout)
        
        // Step 4: Return cell
        return cell
    }
    
    // MARK: - Editing methods

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            workouts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            Workout.saveWorkouts(workouts)
        }
    }
    
    // MARK: - Naviation methods

    @IBSegueAction func addWorkout(_ coder: NSCoder, sender: Any?) -> AddEditWorkoutTableViewController? {
        // Initalize AddEditWorkoutTableViewController with workout
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            // TODO: Remove later?
            // Editing existing workout
            let workoutToEdit = workouts[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            return AddEditWorkoutTableViewController(coder: coder, workout: workoutToEdit)
        } else {
            // Adding new workout
            return AddEditWorkoutTableViewController(coder: coder, workout: nil)
        }
    }
    
    @IBSegueAction func showWorkoutDetail(_ coder: NSCoder, sender: Any?) -> AddEditWorkoutTableViewController? {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let workoutToEdit = workouts[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let addEditWorkoutTableViewController = AddEditWorkoutTableViewController(coder: coder, workout: workoutToEdit)
        addEditWorkoutTableViewController?.delegate = self
        return addEditWorkoutTableViewController
        
    }
    
    // User pressed "save" from modal screen
    @IBAction func unwindToWorkoutTableView(segue: UIStoryboardSegue) {
        // Capture the new or updated workout from the AddEditWorkoutTableViewController and save it to the workouts property
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEditWorkoutTableViewController,
              let workout = sourceViewController.workout else {
            return
        }

        if let indexOfExistingWorkout = workouts.firstIndex(of: workout) {  // tableView.indexPathForSelectedRow
            // Edit existing workout
            workouts[indexOfExistingWorkout] = workout
            tableView.reloadRows(at: [IndexPath(row: indexOfExistingWorkout, section: 0)], with: .automatic)
        } else {
            // Add new workout
            let newIndexPath = IndexPath(row: workouts.count, section: 0)
            workouts.append(workout)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        Workout.saveWorkouts(workouts)
    }
    
    // User presses "back" run this code. (Doesn't run from dismissing modal)
    func updateWorkout(sender: AddEditWorkoutTableViewController, workout: Workout) {
        if let indexOfExistingWorkout = workouts.firstIndex(of: workout) {
            workouts[indexOfExistingWorkout] = workout
            tableView.reloadRows(at: [IndexPath(row: indexOfExistingWorkout, section: 0)], with: .automatic)
            Workout.saveWorkouts(workouts)
        }
    }
    
    
}

// Note: Ideally should deselect when user goes from main -> detail so that users can see where they come from and put this in viewdidappear but it doesnt work with modals.

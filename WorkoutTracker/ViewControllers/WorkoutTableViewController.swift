//
//  WorkoutTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/26/23.
//

import UIKit

class WorkoutTableViewController: UITableViewController {
    
    var workouts: [Workout] = Workout.sampleWorkouts
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(workouts.map { $0.name.first?.lowercased() })
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Step 1: Remove model data
            workouts.remove(at: indexPath.row)
            
            // Step 2: Remove table view row
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    @IBSegueAction func addWorkout(_ coder: NSCoder, sender: Any?) -> AddEditWorkoutTableViewController? {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            // Editing Emoji
            let workoutToEdit = workouts[indexPath.row]
            return AddEditWorkoutTableViewController(coder: coder, workout: workoutToEdit)
        } else {
            // Adding Emoji
            return AddEditWorkoutTableViewController(coder: coder, workout: nil)
        }
    }
}

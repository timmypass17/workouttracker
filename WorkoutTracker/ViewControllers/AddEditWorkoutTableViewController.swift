//
//  AddEditWorkoutTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/29/23.
//

import UIKit

class AddEditWorkoutTableViewController: UITableViewController, ExerciseTableViewCellDelegate {
    
    var workout: Workout?
    var exercises: [Exercise] = []
    
    let titleTextFieldIndexPath = IndexPath(row: 0, section: 0)
    
    init?(coder: NSCoder, workout: Workout?) {
        self.workout = workout
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let workout = workout {
            // Handle existing workout
            exercises = workout.exercises
            title = workout.name
            
            self.navigationItem.rightBarButtonItem = editButtonItem
        } else {
            // Handle new workout
            exercises.append(Exercise(name: "", sets: 0, reps: 0, weight: 0))
            
            // Set to edit mode (i.e. Display red deletion and rearrange buttons)
            tableView.setEditing(true, animated: true)
            
            // Bar buttons
            let cancelButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(cancelAction))
            let saveButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action:#selector(saveAction))
            self.navigationItem.leftBarButtonItem = cancelButtonItem
            self.navigationItem.rightBarButtonItem = saveButtonItem
            
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // Set the isEditing property for each exercise based on the editing state
        for i in 0..<exercises.count {
            exercises[i].isEditing = editing
        }
        
        let isDone = !isEditing
        if isDone {
            print("Is done")
        }
        
        // Reload the table view to update the button's state
        tableView.reloadData()
        
    }
    
    @objc func saveAction(sender: UIButton!) {
      performSegue(withIdentifier: "saveUnwind", sender: nil) // calls prepare()
    }

    
    @objc func cancelAction(sender: UIButton!) {
      dismiss(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == titleTextFieldIndexPath.section {
            return 1
        }
        
        return exercises.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == titleTextFieldIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTitleCell", for: indexPath) as! WorkoutTitleTableViewCell
            if let workout = workout {
                cell.update(with: workout)
            }
            return cell
        } else {
            // Step 1: Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseTableViewCell
            
            // Step 2: Fetch model object to display
            let exercise = exercises[indexPath.row]
            
            // Step 3: Configure cell
            cell.update(with: exercise)  // Pass the editing state to the cell
            cell.isCompleteButton.isHidden = tableView.isEditing
            cell.delegate = self
            
            // Step 4: Return cell
            return cell
        }
    }
    
    // MARK: - Section headers

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == titleTextFieldIndexPath.section {
            return "Workout Name"
        }
        return "Exercises"
    }
    
    // MARK: - Edit methods

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath != titleTextFieldIndexPath
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            exercises.remove(at: indexPath.row) // remove todo from data source
            tableView.deleteRows(at: [indexPath], with: .automatic) // remove todo cell from table view
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedExercise = exercises.remove(at: sourceIndexPath.row)
        exercises.insert(movedExercise, at: destinationIndexPath.row)
    }
    
    // MARK: - Navigation methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // User pressed "cancel", do nothing
        guard segue.identifier == "saveUnwind" else { return }
        
        // Handle saving workout to let main vc have access
        let cell = tableView.cellForRow(at: titleTextFieldIndexPath) as! WorkoutTitleTableViewCell
        let name = cell.titleTextField.text!
        if let workout = workout {
            // Edit
            self.workout = Workout(id: workout.id, name: name, exercises: exercises)
        } else {
            // Add
            self.workout =  Workout(name: name, exercises: exercises)
        }
    }


    @IBAction func addExerciseButtonTapped(_ sender: Any) {
        exercises.append(Exercise(name: "", sets: 0, reps: 0, weight: 0))
        
        let indexPath = IndexPath(row: exercises.count - 1, section: 1)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func exerciseCell(_ cell: ExerciseTableViewCell, didUpdateExercise exercise: Exercise) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        // Update model
        exercises[indexPath.row] = exercise
    }
    
    func updateSaveButtonState() {
    }
}

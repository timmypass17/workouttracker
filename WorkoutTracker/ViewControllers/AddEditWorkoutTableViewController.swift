//
//  AddEditWorkoutTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/29/23.
//

import UIKit

class AddEditWorkoutTableViewController: UITableViewController {

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
        tableView.setEditing(true, animated: true)
        if let workout = workout {
            // Handle existing workout
            exercises = workout.exercises
        } else {
            // Handle new workout
            exercises.append(Exercise(name: "", sets: 0, reps: 0, weight: 0))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
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
            cell.update(with: exercise)
            
            // Step 4: Return cell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Workout Name"
        }
        return "Exercises"
    }
    
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


    @IBAction func addExerciseButtonTapped(_ sender: Any) {
        exercises.append(Exercise(name: "", sets: 0, reps: 0, weight: 0))
        
        let indexPath = IndexPath(row: exercises.count - 1, section: 1)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
//
////
////  AddEditWorkoutViewController.swift
////  WorkoutTracker
////
////  Created by Timmy Nguyen on 7/28/23.
////
//
//import UIKit
//
//class AddEditWorkoutViewController: UIViewController {
//
//    @IBOutlet var saveButton: UIBarButtonItem!
//    @IBOutlet var iconImageView: UIImageView!
//    @IBOutlet var workoutNameTextField: UITextField!
//    @IBOutlet var exerciseTableView: UITableView!
//
//    var workout: Workout?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if let workout = workout {
//            // Edit existing workout
//            title = workout.name
//        } else {
//            // Add new workout
//            title = "New Workout"
//            self.workout = Workout(name: "", exercises: [])
//        }
//
//        updateSaveButtonState()
//
//        exerciseTableView.delegate = self
//        exerciseTableView.dataSource = self
//    }
//
//    init?(coder: NSCoder, workout: Workout?) {
//        self.workout = workout
//        super.init(coder: coder)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    @IBAction func workoutNameEditingChanged(_ sender: Any) {
//        updateIcon()
//        updateSaveButtonState()
//    }
//
//    @IBAction func addExerciseButtonTapped(_ sender: Any) {
//        workout!.exercises.append(Exercise(name: "", sets: []))
//
//        let indexPath = IndexPath(row: workout!.exercises.count - 1, section: 0)
//
//        exerciseTableView.beginUpdates()
//        exerciseTableView.insertRows(at: [indexPath], with: .automatic)
//        exerciseTableView.endUpdates()
//
//        print(workout?.exercises)
//    }
//
//    func updateIcon() {
//        if let workoutName = workoutNameTextField.text,
//           let inital = workoutName.first?.lowercased() {
//            // Update icon
//            iconImageView.image = UIImage(systemName: "\(inital).circle.fill")
//        } else {
//            iconImageView.image = UIImage(systemName: "p.circle.fill")
//        }
//    }
//
//    func updateSaveButtonState() {
//        let shouldEnableSaveButton = workoutNameTextField.text?.isEmpty == false
//
//        saveButton.isEnabled = shouldEnableSaveButton
//    }
//}
//
//extension AddEditWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return workout!.exercises.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Step 1: Dequeue cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseTableViewCell
//
//        // Step 2: Fetch model object to display
//        let exercise = workout!.exercises[indexPath.row]
//
//        // Step 3: Configure cell
//        cell.update(with: exercise)
//
//        // Step 4: Return cell
//        return cell
//    }
//}

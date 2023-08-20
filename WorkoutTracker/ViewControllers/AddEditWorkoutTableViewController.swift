//
//  AddEditWorkoutTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/29/23.
//

import UIKit

protocol AddEditWorkoutTableViewControllerDelegate: AnyObject {
    // TODO: Rename method, confusing with other delegate method
    func updateWorkout(sender: AddEditWorkoutTableViewController, workout: Workout)
}

//protocol AddEditWorkoutTableViewControllerDelegate

class AddEditWorkoutTableViewController: UITableViewController, ExerciseTableViewCellDelegate {
    
    @IBOutlet var finishButton: UIButton!
    
    var workout: Workout?
    var isLogged: Bool
    var exercises: [Exercise] = []
    var startTime: Date?
    
    let titleTextFieldIndexPath = IndexPath(row: 0, section: 0)
    weak var delegate: AddEditWorkoutTableViewControllerDelegate?

    init?(coder: NSCoder, workout: Workout?, isLogged: Bool = false) {
        self.workout = workout
        self.isLogged = isLogged
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let workout = workout, isLogged {
            // Handle logged workout
            exercises = workout.exercises
            title = workout.name
            self.navigationItem.rightBarButtonItem = editButtonItem
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"

            let date = Date() // Replace this with your actual date
            let formattedDate = dateFormatter.string(from: workout.startTime!)
            
            finishButton.setTitle("Update Log at \(formattedDate)", for: .normal)
            finishButton.addTarget(self, action: #selector(updateButtonTapped(_:)), for: .touchUpInside)
            finishButton.isEnabled = true
        }
        else if let workout = workout {
            // Handle existing workout
            exercises = workout.exercises
            title = workout.name
            self.navigationItem.rightBarButtonItem = editButtonItem
            
            startTime = Date()
            
            finishButton.addTarget(self, action: #selector(finishButtonTapped(_:)), for: .touchUpInside)

            
            // Clear checkmarks
            for i in 0..<exercises.count {
                exercises[i].isComplete = false
                exercises[i].isEditing = false
            }
        } else {
            // Handle new workout
            exercises.append(Exercise(name: "", sets: "", reps: "", weight: "", date: Date()))
            // Set to edit mode (i.e. Display red deletion and rearrange buttons)
            tableView.setEditing(true, animated: true)
            
            // Bar buttons
            let cancelButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(cancelAction))
            let saveButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action:#selector(saveAction))
            self.navigationItem.leftBarButtonItem = cancelButtonItem
            self.navigationItem.rightBarButtonItem = saveButtonItem
        }
        
        NotificationCenter.default.addObserver(tableView!,
            selector: #selector(UITableView.reloadData),
            name: WeightType.weightUnitUpdatedNotification, object: nil
        )
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // Set the isEditing property for each exercise based on the editing state
        for i in 0..<exercises.count {
            exercises[i].isEditing = editing
        }
        
        // Reload the table view to update the button's state
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Save changes to exercises when users presses "back" button. Can't really add action to back button directly
        if let workout = workout {
            // Update existing workout
            let titleCell = tableView.cellForRow(at: titleTextFieldIndexPath) as! WorkoutTitleTableViewCell
            let title = titleCell.titleTextField.text!
            var exercises = exercises.filter { !$0.name.isEmpty || !$0.sets.isEmpty || !$0.reps.isEmpty || !$0.weight.isEmpty } // remove empty cells
            
            let workout = Workout(id: workout.id, name: title, exercises: exercises)
            
            delegate?.updateWorkout(sender: self, workout: workout)
        }
    }
    
    @objc func yourButtonTapped() {
            // Handle button tap
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
            cell.isCompleteButton.isSelected = exercise.isComplete
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
            updateFinishButtonState()
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedExercise = exercises.remove(at: sourceIndexPath.row)
        exercises.insert(movedExercise, at: destinationIndexPath.row)
    }
    
    // MARK: - Navigation methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // User pressed "cancel", do nothing
        guard segue.identifier == "saveUnwind" || segue.identifier == "updateUnwind" else { return }
        
        // Handle saving workout to let main vc have access
        let cell = tableView.cellForRow(at: titleTextFieldIndexPath) as! WorkoutTitleTableViewCell
        let name = cell.titleTextField.text!
        if let workout = workout {
            // Edit
            self.workout = Workout(id: workout.id, name: name, exercises: exercises, startTime: workout.startTime, endTime: workout.endTime)
        } else {
            // Add
            self.workout =  Workout(name: name, exercises: exercises)
        }
    }


    @IBAction func addExerciseButtonTapped(_ sender: Any) {
        exercises.append(Exercise(name: "", sets: "", reps: "", weight: "", date: Date()))
        print(exercises)
        let indexPath = IndexPath(row: exercises.count - 1, section: 1)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        updateFinishButtonState()
    }
    
    @objc func updateButtonTapped(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: titleTextFieldIndexPath) as! WorkoutTitleTableViewCell
        let name = cell.titleTextField.text!
        let updatedWorkout = Workout(id: workout!.id, name: name, exercises: exercises, startTime: workout!.startTime, endTime: workout!.endTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let sectionKey = dateFormatter.string(from: updatedWorkout.startTime!) // "August 2023"
        
        // Update existing workout
        if let index = LoggedWorkout.shared.loggedWorkoutsBySection[sectionKey]?.firstIndex(where: { $0.id == updatedWorkout.id }) {
            print("Saving existing workout log")
            LoggedWorkout.shared.loggedWorkoutsBySection[sectionKey]![index] = updatedWorkout
            LoggedWorkout.saveWorkoutLogs(LoggedWorkout.shared.loggedWorkoutsBySection)
            NotificationCenter.default.post(name: LoggedWorkout.logUpdatedNotification, object: nil)
        }
        
        performSegue(withIdentifier: "updateUnwind", sender: nil)
    }
    
    @objc func finishButtonTapped(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: titleTextFieldIndexPath) as! WorkoutTitleTableViewCell
        let name = cell.titleTextField.text!
        let workoutToSave = Workout(name: name, exercises: exercises, startTime: startTime, endTime: Date())
        
//        // For debugging
//        var workoutToSave = Workout(name: name, exercises: exercises, startTime: startTime, endTime: Date())
//        workoutToSave.startTime = Calendar.current.date(byAdding: .month, value: -1, to: startTime!)
//
//        for i in workoutToSave.exercises.indices {
//            workoutToSave.exercises[i].date = Calendar.current.date(byAdding: .month, value: -1, to: workoutToSave.exercises[i].date!)
//        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let sectionKey = dateFormatter.string(from: workoutToSave.startTime!) // "August 2023"
        
        if LoggedWorkout.shared.loggedWorkoutsBySection[sectionKey] == nil {
            LoggedWorkout.shared.loggedWorkoutsBySection[sectionKey] = []
        }
        LoggedWorkout.shared.loggedWorkoutsBySection[sectionKey]!.insert(workoutToSave, at: 0)
        
        LoggedWorkout.saveWorkoutLogs(LoggedWorkout.shared.loggedWorkoutsBySection)
        
        Settings.shared.logBadgeValue += 1
        NotificationCenter.default.post(name: LoggedWorkout.logUpdatedNotification, object: nil)
        saveAction(sender: sender)
    }

    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    func exerciseCell(_ cell: ExerciseTableViewCell, didUpdateExercise exercise: Exercise) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        // Update model
        let date = exercises[indexPath.row].date
        exercises[indexPath.row] = exercise
        exercises[indexPath.row].date = date
        updateFinishButtonState()
    }
    
    func checkmarkTapped(sender: ExerciseTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var exercise = exercises[indexPath.row]
            exercise.date = Date()
            exercise.isComplete.toggle()
            exercises[indexPath.row] = exercise
            tableView.reloadRows(at: [indexPath], with: .automatic) // calls tableview(cellForRowAt:)
//            ToDo.saveToDos(toDos)
            updateFinishButtonState()
        }
    }
    
    func updateFinishButtonState() {
        finishButton.isEnabled = exercises.allSatisfy {
            $0.isComplete == true && !$0.name.isEmpty && !$0.sets.isEmpty && !$0.reps.isEmpty && !$0.weight.isEmpty
        }
    }
}

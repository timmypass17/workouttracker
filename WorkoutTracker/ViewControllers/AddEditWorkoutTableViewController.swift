//
//  AddEditWorkoutTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/29/23.
//

import UIKit

protocol AddEditWorkoutTableViewControllerDelegate: AnyObject {
    func addEditWorkoutTableViewController(_ controller: AddEditWorkoutTableViewController, didUpdateWorkout workout: Workout)
}

enum WorkoutState {
    case new, add(Workout), log(Workout)
}

class AddEditWorkoutTableViewController: UITableViewController {
    
    @IBOutlet var finishButton: UIButton!
    
    var workout: Workout    // workout to update (has new id)
    var state: WorkoutState // original workout  (contains original id)
        
    let titleTextFieldIndexPath = IndexPath(row: 0, section: 0)
    var saveButton: UIBarButtonItem?
    weak var delegate: AddEditWorkoutTableViewControllerDelegate?
    
    var workoutLogs: [String: [Workout]] {
        get {
            return LoggedWorkout.shared.loggedWorkoutsBySection
        }
        set {
            LoggedWorkout.shared.loggedWorkoutsBySection = newValue
        }
    }
    
    init?(coder: NSCoder, state: WorkoutState) {
        self.state = state
        switch state {
        case .new:
            self.workout = Workout(name: "", exercises: [])
        case .add(let workout):
            self.workout = workout
        case .log(let workout):
            self.workout = workout
        }
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        
        NotificationCenter.default.addObserver(tableView!,
            selector: #selector(UITableView.reloadData),
            name: WeightType.weightUnitUpdatedNotification, object: nil
        )
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == titleTextFieldIndexPath.section {
            return 1
        }
        
        return workout.exercises.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == titleTextFieldIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTitleCell", for: indexPath) as! WorkoutTitleTableViewCell
            cell.update(with: workout)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseTableViewCell
            let exercise = workout.exercises[indexPath.row]
            cell.update(with: exercise)
            cell.isCompleteButton.isSelected = exercise.isComplete
            cell.isCompleteButton.isHidden = tableView.isEditing
            cell.delegate = self
            return cell
        }
    }
    
    // MARK: - Section headers

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == titleTextFieldIndexPath.section { return "Workout Name" }
        return "Exercises"
    }
    
    // MARK: - Edit methods

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let exerciseSection = 1
        return indexPath.section == exerciseSection
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            workout.exercises.remove(at: indexPath.row) // remove todo from data source
            tableView.deleteRows(at: [indexPath], with: .automatic) // remove todo cell from table view
            updateFinishButtonState()
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedExercise = workout.exercises.remove(at: sourceIndexPath.row)
        workout.exercises.insert(movedExercise, at: destinationIndexPath.row)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // Set the isEditing property for each exercise based on the editing state
        for i in 0..<workout.exercises.count {
            workout.exercises[i].isEditing = editing
        }

        // Reload the table view to update the button's state
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        // Limit reordering to only it's own section (i.e. Don't reorder title row)
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            if case .add(let originalWorkout) = state {
                // Update any changes to workout that user typed (if from workout detail), when user presses "back"
                let updatedWorkout = Workout(id: originalWorkout.id, name: workout.name, exercises: workout.exercises, startTime: workout.startTime)
                delegate?.addEditWorkoutTableViewController(self, didUpdateWorkout: updatedWorkout)
            }
        }
    }
    
    func updateView() {
        switch state {
        case .new:
            setUpNewWorkoutView()
        case .add(_):
            setUpAddWorkoutView()
        case .log(_):
            setUpEditLogView()
        }
    }

    func setUpNewWorkoutView() {
        // Handle new workout
        workout.exercises.append(Exercise(name: "", sets: "", reps: "", weight: "", date: Date()))

        // Set to edit mode (i.e. Display red deletion and rearrange buttons)
        tableView.setEditing(true, animated: true)
        
        // Bar buttons
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(cancelButtonTapped))
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action:#selector(saveButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        saveButton?.isEnabled = false
    }
    
    func setUpAddWorkoutView() {
        // Handle adding new workout
        workout.id = UUID()
        workout.startTime = Date()

        title = workout.name
        navigationItem.rightBarButtonItem = editButtonItem
        finishButton.addTarget(self, action: #selector(finishWorkoutButtonTapped(_:)), for: .touchUpInside)

        // Clear checkmarks
        for i in 0..<workout.exercises.count {
            workout.exercises[i].isComplete = false
            workout.exercises[i].isEditing = false
        }
    }
    
    func setUpEditLogView() {
        // Handle logged workout
        title = workout.name
        self.navigationItem.rightBarButtonItem = editButtonItem
        finishButton.setTitle("Update Log at \(formatDateMonthDayYear( workout.startTime!))", for: .normal)
        finishButton.addTarget(self, action: #selector(updateButtonTapped(_:)), for: .touchUpInside)
        finishButton.isEnabled = true
    }
    
    // MARK: Button actions
    
    @objc func saveButtonTapped(sender: UIButton!) {
        guard isExercisesInputValid() else { showInputErrorAlert(); return }
        performSegue(withIdentifier: "saveUnwind", sender: nil) // calls prepare()
    }

    
    @objc func cancelButtonTapped(sender: UIButton!) {
      dismiss(animated: true)
    }
    
    @IBAction func addExerciseButtonTapped(_ sender: Any) {
        workout.exercises.append(Exercise(name: "", sets: "", reps: "", weight: "", date: Date()))
        let indexPath = IndexPath(row: workout.exercises.count - 1, section: 1)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        updateFinishButtonState()
    }
    
    @objc func updateButtonTapped(_ sender: UIButton) {
        guard isExercisesInputValid() else { showInputErrorAlert(); return }

        let sectionKey = formatDateMonthYear(workout.startTime!) // "August 2023"

        // Update existing workout
        if let index = workoutLogs[sectionKey]?.firstIndex(where: { $0.id == workout.id }) {
            workoutLogs[sectionKey]![index] = workout
            LoggedWorkout.saveWorkoutLogs(workoutLogs)
            NotificationCenter.default.post(name: LoggedWorkout.logUpdatedNotification, object: nil)
        }
        
        performSegue(withIdentifier: "updateUnwind", sender: nil)
    }
    
    @objc func finishWorkoutButtonTapped(_ sender: UIButton) {
        guard isExercisesInputValid() else { showInputErrorAlert(); return }
        
        let sectionKey = formatDateMonthYear(workout.startTime!) // "August 2023"
        
        workoutLogs[sectionKey, default: []].insert(workout, at: 0)
        LoggedWorkout.saveWorkoutLogs(workoutLogs)
        
        Settings.shared.logBadgeValue += 1
        NotificationCenter.default.post(name: LoggedWorkout.logUpdatedNotification, object: nil)
        saveButtonTapped(sender: sender)
    }

    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    func updateFinishButtonState() {
        finishButton.isEnabled = workout.exercises.allSatisfy {
            $0.isComplete == true && !$0.name.isEmpty && !$0.sets.isEmpty && !$0.reps.isEmpty && !$0.weight.isEmpty
        } && !workout.name.isEmpty
    }
    
    func isExercisesInputValid() -> Bool {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        
        func isStringANumber(_ input: String) -> Bool {
            return formatter.number(from: input) != nil
        }
        
        return workout.exercises.allSatisfy { exercise in
            isStringANumber(exercise.sets) && isStringANumber(exercise.reps) && isStringANumber(exercise.weight)
        }
    }
    
    func showInputErrorAlert() {
        let alert = UIAlertController(
            title: "Invalid Input",
            message: "Please enter numeric values for sets, reps, and weight. Only numbers and decimal numbers are accepted in these fields. (Ex. \"135\" or \"135.5\")",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddEditWorkoutTableViewController: ExerciseTableViewCellDelegate {
    func exerciseCell(_ cell: ExerciseTableViewCell, didUpdateExercise exercise: Exercise) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        workout.exercises[indexPath.row] = exercise
        updateFinishButtonState()
    }
    
    func checkmarkTapped(sender: ExerciseTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var exercise = workout.exercises[indexPath.row]
            exercise.date = Date()
            exercise.isComplete.toggle()
            workout.exercises[indexPath.row] = exercise
            tableView.reloadRows(at: [indexPath], with: .automatic) // calls tableview(cellForRowAt:)
            updateFinishButtonState()
        }
    }
}

extension AddEditWorkoutTableViewController: WorkoutTitleTableViewCellDelegate {
    func workoutTitleTableViewCell(_ cell: WorkoutTitleTableViewCell, didUpdateTitle title: String) {
        workout.name = title
        updateFinishButtonState()
    }
}

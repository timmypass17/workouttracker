//
//  ExerciseTableViewCell.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/29/23.
//

import UIKit

protocol ExerciseTableViewCellDelegate: AnyObject {
    func exerciseCell(_ cell: ExerciseTableViewCell, didUpdateExercise exercise: Exercise)
    
    func checkmarkTapped(sender: ExerciseTableViewCell)
}

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var setsTextField: UITextField!
    @IBOutlet var repsTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var isCompleteButton: UIButton!
    
    weak var delegate: ExerciseTableViewCellDelegate?
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium) // Choose a haptic feedback style
    var exercise: Exercise!
    
    var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        toolbar.items = [.flexibleSpace(), doneButton]
        return toolbar
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameTextField.inputAccessoryView = toolbar
        setsTextField.inputAccessoryView = toolbar
        repsTextField.inputAccessoryView = toolbar
        weightTextField.inputAccessoryView = toolbar
        feedbackGenerator.prepare()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func textEditingChanged(_ sender: Any) {
        // Update the exercise with the new values
        exercise.name = nameTextField.text ?? ""
        exercise.sets = setsTextField.text ?? ""
        exercise.reps = repsTextField.text ?? ""
        exercise.weight = weightTextField.text ?? ""
        exercise.isComplete = isCompleteButton.isSelected
//        // TODO: Exercise is setting new id and date
//        var exercise = Exercise(name: name, sets: sets, reps: reps, weight: weight, isComplete: isComplete)
        
        // TODO: What is this?
        exercise.setWeight(weight: weightTextField.text ?? "")
        
        // Notify the delegate that the exercise was updated
        delegate?.exerciseCell(self, didUpdateExercise: exercise)
    }
    
    
    func update(with exercise: Exercise) {
        self.exercise = exercise
        nameTextField.text = exercise.name
        setsTextField.text = "\(exercise.sets)"
        repsTextField.text = "\(exercise.reps)"
        weightTextField.text = exercise.weight == "" ? "" : "\(exercise.getWeightString())"
        selectionStyle = .none  // disable highligh when clicking row
//        showsReorderControl = true
        
        isCompleteButton.isEnabled = !exercise.isEditing  // Enable or disable the button based on the isEditing property
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        feedbackGenerator.impactOccurred()
        delegate?.checkmarkTapped(sender: self)
    }
    
    @objc func doneButtonTapped(){
        if let activeTextField = [nameTextField, setsTextField, repsTextField, weightTextField].first(where: { $0.isFirstResponder }) {
            activeTextField.resignFirstResponder()
        }
    }
}


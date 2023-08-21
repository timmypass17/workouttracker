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
        let name = nameTextField.text ?? ""
        let sets = setsTextField.text ?? ""
        let reps = repsTextField.text ?? ""
        let weight = weightTextField.text ?? ""
        let isComplete = isCompleteButton.isSelected
        var exercise = Exercise(name: name, sets: sets, reps: reps, weight: "", isComplete: isComplete)
        exercise.setWeight(weight: weight)
        
        // Notify the delegate that the exercise was updated
        delegate?.exerciseCell(self, didUpdateExercise: exercise)
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        feedbackGenerator.impactOccurred()
        delegate?.checkmarkTapped(sender: self)
    }
    
    func update(with exercise: Exercise) {
        nameTextField.text = exercise.name
        setsTextField.text = "\(exercise.sets)"
        repsTextField.text = "\(exercise.reps)"
        weightTextField.text = exercise.weight == "" ? "" : "\(exercise.getWeightString())"
        selectionStyle = .none  // disable highligh when clicking row
//        showsReorderControl = true
        
        isCompleteButton.isEnabled = !exercise.isEditing  // Enable or disable the button based on the isEditing property
    }
    
    @objc func doneButtonTapped(){
        if let activeTextField = [nameTextField, setsTextField, repsTextField, weightTextField].first(where: { $0.isFirstResponder }) {
            activeTextField.resignFirstResponder()
        }
    }

}


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
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var exercise: Exercise!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let toolbar = createToolbar(target: self, action: #selector(doneButtonTapped))
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
        exercise.isComplete = isCompleteButton.isSelected

        switch Settings.shared.weightUnit {
        case .lbs:
            exercise.weight = weightTextField.text ?? ""
        case .kg:
            // Convert to lb
            exercise.weight = String((Float(weightTextField.text ?? "") ?? 0) * 2.20462)
        }
        
        // Notify the delegate that the exercise was updated
        delegate?.exerciseCell(self, didUpdateExercise: exercise)
    }
    
    
    func update(with exercise: Exercise) {
        self.exercise = exercise
        nameTextField.text = exercise.name
        setsTextField.text = "\(exercise.sets)"
        repsTextField.text = "\(exercise.reps)"
        weightTextField.text = exercise.weight.isEmpty ? "" : "\(exercise.getWeightString())" // show placeholder instead of "0"
        isCompleteButton.isEnabled = !exercise.isEditing
        selectionStyle = .none  // disable highligh when clicking row
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

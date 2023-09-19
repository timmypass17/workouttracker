//
//  Utility.swift
//  SwiftLift
//
//  Created by Timmy Nguyen on 9/19/23.
//

import Foundation
import UIKit
import SwiftUI

// MARK: Time utility functions

let oneWeek: TimeInterval = 7 * 24 * 60 * 60

func formatDateMonthDayYear(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy"
    return dateFormatter.string(from: date)
}

var monthYearDateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM yyyy"
    return dateFormatter
}

func formatDateMonthYear(_ date: Date) -> String {
    return monthYearDateFormatter.string(from: date)
}

// MARK: Weight string functions

// Weight strings
func formatFloat(_ floatValue: Float) -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2 // You can adjust this as needed
    
    return formatter.string(from: NSNumber(value: floatValue)) ?? "\(floatValue)"
}

// MARK: Color stuff

extension Color {
    static let ui = Color.UI()
    
    struct UI {
        // Asset colors
        let green = Color("green")
        let red = Color("red")
    }
}

enum AccentColor: String, CaseIterable, Codable {
    case blue, red, cyan, mint, pink, teal, brown, green, indigo, orange, purple, yellow
    
    static let accentColorUpdatedNotification = Notification.Name("AccentColor.accentColorUpdated")

    var color: UIColor {
        switch self {
        case .blue:
            return .systemBlue
        case .red:
            return .systemRed
        case .cyan:
            return .systemCyan
        case .mint:
            return .systemMint
        case .pink:
            return .systemPink
        case .teal:
            return .systemTeal
        case .brown:
            return .systemBrown
        case .green:
            return .systemGreen
        case .indigo:
            return .systemIndigo
        case .orange:
            return .systemOrange
        case .purple:
            return .systemPurple
        case .yellow:
            return .systemYellow
        }
    }
}

// MARK: Custom views

// Custom toolbar with "Done" button
func createToolbar(target: Any?, action: Selector) -> UIToolbar {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let doneButton = UIBarButtonItem(
        title: "Done",
        style: .plain,
        target: target,
        action: action
    )
    
    toolbar.items = [.flexibleSpace(), doneButton]
    return toolbar
}


var emptyWorkoutDataLabel: UILabel {
    let label = UILabel()
    label.text = "Your workout data will appear here."
    label.textAlignment = .center
    label.textColor = .secondaryLabel
    label.font = UIFont.systemFont(ofSize: 18)
    label.numberOfLines = 0
    return label
}

class CustomHeaderView: UIView {
    let leadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    let trailingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStackView()
    }

    private func setupStackView() {
        // Create a horizontal stack view and add the labels to it
        let stackView = UIStackView(arrangedSubviews: [leadingLabel, trailingLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        // Add the stack view to the header view
        addSubview(stackView)

        // Set the constraints for the stack view to fill the header view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        backgroundColor = .systemGroupedBackground

    }
}

// MARK: Debugging function

func resetDefaults() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
    }
}

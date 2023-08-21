//
//  ColorTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/20/23.
//

import UIKit

protocol AccentColorTableViewControllerDelegate: AnyObject {
    func accentColorTableViewController(_ controller: AccentColorTableViewController, didSelect accentColor: AccentColor)
}

class AccentColorTableViewController: UITableViewController {

    weak var delegate: AccentColorTableViewControllerDelegate?

    var colors: [AccentColor] = AccentColor.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccentColorCell", for: indexPath)
        let color = colors[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = color.rawValue.capitalized
        cell.contentConfiguration = content
        
        if color == Settings.shared.accentColor {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let color = colors[indexPath.row]
        Settings.shared.accentColor = color
        delegate?.accentColorTableViewController(self, didSelect: color)
        NotificationCenter.default.post(name: AccentColor.accentColorUpdatedNotification, object: nil)
        tableView.reloadData()
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

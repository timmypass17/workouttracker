//
//  ThemeTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/16/23.
//

import UIKit

protocol ThemeTableViewControllerDelegate: AnyObject {
    func themeTableViewController(_ controller: ThemeTableViewController, didSelect themeType: Theme)
}

class ThemeTableViewController: UITableViewController {

    weak var delegate: ThemeTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Theme.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeTypeCell", for: indexPath)
        let themeType = Theme.allCases[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = themeType.name
        cell.contentConfiguration = content
        
        if themeType == Settings.shared.theme {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let themeType = Theme.allCases[indexPath.row]
        Settings.shared.theme = themeType
        NotificationCenter.default.post(name: Theme.themeUpdatedNotification, object: nil)
        delegate?.themeTableViewController(self, didSelect: themeType) // pass parameters to Settings...
        tableView.reloadData()
    }
}

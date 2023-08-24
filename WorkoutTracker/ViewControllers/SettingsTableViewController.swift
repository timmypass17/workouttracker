//
//  SettingsTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/16/23.
//

import UIKit
import SafariServices
import MessageUI

class SettingsTableViewController: UITableViewController, WeightUnitTableViewControllerDelegate, ThemeTableViewControllerDelegate, AccentColorTableViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var weightTypeLabel: UILabel!
    @IBOutlet var themeLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    
    let contactUsIndexPath = IndexPath(row: 0, section: 2)
    let bugReportIndexPath = IndexPath(row: 1, section: 2)
    let email = "swiftliftapp@gmail.com"

    enum Section: Int, CaseIterable {
        case units
        case appearance
        case help
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Load weight type from user defaults
        
        updateView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionCase = Section(rawValue: section) else { return 0 }
        
        switch sectionCase {
        case .units:
            return 1
        case .appearance, .help:
            return 2
        }
    }
    
    @IBSegueAction func showWeightUnit(_ coder: NSCoder) -> WeightUnitTableViewController? {
        let weightUnitTableViewController = WeightUnitTableViewController(coder: coder)
        weightUnitTableViewController?.delegate = self
        return weightUnitTableViewController
    }
    
    @IBSegueAction func showTheme(_ coder: NSCoder) -> ThemeTableViewController? {
        let themeTableViewController = ThemeTableViewController(coder: coder)
        themeTableViewController?.delegate = self
        return themeTableViewController
    }
    
    @IBSegueAction func showAccentColor(_ coder: NSCoder) -> AccentColorTableViewController? {
        let accentColorTableViewController = AccentColorTableViewController(coder: coder)
        accentColorTableViewController?.delegate = self
        return accentColorTableViewController
    }
    func updateView() {
        weightTypeLabel.text = Settings.shared.weightUnit.name
        themeLabel.text = Settings.shared.theme.name
        colorLabel.text = Settings.shared.accentColor.rawValue.capitalized
//        brushImageView.tintColor = Settings.shared.accentColor.color
    }
    
    func weightUnitTableViewController(_ controller: WeightUnitTableViewController, didSelect weightType: WeightType) {
        updateView()
    }
    
    func themeTableViewController(_ controller: ThemeTableViewController, didSelect themeType: Theme) {
        updateView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == contactUsIndexPath {
            guard MFMailComposeViewController.canSendMail() else {
                showMailErrorAlert()
                return
            }
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients([email]) // change to support email
            mailComposer.setSubject("Contact Us")
            
            present(mailComposer, animated: true)
        } else if indexPath == bugReportIndexPath {
            guard MFMailComposeViewController.canSendMail() else {
                showMailErrorAlert()
                return
            }
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setToRecipients([email]) // change to support email
            mailComposer.setSubject("Bug Report")
            
            present(mailComposer, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func accentColorTableViewController(_ controller: AccentColorTableViewController, didSelect accentColor: AccentColor) {
        updateView()
    }
    
    func showMailErrorAlert() {
        let alert = UIAlertController(title: "No Email Account Found", message: "There is no email account associated to this device. If you have any questions, please feel free to reach out to us at \(email)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
        self.present(alert, animated: true, completion: nil)
    }
}

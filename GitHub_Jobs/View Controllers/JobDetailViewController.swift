//
//  JobDetailViewController.swift
//  GitHub_Jobs
//
//  Created by Dustin Koch on 5/15/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit
import MessageUI

class JobDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    //MARK: - Landing pad
    var job: Job?
    
    //MARK: - IB Outlets
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateView()
    }

    //MARK: - IB Actions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    //MARK: - Helper funcs
    func updateView() {
        guard let job = job else { return }
        jobTitleLabel.text = job.title
        companyNameLabel.text = job.company
        guard var text = job.description else { return }
        jobDescriptionTextView.text = cleanUpText(string: text)
    }
    func openJobFromGitHub() {
        guard let job = job,
            let jobstring = job.url,
            let jobURL = URL(string: jobstring) else { return }
        UIApplication.shared.openURL(jobURL)
    }
    func cleanUpText(string: String) -> String {
        var stringToEdit = string
        stringToEdit = stringToEdit.replacingOccurrences(of: "<p>", with: "")
        stringToEdit = stringToEdit.replacingOccurrences(of: "</p>", with: "")
        stringToEdit = stringToEdit.replacingOccurrences(of: "</li>", with: "")
        stringToEdit = stringToEdit.replacingOccurrences(of: "</ul>", with: "")
        stringToEdit = stringToEdit.replacingOccurrences(of: "<ul>", with: "")
        stringToEdit = stringToEdit.replacingOccurrences(of: "<li>", with: "")
        return stringToEdit
    }
    
    //MARK: - Mail configuration
    func configureMailController() -> MFMailComposeViewController {
        guard let job = job,
            let jobURL = job.url else { return MFMailComposeViewController() }
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["test_email@me.com"])
        mailComposerVC.setSubject("Check out this job!")
        mailComposerVC.setMessageBody(jobURL, isHTML: false)
        
        return mailComposerVC
    }
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send message at this time", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openWebsiteAction = UIAlertAction(title: "Open on GitHub", style: .default) { (_) in
            self.openJobFromGitHub()
        }
        sendMailErrorAlert.addAction(dismissAction)
        sendMailErrorAlert.addAction(openWebsiteAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    //MARK: - Mail delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}//END OF CLASS



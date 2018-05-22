//
//  EmailViewController.swift
//  ProjectCrypto
//
//  Created by Тимур on 25.04.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit
import MessageUI
import SVProgressHUD

class EmailViewController: UIViewController,MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = self.configuredMailComposeViewController()
            self.present(mailComposeVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["tssadykov16@gmail.com"])
        mailComposerVC.setSubject("App Feedback")
        mailComposerVC.setMessageBody("Hello, \n\n...", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send E-mail", message: "Your device could not send e-mail. Please check e-mail configuration and try again.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(alertAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.hashValue {
        case MFMailComposeResult.sent.hashValue:
            self.dismiss(animated: false) {
                SVProgressHUD.showSuccess(withStatus: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ShowPortfolio"), object: nil)
            }
        case MFMailComposeResult.cancelled.hashValue, MFMailComposeResult.saved.hashValue:
            self.dismiss(animated: false) {
                NotificationCenter.default.post(name: NSNotification.Name("ShowPortfolio"), object: nil)
            }
        default:
            break
        }
    }
}

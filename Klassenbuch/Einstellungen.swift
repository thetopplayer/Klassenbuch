//
//  Einstellungen.swift
//  Klassenbuch
//
//  Created by Developing on 03.02.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class Einstellungen: UITableViewController, MFMailComposeViewControllerDelegate {

   
    //Outlets
    @IBOutlet weak var LogOutButton: UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Left Swipe
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
         }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    //Log User Out Function with ActionSheet

    @IBAction func LogUserOut(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: "Willst du dich wirklich abmelden?", attributes: titleFont)

        
        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
       

        
        
        let logoutAction = UIAlertAction(title: "Abmelden", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
            
            try! FIRAuth.auth()!.signOut()
            if let storyboard = self.storyboard {
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginNavigationVC") as! UINavigationController
                self.present(vc, animated: false, completion: nil)
                
                print("Logout Pressed")
            }}
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        actionSheet.addAction(logoutAction)
        
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
 

    // Email Feedback
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Row = \(indexPath.description)")
        
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            let mailComposeViewController = configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
        if indexPath.section == 0 && indexPath.row == 2 {

           self.gotoSettings()
        }
        /*
        if indexPath.section == 0 && indexPath.row == 4 {
            
            self.gotoiBook()
        }*/
    }

    
    /* go to iBook
    
    func gotoiBook () {
    
    print("went to iBooks Store")
    
        if let iBook = URL(string: "https://itunes.apple.com/ch/book/im-schatten-das-licht/id1112971928?mt=11") {
            UIApplication.shared.open(iBook, options: [:], completionHandler: nil)
        }
    }
    */
    
    
    
    
    
    // Mail Settings
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["klassenbuchteam@gmail.com"])
        mailComposerVC.setSubject("Klassenbuch App Feedback")
        mailComposerVC.setMessageBody("Hi Jérôme!\n\nHier ist mein Feedback für die Klassenbuch App..\n", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
      
        let sendMailErrorAlert = UIAlertController(title: "Die Email konnte nicht gesendet werden", message: "Aus unerklärlichen Gründen konnte die Email nicht gesendet werden. Überprüfe deine Email Einstellungen und versuche es nochmals.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        sendMailErrorAlert.addAction(defaultAction)
        
        self.present(sendMailErrorAlert, animated: true, completion: nil)
        
    
    }
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    // Cancel App Info
    
    @IBAction func cancelAppInfo (_ segue:UIStoryboardSegue) {
    }
    
    
    // Cancel App Onboarding
    
    @IBAction func saveAppInfo (_ segue:UIStoryboardSegue) {
    }

    
    
    // Go to Acknowledgements Function in Settings
    
    func gotoSettings() {
        
        print("Send to Settings")
            
        // THIS IS WHERE THE MAGIC HAPPENS!!!!
            
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    
    
    //Fund for Left Swipe
    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        if recognizer.state == .recognized {
            self.performSegue(withIdentifier: "unwindtoInfos", sender: self)
        }
    }
}


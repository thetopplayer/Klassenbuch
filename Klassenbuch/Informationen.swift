//
//  Informationen.swift
//  Klassenbuch
//
//  Created by Developing on 11.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MessageUI

class Informationen: UITableViewController, MFMailComposeViewControllerDelegate {

    
    
    //Outlets

    @IBOutlet weak var ConnectionState: UIBarButtonItem!

    // Variables
    var effect:UIVisualEffect!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ConnectionstateOnOff()
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
  
    
    
    // ConncectionState
    
    func ConnectionstateOnOff() {
    
        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                
                self.ConnectionState.image = #imageLiteral(resourceName: "WifiOn")
                
                
                print("Connected")
            } else {
                
                self.ConnectionState.image = #imageLiteral(resourceName: "WifiOff")
                print("Not connected")
            }
        })

    }
   
    
    // Activtiy Sheet Function
    @IBAction func ActivitySheet(_ sender: Any) {

        let shareText = "Sieh dir diese App an, ein mobiles Klassenbuch"
        let shareURL = URL(string: "https://itunes.apple.com/us/app/calcfast/id876781417?mt=8")
       //  let image = UIImage(named: "Delivery@3x.png")
        let activityArray = [shareText, shareURL!/* , image!*/] as [Any]
        let activityViewController = UIActivityViewController(activityItems: activityArray , applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.assignToContact, UIActivityType.addToReadingList]
        present(activityViewController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 3
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return 1
    }
   
    
    // UIBarButtons Functions
    
    @IBAction func cancelSettings (_ segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func cancelKlassenSettings (_ segue:UIStoryboardSegue) {
        
    }

    
    
    
    @IBAction func AppStoreReview(_ sender: Any) {
        
            print("Rate Us row tapped.")
            
            let alertController = UIAlertController(title: "Bewerte die Klassenbuch App!", message: "\nGefällt dir die Klassenbuch App? Bitte schreibe eine Rezension im App Store!\n\nFalls dir die App nicht gefällt kannst du eine Email schreiben, ich bin immer erfreut über Feedbacks um die App zu verbessern!\n\nDankeschön!\nJérôme Hadorn", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Bewerten", style: .default, handler: { (action: UIAlertAction!) in
                print("RateUs.RateUs_Tapped")
                print("Send to App Store")
                
                if let path = URL(string: "https://itunes.apple.com/us/app/calcfast/id876781417?mt=8") {
                    UIApplication.shared.open(path) {
                        (didOpen:Bool) in
                        if !didOpen {
                            print("Error opening:\(path.absoluteString)")
                        }
                    }
                }
            }))
        
            alertController.addAction(UIAlertAction(title: "Feedback", style: .default, handler: { (action: UIAlertAction!) in
                
                let mailComposeViewController = self.configuredMailComposeViewController()
                
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
                print("RateUs.Feedback_Tapped")
            }))
        
        alertController.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler: { (action: UIAlertAction!) in
            print("RateUs.Cancel_Tapped")
        }))
        
            present(alertController, animated: true, completion: nil)
        }

// Mail Compose for Feedback Functions
    
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
    
}



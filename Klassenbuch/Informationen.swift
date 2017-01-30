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

class Informationen: UITableViewController {

   
    
    //Outlets
    
        
    @IBOutlet weak var ConnectionState: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        ConnectionstateOnOff()
        
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
    //Log User Out Function with ActionSheet
    @IBAction func LogUserOut(_ sender: Any) {
    
        
        let actionSheet = UIAlertController(title: "Wollen Sie sich wirklich abmelden?", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
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

    
    // Activtiy Sheet Function
    @IBAction func ActivitySheet(_ sender: Any) {

        let shareText = "Sieh dir diese App an, ein mobiles Klassenbuch"
        let shareURL = URL(string: "http://www.apple.com")
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

    
}

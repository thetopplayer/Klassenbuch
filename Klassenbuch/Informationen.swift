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
        let shareURL = URL(string: "http://www.apple.com")
       //  let image = UIImage(named: "Delivery@3x.png")
        let activityArray = [shareText, shareURL!/* , image!*/] as [Any]
        let activityViewController = UIActivityViewController(activityItems: activityArray , applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.assignToContact, UIActivityType.addToReadingList]
        present(activityViewController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 4
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return 1
    }
   
    
    // UIBarButtons Functions
    
    @IBAction func cancelSettings (_ segue:UIStoryboardSegue) {
        
    }

    
}

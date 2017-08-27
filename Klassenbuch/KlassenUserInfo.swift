//
//  KlassenUserInfo.swift
//  Klassenbuch
//
//  Created by Developing on 26.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class KlassenUserInfo: UITableViewController {

    // Variables
    var handle : FIRDatabaseHandle?
    var ref: FIRDatabaseReference?

    
    
    //Outlets
    @IBOutlet weak var KlassenLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var KlassenlehrerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.getInfos()
        KlassenLabel.numberOfLines = 0
        NameLabel.numberOfLines = 0
        EmailLabel.numberOfLines = 0

        // Left Swipe
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
    }
    

    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        if recognizer.state == .recognized {
            self.performSegue(withIdentifier: "backtotonfo", sender: self)
            
        }
    }
    
    
    func getInfos(){
       
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref = FIRDatabase.database().reference()
        handle = ref?.child("users").child("Schüler").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
            
            
            if let item1 = snapshot.value as? String{
                
                
               self.KlassenLabel.text = item1
                
            }
        }
            
            
        )
        
        ref = FIRDatabase.database().reference()
        handle = ref?.child("users").child("Schüler").child(uid!).child("email").observe(.value, with: { (snapshot) in
            
            
            if let item2 = snapshot.value as? String{
                
                
                self.EmailLabel.text = item2
                
            }
        }
            
            
        )
        
        ref = FIRDatabase.database().reference()
        handle = ref?.child("users").child("Schüler").child(uid!).child("name").observe(.value, with: { (snapshot) in
            
            
            if let item3 = snapshot.value as? String{
                
                
                self.NameLabel.text = item3
                
            }
        }
            
            
        )
    }
    
  
}

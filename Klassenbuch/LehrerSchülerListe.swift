//
//  LehrerSettings.swift
//  Klassenbuch
//
//  Created by Developing on 26.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class LehrerSchülerListe: UITableViewController {

    // Variables
//    var TeacherofClass = "N5aFS18"

    var Classmembers = ["Tomate", "Gurke"]//: [String] = []
    //var Classlistt = ["asdsad","asasdsadd"]
    var handle2 : FIRDatabaseHandle?
    var ref2: FIRDatabaseReference?
    var myklasse : String?
    var myklasse2 = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref2 = FIRDatabase.database().reference()
        getStudents()
        
      
    
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        //getStudents()
    }


    func getStudents(){
        
        ref2 = FIRDatabase.database().reference()
        
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
      
        ref2?.child("users").child("Lehrer").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let item1 = snapshot.value as? String{
                
                
                self.myklasse2 = item1
                
                
                
                self.handle2 = self.ref2?.child("KlassenMitglieder/\(self.myklasse2)").observe(.childAdded, with: { (snapshot2) in
                    
                    
                    if let item2 = snapshot2.value as? String{
                        self.Classmembers.append(item2)
                        self.tableView.reloadData()
                        
                    }
                })
                print(self.Classmembers)
                
                
            }}
        )
    }
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Classmembers.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = Classmembers[indexPath.row]
        return cell
    }
   



}

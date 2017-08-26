//
//  LehrerSettings.swift
//  Klassenbuch
//
//  Created by Developing on 26.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class LehrerSettings: UITableViewController {

    // Variables
//    var TeacherofClass = "N5aFS18"

    var Classmembers : [String] = []
    //var Classlistt = ["asdsad","asasdsadd"]
    var handle2 : FIRDatabaseHandle?
    var ref2: FIRDatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref2 = FIRDatabase.database().reference()
        
        handle2 = ref2?.child("KlassenMitglieder/N5aFS18").observe(.childAdded, with: { (snapshot2) in
            
            
            if let item2 = snapshot2.value as? String{
                self.Classmembers.insert(item2, at: 0)   //.append(item2)
                self.tableView.reloadData()
                
            }
        }
            
            
        )
        print(Classmembers)
        tableView.reloadData()
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
        return Classmembers.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = Classmembers[indexPath.row]
        return cell
    }
   



}

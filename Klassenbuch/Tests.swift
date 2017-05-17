//
//  Tests.swift
//  Klassenbuch
//
//  Created by Developing on 20.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase


struct TestsStruct {
    var TDatum: Int
    var TFach: String
    var TText: String
    var TUid: String
}


class Tests: UITableViewController {
    
    

    // Variables
    
    var data = [Int: [TestsStruct]]() // Date: Homework Object
    var sortedData = [(Int, [TestsStruct])]()
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    

    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        // Set the EmptyState
        self.EmptyScreen()
        tableView.allowsMultipleSelectionDuringEditing = true
        
        //TableViewCell Auto resizing
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set the Firebase refrence
        ref = FIRDatabase.database().reference()
        
        // Listen for added and removed
        self.databaseListener()
    }
    
    
    func databaseListener() {
        
        let user = FIRAuth.auth()?.currentUser
        
        // Added listener
        ref!.child("tests/\(user!.uid)").observe(.childAdded, with: { (snapshot) in
            
            if let fdata = snapshot.value as? NSDictionary {
                
                let tdatum = fdata["TDatum"] as! Int
                
                let tfach = fdata["TFach"] as! String
                
                let ttext = fdata["TText"] as! String
                
                let tID = snapshot.key
                
                let homeObject2 = TestsStruct(TDatum: tdatum, TFach: tfach, TText: ttext, TUid: tID)
                
                // compare dates
                switch tdatum < Date().getDateFromZeroHour{
                    
                case true:
                    // delete earlier dates data from database
                    self.ref!.child("tests/\(user!.uid)/\(snapshot.key)").removeValue()
                    
                case false:
                    // save data in dictionary
                    if self.data[tdatum] == nil {
                        self.data[tdatum] = [homeObject2]
                    }else {
                        self.data[tdatum]!.append(homeObject2)
                    }
                }
            }
            
            self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
            self.tableView.reloadData()
            self.EmptyScreen()
        })
        
        // Remove listener
        ref!.child("tests/\(user!.uid)").observe(.childRemoved, with: { (snapshot) in
            
            if let fdata = snapshot.value as? NSDictionary {
                
                let tdatum = fdata["TDatum"] as! Int
                let tID = snapshot.key
                
                let filterdArr2 = self.data[tdatum]!.filter({$0.TUid != tID})
                
                if filterdArr2.count > 0 {
                    self.data[tdatum] = filterdArr2
                }else {
                    self.data.removeValue(forKey: tdatum)
                }
            }
            
            self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
            self.tableView.reloadData()
            self.EmptyScreen()
        })
    }

    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sortedData.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sortedData[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sortedData[section].0.convertTimestampToDate
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TestCell")
        cell.textLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].TText
        cell.detailTextLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].TFach
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    
    // Here deleting the Posts
    // Delete Part
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete{
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            let test = self.sortedData[indexPath.section].1[indexPath.row]
            self.ref!.child("tests/\(uid!)/\(test.TUid)").removeValue()
            
        }
    }
    
    
    // Func for EmptyState
    
    func EmptyScreen () {
        
        if tableView.visibleCells.count == 0 {
            tableView.backgroundView = UIImageView(image: UIImage(named: "EmptyTest"))
            tableView.separatorStyle = .none
   
        } else{
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }


    
    // UIBarButtons Functions
    
    @IBAction func cancelTests (_ segue:UIStoryboardSegue) {
    }
    @IBAction func saveTests (_ segue:UIStoryboardSegue) {
    }



}

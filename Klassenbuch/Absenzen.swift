//
//  Absenzen.swift
//  Klassenbuch
//
//  Created by Developing on 11.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

struct AbsenzenStruct {
    var ADatum: Int
    var AStatus: String
    var APerson: String
    var AUid: String
}


class Absenzen: UITableViewController {
    
    
    
    // Variables
    
    var data = [Int: [AbsenzenStruct]]() // Date: Homework Object
    var sortedData = [(Int, [AbsenzenStruct])]()
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
        ref!.child("absenzen/\(user!.uid)").observe(.childAdded, with: { (snapshot) in
            
            if let fdata = snapshot.value as? NSDictionary {
                
                let adatum = fdata["ADatum"] as! Int
                
                let astatus = fdata["AStatus"] as! String
                
                let aperson = fdata["APerson"] as! String
                
                let aID = snapshot.key
                
                let homeObject3 = AbsenzenStruct(ADatum: adatum, AStatus: astatus, APerson: aperson, AUid: aID)
                
                // compare dates
                switch adatum < Date().getDateFromZeroHour {
                    
                case true:
                    // delete earlier dates data from database
                    self.ref!.child("absenzen/\(user!.uid)/\(snapshot.key)").removeValue()
                    
                case false:
                    // save data in dictionary
                    if self.data[adatum] == nil {
                        self.data[adatum] = [homeObject3]
                    }else {
                        self.data[adatum]!.append(homeObject3)
                    }
                }
            }
            
            self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
            self.tableView.reloadData()
            self.EmptyScreen()
        })
        
        // Remove listener
        ref!.child("absenzen/\(user!.uid)").observe(.childRemoved, with: { (snapshot) in
            
            if let fdata = snapshot.value as? NSDictionary {
                
                let adatum = fdata["ADatum"] as! Int
                let aID = snapshot.key
                
                let filterdArr = self.data[adatum]!.filter({$0.AUid != aID})
                
                if filterdArr.count > 0 {
                    self.data[adatum] = filterdArr
                }else {
                    self.data.removeValue(forKey: adatum)
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
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AbsenzenCell")
        cell.textLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].APerson
        cell.detailTextLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].AStatus
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    // Here deleting the Posts
    // Delete Part
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete{
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            let absenz = self.sortedData[indexPath.section].1[indexPath.row]
            self.ref!.child("absenzen/\(uid!)/\(absenz.AUid)").removeValue()
            
        }
    }

    
    
    
    
    // Func for EmptyState
    
    func EmptyScreen () {
        
        if tableView.visibleCells.count == 0 {
            
            tableView.backgroundView = UIImageView(image: UIImage(named: "EmptyAbsenzen"))
            tableView.separatorStyle = .none
        } else{
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }
    
    //UIBarButton Functions
    
    @IBAction func cancelAbsenzen (_ segue:UIStoryboardSegue) {
    }
    


}

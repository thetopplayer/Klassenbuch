//
//  Hausaufgaben.swift
//  Klassenbuch
//
//  Created by Developing on 11.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//  Original


import UIKit
import FirebaseDatabase
import FirebaseAuth
import StoreKit


struct Homework {
    var HDatum: Int
    var HFach: String
    var HText: String
    var HUid: String
}


class Hausaufgaben: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // if privat title = meine Hausaufgaben
    
    
    // Variables
    
    var data = [Int: [Homework]]() // Date: Homework Object
    var sortedData = [(Int, [Homework])]()
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?

    var myName = String()
    var myKlasse = String()
    var myEmail = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup EmtyState
        self.EmptyScreen()
        
        self.RateApp()
        
        //Setup Onboarding
        // self.FirstLoginOnboarding()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        //TableViewCell Auto resizing
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set the Firebase refrence
        ref = FIRDatabase.database().reference()
        
        // Listen for added and removed
        self.databaseListener()

    }
  
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
    }

    
 
    func databaseListener() {
        
       
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref = FIRDatabase.database().reference()
        
   
        
        ref?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myKlasse = item
                
                    // Added listener
                self.ref!.child("homework/\(self.myKlasse)").observe(.childAdded, with: { (snapshot) in
                    
                    if let fdata = snapshot.value as? NSDictionary {
                        
                        let hdatum = fdata["HDatum"] as! Int
                        
                        let hfach = fdata["HFach"] as! String
                        
                        let htext = fdata["HText"] as! String
                        
                        let hID = snapshot.key
                        
                        let homeObject = Homework(HDatum: hdatum, HFach: hfach, HText: htext, HUid: hID)
                        
                        // compare dates
                        switch hdatum < Date().getDateFromZeroHour {
                            
                        case true:
                            // delete earlier dates data from database
                            self.ref!.child("homework/\(self.myKlasse)/\(snapshot.key)").removeValue()
                            
                        case false:
                            // save data in dictionary
                            if self.data[hdatum] == nil {
                                self.data[hdatum] = [homeObject]
                            }else {
                                self.data[hdatum]!.append(homeObject)
                            }
                        }
                    }
                    
                    self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
                    self.tableView.reloadData()
                    self.EmptyScreen()
                })
                
                // Remove listener
                self.ref!.child("homework/\(self.myKlasse)").observe(.childRemoved, with: { (snapshot) in
                    
                    if let fdata = snapshot.value as? NSDictionary {
                        
                        let hdatum = fdata["HDatum"] as! Int
                        let hID = snapshot.key
                        
                        let filterdArr = self.data[hdatum]?.filter({$0.HUid != hID})
                        
                        if (filterdArr?.count)! > 0 {
                            self.data[hdatum]! = (filterdArr)!
                        }else {
                            self.data.removeValue(forKey: hdatum)
                        }
                    }
                    
                    self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
                    self.tableView.reloadData()
                    self.EmptyScreen()
                })
  
                
                
                
            }
        })

            }

    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sortedData.count
    }
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sortedData[section].1.count
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sortedData[section].0.convertTimestampToDate
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "HausaufgabenCell")
       
        cell.textLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].HText
        cell.detailTextLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].HFach
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Enables editing only for the selected table view, if you have multiple table views
        return true
    }
    
    
     func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Löschen"
    }
    
    // Here deleting the Posts
    // Delete Part
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete{
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            let homework = self.sortedData[indexPath.section].1[indexPath.row]
            
            
            self.ref?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let item = snapshot.value as? String{
                    self.myKlasse = item
            
            self.ref!.child("homework/\(self.myKlasse)/\(homework.HUid)").removeValue()
                    
        
                }
        
                
            }
            )}}
    // Func for EmptyState
    
    func EmptyScreen () {
    
        if tableView.visibleCells.count == 0 {
            
        tableView.backgroundView = UIImageView(image: UIImage(named: "EmptyHomework"))
         tableView.separatorStyle = .none
        } else{
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
        }
    }
    
    func RateApp () {
        if tableView.visibleCells.count == 10 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        }else {}
 
    }
    
    // UIBarButtons Functions
    
    @IBAction func cancelHausaufgaben (_ segue:UIStoryboardSegue) {
    }

    @IBAction func saveHausaufgaben (_ segue:UIStoryboardSegue) {
    }
    
    


}

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


struct Homework2 {
    var HDatum: Int
    var HFach: String
    var HText: String
    var HUid: String
}

class Hausaufgaben: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var SegmentedController: UISegmentedControl!
    @IBOutlet weak var Header: UINavigationItem!
    
    
    // Variables
    
    var data = [Int: [Homework]]() // Date: Homework Object
    var sortedData = [(Int, [Homework])]()
   
    var data2 = [Int: [Homework2]]()
    var sortedData2 = [(Int, [Homework2])]()
    
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?

    var myName = String()
    var myKlasse = String()
    var myEmail = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
           

    
    
    
        //Setup EmtyState
        self.EmptyScreen()
//        self.CheckIfUsesIsAdmin()
    
        self.RateApp()
        
        //Setup Onboarding
        // self.FirstLoginOnboarding()
        
       
        tableView.isHidden = false
        tableView2.isHidden = true
        
        //TableViewCell Auto resizing
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        
        //TableViewCell Auto resizing
        tableView2.estimatedRowHeight = 44
        tableView2.rowHeight = UITableViewAutomaticDimension
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.allowsMultipleSelectionDuringEditing = true
        
        // Set the Firebase refrence
        ref = FIRDatabase.database().reference()
        
        // Listen for added and removed
        //self.checkForSegmentControlle()
        self.databaseListener()
        self.privatedatabaseListener()

    }
  
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
    }

    
//    func checkForSegmentControlle(){
//    
//        if SegmentedController.selectedSegmentIndex == 0 {
//        
//            databaseListener()
//            print("Klasse")
//            
//        } else if SegmentedController.selectedSegmentIndex == 1 {
//        
//            privatedatabaseListener()
//            print("Privat")
//        }
//    }
    
 
    func databaseListener() {
        
       
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref = FIRDatabase.database().reference()
        
   
        
        ref?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myKlasse = item
                
                    // Added listener
                self.ref!.child("HausaufgabenKlassen/\(self.myKlasse)").observe(.childAdded, with: { (snapshot) in
                    
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
                            self.ref!.child("HausaufgabenKlassen/\(self.myKlasse)/\(snapshot.key)").removeValue()
                            
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
                self.ref!.child("HausaufgabenKlassen/\(self.myKlasse)").observe(.childRemoved, with: { (snapshot) in
                    
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

    
    func privatedatabaseListener() {
        
        // do private STuff here
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref = FIRDatabase.database().reference()
        
        
        
        ref?.child("users").child("Schüler").child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myName = item
                
                // Added listener
                self.ref!.child("HausaufgabenSchüler/\(self.myName)").observe(.childAdded, with: { (snapshot) in
                    
                    if let fdata2 = snapshot.value as? NSDictionary {
                        
                        let hdatum2 = fdata2["HDatum"] as! Int
                        
                        let hfach2 = fdata2["HFach"] as! String
                        
                        let htext2 = fdata2["HText"] as! String
                        
                        let hID2 = snapshot.key
                        
                        let homeObject2 = Homework2(HDatum: hdatum2, HFach: hfach2, HText: htext2, HUid: hID2)
                        
                        // compare dates
                        switch hdatum2 < Date().getDateFromZeroHour {
                            
                        case true:
                            // delete earlier dates data from database
                            self.ref!.child("HausaufgabenSchüler/\(self.myName)/\(snapshot.key)").removeValue()
                            
                        case false:
                            // save data in dictionary
                            if self.data2[hdatum2] == nil {
                                self.data2[hdatum2] = [homeObject2]
                            }else {
                                self.data2[hdatum2]!.append(homeObject2)
                            }
                        }
                    }
                    
                    self.sortedData2 = self.data2.sorted(by: { $0.0.key < $0.1.key})
                    self.tableView2.reloadData()
                    self.EmptyScreen()
                })
                
                // Remove listener
                self.ref!.child("HausaufgabenSchüler/\(self.myName)").observe(.childRemoved, with: { (snapshot) in
                    
                    if let fdata2 = snapshot.value as? NSDictionary {
                        
                        let hdatum2 = fdata2["HDatum"] as! Int
                        let hID2 = snapshot.key
                        
                        let filterdArr2 = self.data2[hdatum2]?.filter({$0.HUid != hID2})
                        
                        if (filterdArr2?.count)! > 0 {
                            self.data2[hdatum2]! = (filterdArr2)!
                        }else {
                            self.data2.removeValue(forKey: hdatum2)
                        }
                    }
                    
                    self.sortedData2 = self.data2.sorted(by: { $0.0.key < $0.1.key})
                    self.tableView2.reloadData()
                    self.EmptyScreen()
                })
                
                
                
                
            }
        })
        
    }

    @IBAction func SegmentChanged(_ sender: Any) {
        
        if SegmentedController.selectedSegmentIndex == 0 {
            
          
           
            tableView.isHidden = false
            tableView2.isHidden = true
            Header.title = "Hausaufgaben"
            
            print("Klasse")
            
        } else if SegmentedController.selectedSegmentIndex == 1 {
            
        
            print("Privat")
            tableView.isHidden = true
            tableView2.isHidden = false
            Header.title = "Meine Hausaufgaben"
        }
        
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        
        var count:Int?
        
        if tableView == self.tableView {
            count =  self.sortedData.count
        }else if tableView == self.tableView2 {
            count = self.sortedData2.count
        }
        return count!
    }
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        var count:Int?
        
        if tableView == self.tableView {
           count =  self.sortedData[section].1.count
        }else if tableView == self.tableView2 {
           count = self.sortedData2[section].1.count
        }
        return count!
    }


     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var name:String?
        
        if tableView == self.tableView {
            name = self.sortedData[section].0.convertTimestampToDate
            
        }else if tableView == self.tableView2 {
            name = self.sortedData2[section].0.convertTimestampToDate
            
        }
        
        
        return name
        
        
        
       // return self.sortedData[section].0.convertTimestampToDate
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var cell : UITableViewCell?
        
        if tableView == self.tableView {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "HausaufgabenCell")
            
            cell!.textLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].HText
            cell!.detailTextLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].HFach
            cell!.textLabel?.numberOfLines = 0
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
        
        }else if tableView == self.tableView2 {
            
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "HausaufgabenPrivateCell")
            
            cell!.textLabel?.text = self.sortedData2[indexPath.section].1[indexPath.row].HText
            cell!.detailTextLabel?.text = self.sortedData2[indexPath.section].1[indexPath.row].HFach
            cell!.textLabel?.numberOfLines = 0
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
        }
 
        return cell!
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
        
        if tableView == self.tableView {
            // fettes if wege schüler privat etc.
            
            if editingStyle == UITableViewCellEditingStyle.delete{
                
                let user = FIRAuth.auth()?.currentUser
                let uid = user?.uid
                
                let homework = self.sortedData[indexPath.section].1[indexPath.row]
                
                
                
                
                
                self.ref?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let item = snapshot.value as? String{
                        self.myKlasse = item
                        
                        self.ref!.child("HausaufgabenKlassen/\(self.myKlasse)/\(homework.HUid)").removeValue()
                        
                    }
                    
                }
                )}

            
            
        }else if tableView == self.tableView2 {
           
            // fettes if wege schüler privat etc.
            
            if editingStyle == UITableViewCellEditingStyle.delete{
                
                let user = FIRAuth.auth()?.currentUser
                let uid = user?.uid
                
                let homework2 = self.sortedData2[indexPath.section].1[indexPath.row]
                
                
                
                
                
                self.ref?.child("users").child("Schüler").child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let item = snapshot.value as? String{
                        self.myName = item
                        
                        self.ref!.child("HausaufgabenSchüler/\(self.myName)/\(homework2.HUid)").removeValue()
                        
                    }
                    
                }
                )}

        }
        
    }
    // Func for EmptyState
    
    func EmptyScreen () {
    
        if tableView.visibleCells.count == 0 {
            
        tableView.backgroundView = UIImageView(image: UIImage(named: "EmptyHomework"))
         tableView.separatorStyle = .none
        } else{
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
        }
        if tableView2.visibleCells.count == 0 {
            tableView2.backgroundView = UIImageView(image: UIImage(named: "EmptyHomework"))
            tableView2.separatorStyle = .none
            
        } else{
            tableView2.backgroundView = nil
            tableView2.separatorStyle = .singleLine
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
    
    func CheckIfUsesIsAdmin(){
    
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        print("xyxcsdcadsfadsf")
        UserDefaults.standard.set(false, forKey: "isAdmin")
        UserDefaults.standard.synchronize()
        print("not admin1")

        
        
    }
}

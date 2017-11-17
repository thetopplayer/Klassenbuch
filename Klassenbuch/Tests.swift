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




class Tests: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var AddAbsenzBarBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var SegmentedController: UISegmentedControl!
    @IBOutlet weak var Header: UINavigationItem!
    // Variables
    
    var data = [Int: [TestsStruct]]() // Date: Homework Object
    var sortedData = [(Int, [TestsStruct])]()
    var data2 = [Int: [TestsStruct2]]() // Date: Homework Object
    var sortedData2 = [(Int, [TestsStruct2])]()
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    
    var myName = String()
    var myKlasse = String()
    var myEmail = String()

    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        
        
        
        // Set the EmptyState
        self.EmptyScreen()
        
        
        tableView.isHidden = false
        tableView2.isHidden = true
        
        //TableViewCell Auto resizing
        tableView2.estimatedRowHeight = 44
        tableView2.rowHeight = UITableViewAutomaticDimension
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.allowsMultipleSelectionDuringEditing = true
        
        
        //TableViewCell Auto resizing
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        // Set the Firebase refrence
        ref = FIRDatabase.database().reference()
        
        // Listen for added and removed
        self.databaseListener()
        self.privatedatabaseListener()
    }
    
    
    func databaseListener() {
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myKlasse = item
                
      
        
        // Added listener
        self.ref!.child("TestsKlassen/\(self.myKlasse)").observe(.childAdded, with: { (snapshot) in
            
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
            
            self.sortedData = self.data.sorted(by: { $0.key < $1.key})
            self.tableView.reloadData()
            self.EmptyScreen()
        })
        
        // Remove listener
        self.ref!.child("TestsKlassen/\(self.myKlasse)").observe(.childRemoved, with: { (snapshot) in
            
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
            
            self.sortedData = self.data.sorted(by: { $0.key < $1.key})
            self.tableView.reloadData()
            self.EmptyScreen()
        })      }
        })
    }

    
    func privatedatabaseListener() {
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref?.child("users").child("Schüler").child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myName = item
                
                
                
                // Added listener
                self.ref!.child("TestsSchüler/\(self.myName)").observe(.childAdded, with: { (snapshot) in
                    
                    if let fdata3 = snapshot.value as? NSDictionary {
                        
                        let tdatum2 = fdata3["TDatum"] as! Int
                        
                        let tfach2 = fdata3["TFach"] as! String
                        
                        let ttext2 = fdata3["TText"] as! String
                        
                        let tID2 = snapshot.key
                        
                        let homeObject8 = TestsStruct2(TDatum: tdatum2, TFach: tfach2, TText: ttext2, TUid: tID2)
                        
                        // compare dates
                        switch tdatum2 < Date().getDateFromZeroHour{
                            
                        case true:
                            // delete earlier dates data from database
                            self.ref!.child("TestsSchüler/\(self.myName)/\(snapshot.key)").removeValue()
                            
                        case false:
                            // save data in dictionary
                            if self.data2[tdatum2] == nil {
                                self.data2[tdatum2] = [homeObject8]
                            }else {
                                self.data2[tdatum2]!.append(homeObject8)
                            }
                        }
                    }
                    
                    self.sortedData2 = self.data2.sorted(by: { $0.key < $1.key})
                    self.tableView2.reloadData()
                    self.EmptyScreen()
                })
                
                // Remove listener
                self.ref!.child("TestsSchüler/\(self.myName)").observe(.childRemoved, with: { (snapshot) in
                    
                    if let fdata2 = snapshot.value as? NSDictionary {
                        
                        let tdatum2 = fdata2["TDatum"] as! Int
                        let tID2 = snapshot.key
                        
                        let filterdArr3 = self.data2[tdatum2]!.filter({$0.TUid != tID2})
                        
                        if filterdArr3.count > 0 {
                            self.data2[tdatum2] = filterdArr3
                        }else {
                            self.data2.removeValue(forKey: tdatum2)
                        }
                    }
                    
                    self.sortedData2 = self.data2.sorted(by: { $0.key < $1.key})
                    self.tableView2.reloadData()
                    self.EmptyScreen()
                })      }
        })
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
    
     func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Löschen"
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
            
            if let weekday = weekday.getDayOfWeek(self.sortedData[section].0.convertTimestampToDate) {
                print(weekday)
                name = "\(weekday) \(self.sortedData[section].0.convertTimestampToDate)"
            } else {
                print("bad input")
                name = "\(self.sortedData[section].0.convertTimestampToDate)"
            }
            
        }else if tableView == self.tableView2 {
            if let weekday = weekday.getDayOfWeek(self.sortedData[section].0.convertTimestampToDate) {
                print(weekday)
                name = "\(weekday) \(self.sortedData[section].0.convertTimestampToDate)"
            } else {
                print("bad input")
                name = "\(self.sortedData[section].0.convertTimestampToDate)"
            }
        }
        return name
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var cell : UITableViewCell?
        
        if tableView == self.tableView {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TestCell")
            cell!.textLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].TText
            cell!.detailTextLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].TFach
            cell!.textLabel?.numberOfLines = 0
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            
            
        }else if tableView == self.tableView2 {
            
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TestPrivatCell")
            cell!.textLabel?.text = self.sortedData2[indexPath.section].1[indexPath.row].TText
            cell!.detailTextLabel?.text = self.sortedData2[indexPath.section].1[indexPath.row].TFach
            cell!.textLabel?.numberOfLines = 0
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
        return cell!

    }
    
    
    // Here deleting the Posts
    // Delete Part
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
      
        
        if tableView == self.tableView {
        if editingStyle == UITableViewCellEditingStyle.delete{
            
            let test = self.sortedData[indexPath.section].1[indexPath.row]
            
            self.ref?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let item = snapshot.value as? String{
                    self.myKlasse = item
            
            
            
            
            self.ref!.child("TestsKlassen/\(self.myKlasse)/\(test.TUid)").removeValue()
            
                }  }
            )}
   
        } else if tableView == self.tableView2 {
        
        
            if editingStyle == UITableViewCellEditingStyle.delete{
  
                let test2 = self.sortedData2[indexPath.section].1[indexPath.row]
  
                
                self.ref?.child("users").child("Schüler").child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let item = snapshot.value as? String{
                        self.myName = item
                
                
                self.ref!.child("TestsSchüler/\(self.myName)/\(test2.TUid)").removeValue()
                        tableView.reloadData()
                    }}
                    )}
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
        
        if tableView2.visibleCells.count == 0 {
            tableView2.backgroundView = UIImageView(image: UIImage(named: "EmptyTest"))
            tableView2.separatorStyle = .none
            
        } else{
            tableView2.backgroundView = nil
            tableView2.separatorStyle = .singleLine
        }
        }


    
    // UIBarButtons Functions
    
    @IBAction func cancelTests (_ segue:UIStoryboardSegue) {
    }
    @IBAction func saveTests (_ segue:UIStoryboardSegue) {
    }
    
    
    
    
    
    
    @IBAction func SegmentChanged(_ sender: Any) {
    
        if SegmentedController.selectedSegmentIndex == 0 {
            
            
            
            tableView.isHidden = false
            tableView2.isHidden = true
            Header.title = "Tests"
            
            print("Klasse")
            
        } else if SegmentedController.selectedSegmentIndex == 1 {
            
            
            print("Privat")
            tableView.isHidden = true
            tableView2.isHidden = false
            Header.title = "Meine Tests"
        }

    
    
    
    
    }

//    func getInfos(){
//        
//        var ref:FIRDatabaseReference?
//        
//        let user = FIRAuth.auth()?.currentUser
//        let uid = user?.uid
//        
//        ref = FIRDatabase.database().reference()
//        
//        // handle = ref?.child("users").child("Schüler").child(uid!).observe(.value, with: { (snapshot) in
//        
//        //      self.ref?.child("users").child("Schüler").child(uid!).updateChildValues(["name": Namen])
//        
//        ref?.child("users").child("Schüler").child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if let item = snapshot.value as? String{
//                self.myName = item
//            }
//        })
//        
//        ref?.child("users").child("Schüler").child(uid!).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if let item = snapshot.value as? String{
//                self.myEmail = item
//                
//            }
//        })
//        
//        
//     
//    }

}

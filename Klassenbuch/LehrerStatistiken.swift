//
//  LehrerStatistiken.swift
//  Klassenbuch
//
//  Created by Developing on 05.09.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//
import UIKit
import FirebaseDatabase
import FirebaseAuth

struct AbsenzenStatistiken{
    
    var APerson: String
    var AAnzahlStunden: Int
    var AAbsenzenOffen: Int
    var AAbsenzenentschuldigt: Int
    var AAbsenzenunentschuldigt: Int
    var AUid: String
    
}

class LehrerStatistiken: UITableViewController {
    
    // Variables
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    var data = [AbsenzenStatistiken]()
    var myclass = String()
    var classmembers = [String]()
    // Outlets
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check hey werdet statistike überhaupt gfüehrtet? Has Child test süscht empty State
        // Set the Firebase refrence
        ref = FIRDatabase.database().reference()
        getData()
    }
    
    
    
    func getData(){
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        print("asfasdfadsfsaf")
                ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                    print("adfasdfasf")
                    if let item = snapshot.value as? String{
                        self.myclass = item
                        print(self.myclass)
        
        self.classmembers = ["jerome hadorn", "larina caspar"]
        var index = 0
        var newindex = 0
        
        repeat{
            
            self.ref!.child("Statistiken/\(self.myclass)/\(self.classmembers[index])").observe(.value, with: { (snapshot) in
                print("afasdfkbaskf")
                
                
                
                //        // Added listener
                //                ref!.child("Statistiken/N6aHS 17-18").observe(.value, with: { (snapshot) in
                //                                        print("afasdfkbaskf")
                //
                //                    // putting all members here and then running those to get data
                //
                //
                
                if let fdata = snapshot.value as? NSDictionary {
                    
                    let aperson = fdata["APerson"] as! String
                    
                    let aanzahlStunden = fdata["AAnzahlStunden"] as! Int
                    
                    let aabsenzenOffen = fdata["AAbsenzenOffen"] as! Int
                    
                    let aabsenzenentschuldigt = fdata["AAbsenzenentschuldigt"] as! Int
                    
                    let aabsenzenunentschuldigt = fdata["AAbsenzenunentschuldigt"] as! Int
                    
                    let aID = snapshot.key
                    
                    let homeobject = AbsenzenStatistiken(APerson: aperson, AAnzahlStunden: aanzahlStunden, AAbsenzenOffen: aabsenzenOffen, AAbsenzenentschuldigt: aabsenzenentschuldigt, AAbsenzenunentschuldigt: aabsenzenunentschuldigt, AUid: aID)
                    
                    self.data.append(homeobject)
                    
                    print(aperson)
                    print(aanzahlStunden)
                    
                    
                }
                
                self.tableView.reloadData()
                
            })
            //            }})
            
            index += 1
        } while (index < self.classmembers.count)
        
        
        
        
        repeat{
            
            self.ref!.child("Statistiken/\(self.myclass)/\(self.classmembers[newindex])").observe(.childChanged, with: { (snapshot) in
                print("afasdfkbaskf")
                
                
                
                //        // Added listener
                //                ref!.child("Statistiken/N6aHS 17-18").observe(.value, with: { (snapshot) in
                //                                        print("afasdfkbaskf")
                //
                //                    // putting all members here and then running those to get data
                //
                //
                
                if let fdata = snapshot.value as? NSDictionary {
                    
                    let aperson = fdata["APerson"] as! String
                    
                    let aanzahlStunden = fdata["AAnzahlStunden"] as! Int
                    
                    let aabsenzenOffen = fdata["AAbsenzenOffen"] as! Int
                    
                    let aabsenzenentschuldigt = fdata["AAbsenzenentschuldigt"] as! Int
                    
                    let aabsenzenunentschuldigt = fdata["AAbsenzenunentschuldigt"] as! Int
                    
                    let aID = snapshot.key
                    
                    let homeobject = AbsenzenStatistiken(APerson: aperson, AAnzahlStunden: aanzahlStunden, AAbsenzenOffen: aabsenzenOffen, AAbsenzenentschuldigt: aabsenzenentschuldigt, AAbsenzenunentschuldigt: aabsenzenunentschuldigt, AUid: aID)
                    
                    if let i = self.classmembers.index(where: {$0 == (aperson) }){
                        
                        let absenz = self.data[i]
                        self.ref!.child("Statistiken/N6aHS 17-18/\(self.classmembers[newindex])/\(absenz.AUid)").removeValue()
                    }
                    //                    self.ref!.child("HausaufgabenKlassen/\(self.myKlasse)/\(homework.HUid)").removeValue()
                    self.data.append(homeobject)
                    
                    print(aperson)
                    print(aanzahlStunden)
                    
                    
                }
                
                self.tableView.reloadData()
                
            })
            //            }})
            
            newindex += 1
        } while (newindex < self.classmembers.count)
                    }})
    }
    
    
    // MARK: - Table view data source
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatistikenCell
        
        // Configure the cell with tag 1,2,3
        
        cell.NameLabel?.text = self.data[indexPath.row].APerson
        cell.EntschuldigtLabel?.text = String(self.data[indexPath.row].AAbsenzenentschuldigt)
        cell.UnentschuldigtLabel?.text = String(self.data[indexPath.row].AAbsenzenunentschuldigt)
        cell.GesamtLabel?.text = String(self.data[indexPath.row].AAnzahlStunden)
        cell.OffenLabel?.text = String(self.data[indexPath.row].AAbsenzenOffen)
        
        return cell
    }
    
    
    
    
}

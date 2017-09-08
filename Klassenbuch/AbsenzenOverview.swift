//
//  AbsenzenOverview.swift
//  Klassenbuch
//
//  Created by Developing on 25.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//y

import UIKit
import FirebaseDatabase
import FirebaseAuth
import UserNotifications

struct AbsenzenStruct4 {
    var ADatum: Int
    var AStatus: String
    var APerson: String
    var AAbgabe : String
    var AAnzahlStunden : Int
    var AUid: String
}

class AbsenzenOverview: UITableViewController, UNUserNotificationCenterDelegate, UITabBarDelegate{
    
 
    
    // Variables
    
    var data = [Int: [AbsenzenStruct4]]() // Date: Homework Object
    var sortedData = [(Int, [AbsenzenStruct4])]()
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    
    var PersonenTitel: String?
    var Absenzdauer: String?
    var AbsenzDatumDate: String?
    var myKlasse = String()
    var TodayTomorrow = "bis Morgen unterschrieben abgeben."
    var myPerson = String()
    override func viewDidLoad() {
        
        // Set the EmptyState
        
        
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        //TableViewCell Auto resizing
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set the Firebase refrence
        ref = FIRDatabase.database().reference()
        
        // Listen for added and removed
       self.databaseListener()
        
        
    }
    
    @IBAction func cancelNewAbsenz (_ segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveNewAbsenz (_ segue:UIStoryboardSegue) {
    }
    
    func databaseListener() {
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        
        ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myKlasse = item
                
        // Added listener
        self.ref!.child("AbsenzenKlassen/\(self.myKlasse)").observe(.childAdded, with: { (snapshot) in
            
            if let fdata = snapshot.value as? NSDictionary {
                
                let adatum = fdata["ADatum"] as! Int
                
                let astatus = fdata["AStatus"] as! String
                
                let aperson = fdata["APerson"] as! String
                
                let aanzahlStunden = fdata["AAnzahlStunden"] as! Int
                
                let aabgabe = fdata["AAbgabe"] as! String
                
                let aID = snapshot.key
                
                let homeObject3 = AbsenzenStruct4(ADatum: adatum, AStatus: astatus, APerson: aperson, AAbgabe: aabgabe, AAnzahlStunden: aanzahlStunden, AUid: aID)//AbsenzenStruct4(ADatum: adatum, AStatus: astatus, APerson: aperson, AAnzahlStunden : aanzahlStunden, AAbgabe : aabgabe, AUid: aID)
                
                if self.data[adatum] == nil {
                    self.data[adatum] = [homeObject3]
                }else {
                    self.data[adatum]!.append(homeObject3)
                }
//                print(aID)
                
                // Check if Reminders are wished
                if UserDefaults.standard.bool(forKey: "TeacherReminders") == true {
                    print("wants reminders")
                    self.Reminder(Person: aperson, AbsenzDate: adatum, Status: astatus)
                } else if UserDefaults.standard.bool(forKey: "TeacherReminders") == false {
                    print("dont want's reminders")
                }
                
            }
            
            self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
            self.tableView.reloadData()
            
        })
        
        // Remove listener
       self.ref!.child("AbsenzenKlassen/\(self.myKlasse)").observe(.childRemoved, with: { (snapshot) in
            
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
            
        })
                
                
            }
        })
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        //view.tintColor = UIColor.red
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        
        let sectionTitle = header.textLabel!.text
        
        
        
        // Taking the SectionheaderTitle and saving it and changig it from a String to Date
        
        let SectiondateInString = sectionTitle
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MMM yyyy"
        let SectionDateinDate = dateformatter.date(from: (SectiondateInString)!)
        // print(SectionDateinDate as Any)
        let AbsenzDatum = SectionDateinDate
        
        
        
        // Declaring Dates
        let Ablaufdatum = SectionDateinDate! + 1209600  // 2 Wochen Vorbei Abgelaufen!
        
        
        
        if Ablaufdatum > Date(){
            
            if AbsenzDatum! + 604800 > Date(){
                
                
                if AbsenzDatum! + 302400 > Date(){
                    // Default Values, noch im OK Bereich
                    header.backgroundView?.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
                    header.textLabel?.textColor = UIColor.black
                    
                    
                }else{
                    // 3 Tage sind bereits vorbei
                    header.backgroundView?.backgroundColor = UIColor(red:0.92, green:0.51, blue:0.51, alpha:1.0)
                    
                    
                }
            }else{
                // Eine Woche bereits vorbei
                
                header.backgroundView?.backgroundColor = UIColor(red:0.98, green:0.34, blue:0.34, alpha:1.0)
                
            }
            
        }else{
            
            // Definitiv Abgelaufen
            header.backgroundView?.backgroundColor = UIColor(red:0.96, green:0.24, blue:0.24, alpha:1.0)
            
            
        }
        
    }
    
    
    
    
    
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
        cell.accessoryType = .detailButton
        cell.tintColor = UIColor(red:0.17, green:0.22, blue:0.45, alpha:1.0)
        
        return cell
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        // Taking Sectionheader Title and putting it in a variable
        let sectionHeaderView = tableView.headerView(forSection: indexPath.section)
        
        let sectionTitle = sectionHeaderView!.textLabel!.text
        
        // let absenzstat = self.sortedData[indexPath.section].1[indexPath.row].AStatus
        
        
        
        // Get the cell and the Persontitle from the Cell
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AbsenzenCell")
        //cell.textLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].APerson
        
        let PersonTitle = self.sortedData[indexPath.section].1[indexPath.row].APerson
        
        
        
        // Taking the SectionheaderTitle and saving it and changig it from a String to Date
        
        let SectiondateInString = sectionTitle
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MMM yyyy"
        let SectionDateinDate = dateformatter.date(from: (SectiondateInString)!)
        //print(SectionDateinDate as Any)
        
        
        // Addition of 14 Days to SectionDateinDate to get FutureDateinDate
        let daysToAdd = 14
        var dateComponent = DateComponents()
        dateComponent.day = daysToAdd
        
        let futureDateinDate = Calendar.current.date(byAdding: dateComponent, to: SectionDateinDate!)
        // print(futureDateinDate as Any)
        
        
        // Putting FutureDateinDate to FutureDateInString to display it
        let futureDateinString = dateformatter.string(from: futureDateinDate!)
        //print(futureDateinString)
        
        
        
        
        
        // Creating an ActivitySheet with the Options to Delete and set an Reminder
        
        let AbsenzenSheet = UIAlertController(title: "", message: "\(String(describing: PersonTitle)) muss  die Absenz vom \(String(describing: sectionTitle!)) bis am \(futureDateinString) unterschreiben lassen und abgeben.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: "Absenz Information", attributes: titleFont)
        
        
        
        
        AbsenzenSheet.view.tintColor = UIColor.black
        AbsenzenSheet.setValue(titleAttrString, forKey: "attributedTitle")
        
        
        
        
        
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        
        // Delete Action
        let deleteaction = UIAlertAction(title: "Löschen", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
           
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            let stunden = self.sortedData[indexPath.section].1[indexPath.row].AAnzahlStunden
            let Schülername = self.sortedData[indexPath.section].1[indexPath.row].APerson
            
            self.domath(StundenzumAbziehen: stunden, SchülerName: Schülername)
            
            let absenz = self.sortedData[indexPath.section].1[indexPath.row]
            self.ref!.child("AbsenzenKlassen/\(self.myKlasse)/\(absenz.AUid)").removeValue()
            print("deleted pressed")
//            let absenz = self.sortedData[indexPath.section].1[indexPath.row]
            let absenz2 = self.sortedData[indexPath.section].1[indexPath.row]
//            let myperson = self.sortedData[indexPath.section].1[indexPath.row].APerson
            self.ref!.child("SchülerAbsenzen/\(Schülername)/\(absenz2.AUid)").removeValue()
            print("deleted pressed")
        }
        
        
            AbsenzenSheet.addAction(deleteaction)
        
        AbsenzenSheet.addAction(cancelAction)
        
        self.present(AbsenzenSheet, animated: true, completion: nil)
        
    }
    
    
    func domath(StundenzumAbziehen: Int, SchülerName: String) {
       
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref = FIRDatabase.database().reference()
        ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
            
            
            if let meineklasse = snapshot.value as? String{
                
                
                self.myKlasse = meineklasse
                
                self.ref?.child("Statistiken").child(self.myKlasse).child(SchülerName).child("AAnzahlStunden").observeSingleEvent(of: .value, with:                    { (snapshot) in
                    
                    if let gesamtanzahl = snapshot.value as? Int {
                    
                  let newgesamtzahl = gesamtanzahl - StundenzumAbziehen
                
            
                        self.ref!.child("Statistiken").child(self.myKlasse).child(SchülerName).updateChildValues(["AAnzahlStunden" : newgesamtzahl])
                        
                    
                    }})
                
                self.ref?.child("Statistiken").child(self.myKlasse).child(SchülerName).child("AAbsenzenOffen").observeSingleEvent(of: .value, with:                    { (snapshot) in
                    
                    if let gesamtanzahl = snapshot.value as? Int {
                        
                        let newgesamtzahl = gesamtanzahl - StundenzumAbziehen
                        
                        
                        self.ref!.child("Statistiken").child(self.myKlasse).child(SchülerName).updateChildValues(["AAbsenzenOffen" : newgesamtzahl])
                        
                        
                    }})

                
                
//            self.ref?.child("Statistiken").child(self.myKlasse).child(SchülerName).child("")
            }})
    
    }
    
//    // Func for EmptyState
//    
//    func EmptyScreen () {
//        
//        if tableView.visibleCells.count == 0 {
//            
//            tableView.backgroundView = UIImageView(image: UIImage(named: "EmptyAbsenzen"))
//            tableView.separatorStyle = .none
//        } else{
//            tableView.backgroundView = nil
//            tableView.separatorStyle = .singleLine
//        }
//    }
    

    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ReminderEinrichten"){
            
            let DestViewController = segue.destination as! NewReminderNC
            let targetController = DestViewController.topViewController as! NewReminder
            
            //let targetController = segue.destination as! NewReminder
            targetController.Person = PersonenTitel
            targetController.DauerderAbsenz = Absenzdauer
            targetController.Datum = AbsenzDatumDate
    
            
        }
    }
    

    
    func Reminder(Person: String, AbsenzDate: Int, Status: String){
        
        var triggerDate: Date = Date()
        
        let DateString = AbsenzDate.convertTimestampToDate
        
        //Date formatter
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MMMM yyyy"
        let DateinDate = dateformatter.date(from: DateString)
        
        let daysToAdd = 13
        let daysToAdd2 = 14
        var dateComponent = DateComponents()
        dateComponent.day = daysToAdd
        var dateComponent2 = DateComponents()
        dateComponent2.day = daysToAdd2
        
        let PreReminderDate = Calendar.current.date(byAdding: dateComponent, to: DateinDate!)
        let ReminderDate = Calendar.current.date(byAdding: dateComponent2, to: DateinDate!)
        
        print(PreReminderDate!)
        print(ReminderDate!)
        
        // Content for PreReminder
        let content = UNMutableNotificationContent()
        content.title = "Absenz Errinerung"
        content.body = "SchülerIn \(Person), muss die Absenz vom \(DateString) \(TodayTomorrow)"
        content.sound = UNNotificationSound.default()
        content.badge = 1
        
        // Content for Reminder
        let content2 = UNMutableNotificationContent()
        content2.title = "Absenz Errinerung"
        content2.body = "SchülerIn \(Person),musst die Absenz vom \(DateString) heute abgeben."
        content2.sound = UNNotificationSound.default()
        content2.badge = 1
        
        print(content.body)
        print(content.title)
        print(content.title)
        
        
        let triggerdate1 = PreReminderDate! - 43200
        let TriggerDateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: triggerdate1)
        let trigger = UNCalendarNotificationTrigger(dateMatching: TriggerDateComponents, repeats: false)
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier:  UUID().uuidString, content: content, trigger: trigger)
        print(trigger)
        
        if ReminderDate! < Date() {
            // error the trigger Date already happened
            remindernotValid()
        }else {
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if let error = error{
                    print("Could not create Local notification", error)
                }else if let newdate = trigger.nextTriggerDate(){
                    print("Next notification date:", newdate)
                    print("Errinierung an")
                }
            }
            )
        }
        
        let triggerdate2 = PreReminderDate! - 43200
        let TriggerDateComponents2 = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: triggerdate2)
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: TriggerDateComponents2, repeats: false)
        // let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request2 = UNNotificationRequest(identifier:  UUID().uuidString, content: content2, trigger: trigger2)
        print(trigger2)
        
        if PreReminderDate! < Date() {
            // error the trigger Date already happened
            remindernotValid()
        }else {
            UNUserNotificationCenter.current().add(request2, withCompletionHandler: { (error) in
                if let error = error{
                    print("Could not create Local notification", error)
                }else if let newdate = trigger2.nextTriggerDate(){
                    print("Next notification date:", newdate)
                    print("Errinierung an")
                }
            }
            )
        }
        
        
        
        
    }
   
    func remindernotValid(){
        
        let alertController = UIAlertController(title: "Warnung!", message: "Diese Absenz ist bereits abgelaufen und sie werden keine Benachrichtigung erhalten.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(alertController, animated: true, completion: nil)
    }
    
}



/* compare dates
 switch adatum < Date().getDateFromZeroHour /*- 1209600 -86400*/ {
 
 case true:
 // delete earlier dates data from database
 //self.ref!.child("absenzen/\(user!.uid)/\(snapshot.key)").removeValue()
 //cell.backgroundColor = UICOLor red
 
 if self.data[adatum] == nil {
 self.data[adatum] = [homeObject3]
 }else {
 self.data[adatum]!.append(homeObject3)
 }
 
 
 case false:
 // save data in dictionary
 if self.data[adatum] == nil {
 self.data[adatum] = [homeObject3]
 }else {
 self.data[adatum]!.append(homeObject3)
 }
 
 }*/

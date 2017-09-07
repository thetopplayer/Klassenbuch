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
import UserNotifications


struct AbsenzenStruct3 {
    var ADatum: Int
    var AStatus: String
    var APerson: String
    var AUid: String
}

class Absenzen: UITableViewController, UNUserNotificationCenterDelegate, UITabBarDelegate{
    
    
    // Outlets
    @IBOutlet weak var AddAbsenzButton: UIBarButtonItem!
    
    
    // Variables
    
   var data = [Int: [AbsenzenStruct3]]() // Date: Homework Object
   var sortedData = [(Int, [AbsenzenStruct3])]()
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    
    var PersonenTitel: String?
    var Absenzdauer: String?
    var AbsenzDatumDate: String?
    
    var myName = String()
    var myKlasse = String()
    let myEmail = String()
    var MorningTime = 43200
    //var FireTime: Date
    var TodayTomorrow = "bis Morgen unterschrieben abgeben."
    
    override func viewDidLoad() {
       
        self.checkIfTeacherModeisOff()
        // Set the EmptyState
        self.EmptyScreen()
        
        
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
        
        AddAbsenzButton.isEnabled = false
        
    }
    
    
    func databaseListener() {
        
       
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        
        
        ref = FIRDatabase.database().reference()
        
        databaseHandle = ref?.child("users").child("Schüler").child(uid!).child("name").observe(.value, with: { (snapshot) in
            
            
            if let item = snapshot.value as? String{
                
               self.myName = item
        
               
        // Added listener
        self.ref!.child("SchülerAbsenzen/\(self.myName)").observe(.childAdded, with: { (snapshot) in
            
            if let fdata = snapshot.value as? NSDictionary {
                
                let adatum = fdata["ADatum"] as! Int
                
                let astatus = fdata["AStatus"] as! String
                
                let aperson = fdata["APerson"] as! String
                
                let aID = snapshot.key
                
                let homeObject3 = AbsenzenStruct3(ADatum: adatum, AStatus: astatus, APerson: aperson, AUid: aID)
                
                if self.data[adatum] == nil {
                    self.data[adatum] = [homeObject3]
                }else {
                    self.data[adatum]!.append(homeObject3)
                }

     

            // Check if Reminders are wished                       
                if UserDefaults.standard.bool(forKey: "Reminders") == true {
                    print("wants reminders")
                    self.Reminder(Person: aperson, AbsenzDate: adatum, Status: astatus)
                } else if UserDefaults.standard.bool(forKey: "Reminders") == false {
                    print("dont want's reminders")
                }
            }
            
            self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
            self.tableView.reloadData()
            self.EmptyScreen()
        })
        
        // Remove listener
        self.ref!.child("SchülerAbsenzen/\(self.myName)").observe(.childRemoved, with: { (snapshot) in
            
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
        }
            
            
        )
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
        
        let AbsenzenSheet = UIAlertController(title: "", message: "\(String(describing: PersonTitle)) du musst deine Absenz vom \(String(describing: sectionTitle!)) bis am \(futureDateinString) unterschreiben lassen und abgeben.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]

        let titleAttrString = NSMutableAttributedString(string: "Absenz Information", attributes: titleFont)
        

        

        AbsenzenSheet.view.tintColor = UIColor.black
        AbsenzenSheet.setValue(titleAttrString, forKey: "attributedTitle")

        
        
        
    
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
            print("Cancel Pressed")
                    }
      
//        // Reminder & Status Action
//        
//       let StatusAction = UIAlertAction(title: "Errinerung", style: UIAlertActionStyle.default) { (alert:UIAlertAction) -> Void in
//       
//        let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
//        if notificationType == [] {
//            
//            print("notifications are NOT enabled")
//            
//            let alertController2 = UIAlertController(title: "Ooops", message: "Benachrichtigungen für dieses App sind nicht eingeschaltet", preferredStyle: .alert)
//            
//            alertController2.addAction(UIAlertAction(title: "Einstellungen", style: .default, handler: { (action: UIAlertAction!) in
//                //Go to Settings
//                
//                self.gotoSettings()
//                
//            }))
//            
//            alertController2.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
//                
//            }))
//            
//            
//            
//            
//            self.present(alertController2, animated: true, completion: nil)
//            
//            
//        } else {
//            print("notifications are enabled")
//            
//            // User is registered for notification
//            self.AbsenzDatumDate = sectionHeaderView!.textLabel!.text
//            
//            self.Absenzdauer = self.sortedData[indexPath.section].1[indexPath.row].AStatus
//            
//            self.PersonenTitel = self.sortedData[indexPath.section].1[indexPath.row].APerson
//            
//            self.performSegue(withIdentifier: "ReminderEinrichten", sender: nil)
//            
//            
//            
//        }        }
        
        // Delete Action
        let deleteaction = UIAlertAction(title: "Löschen", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
            
            let absenz = self.sortedData[indexPath.section].1[indexPath.row]
            self.ref!.child("SchülerAbsenzen/\(self.myName)/\(absenz.AUid)").removeValue()
            print("deleted pressed")
        }
        
        
//        AbsenzenSheet.addAction(StatusAction)
        
        // Check if Reminders are wished
        if UserDefaults.standard.bool(forKey: "CanDelete") == true {
            print("User can Delete")
           AbsenzenSheet.addAction(deleteaction) 
            
        } else if UserDefaults.standard.bool(forKey: "CanDelete") == false {
            print("User cant Delete")
        }
    
    
        
    
        AbsenzenSheet.addAction(cancelAction)
        
        self.present(AbsenzenSheet, animated: true, completion: nil)
        
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
    
    @IBAction func cancelAbsenzen1 (_ segue:UIStoryboardSegue) {
    }
    @IBAction func saveAbsenzen (_ segue:UIStoryboardSegue) {
    }
   
    @IBAction func cancelReminder (_ segue:UIStoryboardSegue) {
    }
    @IBAction func saveReminder (_ segue:UIStoryboardSegue) {
        

    }
    
    @IBAction func saveTheAbsenz (_ segue:UIStoryboardSegue) {
    }




    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "ReminderEinrichten"){
//        
//            let DestViewController = segue.destination as! NewReminderNC
//            let targetController = DestViewController.topViewController as! NewReminder
//       
//        //let targetController = segue.destination as! NewReminder
//        targetController.Person = PersonenTitel
//        targetController.DauerderAbsenz = Absenzdauer
//        targetController.Datum = AbsenzDatumDate
//        
//        
//        
//        
//        
//        
//        }
    }

    // Go to Acknowledgements Function in Settings
    
    func gotoSettings() {
        
        print("Send to Settings")
        
        // THIS IS WHERE THE MAGIC HAPPENS!!!!
        
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }

    
    func checkIfTeacherModeisOff(){
    
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref = FIRDatabase.database().reference()
        ref?.child("users").child("Schüler").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
            
            
            if let checkingClass = snapshot.value as? String{
                
                
                self.myKlasse = checkingClass

        self.ref?.child("users").child("KlassenEinstellungen").child(checkingClass).child("HatKlassenLehrer").observe(.value, with: { (snapshot) in

            if snapshot.value as? Bool == true {
                UserDefaults.standard.set(false, forKey: "CanDelete")
                UserDefaults.standard.synchronize()
                
            
               self.AddAbsenzButton.isEnabled = false
                
            } else if snapshot.value as? Bool == false{
                UserDefaults.standard.set(true, forKey: "CanDelete")
                UserDefaults.standard.synchronize()
                self.AddAbsenzButton.isEnabled = true
            
            }
        }
        )
        
            }
        }
            
            
        )

    
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
        content.body = "\(Person), du musst deine Absenz vom \(DateString) \(TodayTomorrow)"
        content.sound = UNNotificationSound.default()
        content.badge = 1
        
        // Content for Reminder
        let content2 = UNMutableNotificationContent()
        content2.title = "Absenz Errinerung"
        content2.body = "\(Person), du musst deine Absenz vom \(DateString) heute abgeben."
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
    

    func checkifUserwantsReminders(){
    
  
    }






func remindernotValid(){

    let alertController = UIAlertController(title: "Oops!", message: "Du willst einen Reminder für eine Absenz einrichten die bereits abgelofen ist.", preferredStyle: .alert)
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

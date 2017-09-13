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
    var AAbgabe : String
    var AAnzahlStunden : Int
    var AUid: String
    var ReminderStatus : Bool
}

struct ReminderStructSchüler{
    
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
    var getdataTimer3 : Timer = Timer()
    var myName = String()
    var myKlasse = String()
    let myEmail = String()
    var MorningTime = 43200
    
    //    var ArrayofNotifs = [Notification]()
    //var FireTime: Date
    var TodayTomorrow = "bis Morgen unterschrieben abgeben."
    let center = UNUserNotificationCenter.current()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        center.getPendingNotificationRequests { (notifications) in
            print("Count: \(notifications.count)XYXYXYXYXYXYXYXYXYXYXYXY")
            for item in notifications {
                print(item.content)
                print(item.identifier)
                
            }
        }
        self.databaseListener()

//        databaseListener()
    }
    
    
    
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
        //        self.databaseListener()
        //        getClass()
      
        AddAbsenzButton.isEnabled = false
              self.getdataTimer3 = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(Absenzen.databaseListener) , userInfo: nil, repeats: true)
    }
    
    
    
    @IBAction func NewSemester(_ sender: Any) {
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        let actionSheet = UIAlertController(title: "", message: "Ist das Semester zu Ende kannst du hier deine alten Absenzen löschen und für Ordnung sorgen. Nach dem Löschen sind deine Absenzen endgültig gelöscht!", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: "Achtung!", attributes: titleFont)
        
        
        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
        
        
        
        
        let logoutAction = UIAlertAction(title: "Neues Semester starten", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
            
            // Statistiken löschen
            self.ref?.child("users").child("Schüler").child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                print("adfasdfasf")
                if let item = snapshot.value as? String{
                    
                    
                    
                    
                    
                    self.ref?.child("SchülerAbsenzen").child(item).removeValue()
                    
                    
                    self.databaseListener()
                    self.sortedData.removeAll()
                    self.data.removeAll()
                    self.tableView.reloadData()
                    
                }})
        }
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        actionSheet.addAction(logoutAction)
        
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    
    
    func databaseListener() {
        
        
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        if self.data.isEmpty == false {
            
            self.sortedData.removeAll()
            self.data.removeAll()
        } else{
            
            print("index empty")
            
        }
        
        ref = FIRDatabase.database().reference()
        
      self.ref?.child("users").child("Schüler").child(uid!).child("name").observe(.value, with: { (snapshot) in
            
            
            if let item = snapshot.value as? String{
                
                self.myName = item
                
                
                // Added listener
                self.ref!.child("SchülerAbsenzen/\(self.myName)").observe(.childAdded, with: { (snapshot) in
                    
                    if let fdata = snapshot.value as? NSDictionary {
                        
                        let adatum = fdata["ADatum"] as! Int
                        
                        let astatus = fdata["AStatus"] as! String
                        
                        let aperson = fdata["APerson"] as! String
                        
                        let aanzahlStunden = fdata["AAnzahlStunden"] as! Int
                        
                        let aabgabe = fdata["AAbgabe"] as! String
                        
                        let areminderStatus = fdata["AReminderStatus"] as! Bool
                        
                        let aID = snapshot.key
                        
                        let homeObject3 = AbsenzenStruct3(ADatum: adatum, AStatus: astatus, APerson: aperson, AAbgabe: aabgabe, AAnzahlStunden: aanzahlStunden, AUid: aID, ReminderStatus: areminderStatus)
                       
                        if self.data[adatum] == nil {
                            self.data[adatum] = [homeObject3]
                    
                        }else {
                            self.data[adatum]!.append(homeObject3)
                       
                        }
//                     self.performSegue(withIdentifier: "away", sender: nil)

                        
                    }
                    
                    self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
                    self.tableView.reloadData()
                    self.EmptyScreen()
                })
                
                //        // Remove listener
                //        self.ref!.child("SchülerAbsenzen/\(self.myName)").observe(.childRemoved, with: { (snapshot) in
                //
                //            if let fdata = snapshot.value as? NSDictionary {
                //
                //                let adatum = fdata["ADatum"] as! Int
                //                let aID = snapshot.key
                //
                //                let filterdArr = self.data[adatum]!.filter({$0.AUid != aID})
                //
                //               if filterdArr.count > 0 {
                //                    self.data[adatum] = filterdArr
                //                }else {
                //                self.data.removeValue(forKey: adatum)
                //                }
                //            }
                //
                //            self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
                //            self.tableView.reloadData()
                //            self.EmptyScreen()
                //        })
                
                
            }
        }
            
            
        )
    }
    
    
//    func getClass(){
//        
//        let user = FIRAuth.auth()?.currentUser
//        let uid = user?.uid
//        ref?.child("users").child("Schüler").child(uid!).child("name").observe(.value, with: { (snapshot) in
//            
//            
//            if let item = snapshot.value as? String{
//                
//                self.myKlasse = item
//                self.childaddedReminder(SchülerName: item)
//            }})
//    }
//    
//    func childaddedReminder(SchülerName: String){
//        
//        print("\(SchülerName)XYXYXYXYXYXYXYX")
//        //        self.Reminder(Person: "asd", AbsenzDate: 1232134251, Status: "adasfasf")
//        
//        ref = FIRDatabase.database().reference()
//        
//        
//        // Added listener
//        self.ref!.child("SchülerAbsenzen/\(SchülerName)").queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
//            if let fdata2 = snapshot.value as? NSDictionary {
//                
//                let adatum = fdata2["ADatum"] as! Int
//                
//                let astatus = fdata2["AStatus"] as! String
//                
//                let aperson = fdata2["APerson"] as! String
//                
//                let ReminderID = snapshot.key
//                
//                let ReminderState = fdata2["AReminderStatus"] as! Bool
//                
//                
//                if ReminderState == true{
//                    
//                    
//                } else if ReminderState == false{
//                    
//                    //                    self.Reminder(Person: aperson, AbsenzDate: adatum, Status: astatus, ReminderStatus: ReminderState, ReminderID: ReminderID)
//                }
//                
//                
//                
//                //                         Check if Reminders are wished
//                //                                        if UserDefaults.standard.bool(forKey: "TeacherReminders") == true {
//                //                                            print("wants reminders")
//                //                                           self.Reminder(Person: aperson, AbsenzDate: adatum, Status: astatus)
//                //                                        } else if UserDefaults.standard.bool(forKey: "TeacherReminders") == false {
//                //                                            print("dont want's reminders")
//                ////                                             self.Reminder(Person: aperson, AbsenzDate: adatum, Status: astatus)
//                //                                        }
//            }
//            //                    self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
//            //                    self.tableView.reloadData()
//            //                    self.EmptyScreen()
//        })
//        
//        
//        
//        
//        
//    }
    
    
    
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AbsenzenCell", for: indexPath) as! AbsenzenCellStatus
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AbsenzenCell") as! Ab
       
        cell.titleLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].APerson
        cell.subtitlelabel?.text = self.sortedData[indexPath.section].1[indexPath.row].AStatus
       
        if self.sortedData[indexPath.section].1[indexPath.row].ReminderStatus == true{
        
        cell.imagebell.isHidden = false
        
        } else{
        
          cell.imagebell.isHidden = true
        }
    
        
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .detailButton
        cell.tintColor = UIColor(red:0.17, green:0.22, blue:0.45, alpha:1.0)
        
               if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Entschuldigt"{
            
            cell.backgroundColor = UIColor(red:0.53, green:0.80, blue:0.55, alpha:1.0)
            
        } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Unentschuldigt"{
            
            cell.backgroundColor = UIColor(red:0.99, green:0.43, blue:0.43, alpha:1.0)
            
        } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "offen"{
            
            cell.backgroundColor = UIColor.clear
        } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "ForceOffen"{
            cell.backgroundColor = UIColor.clear
        }
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
        
                // Reminder & Status Action
        
               let StatusAction = UIAlertAction(title: "Errinerung", style: UIAlertActionStyle.default) { (alert:UIAlertAction) -> Void in
        
                let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
                if notificationType == [] {
        
                    print("notifications are NOT enabled")
        
                    let alertController2 = UIAlertController(title: "Ooops", message: "Benachrichtigungen für dieses App sind nicht eingeschaltet", preferredStyle: .alert)
        
                    alertController2.addAction(UIAlertAction(title: "Einstellungen", style: .default, handler: { (action: UIAlertAction!) in
                        //Go to Settings
        
                        self.gotoSettings()
        
                    }))
        
                    alertController2.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
        
                    }))
        
        
        
        
                    self.present(alertController2, animated: true, completion: nil)
        
        
                } else {
                    print("notifications are enabled")
        
                    let adatum = self.sortedData[indexPath.section].1[indexPath.row].ADatum
                    let aperson = self.sortedData[indexPath.section].1[indexPath.row].APerson
                    let auid = self.sortedData[indexPath.section].1[indexPath.row].AUid
                    //        let aabgabe = self.sortedData[indexPath.section].1[indexPath.row].AAbgabe
                    //        let aanzahlstunden = self.sortedData[indexPath.section].1[indexPath.row].AAnzahlStunden
                    let astatus = self.sortedData[indexPath.section].1[indexPath.row].AStatus
                    let reminderStatus = self.sortedData[indexPath.section].1[indexPath.row].ReminderStatus
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                        self.Reminder(Person: aperson, AbsenzDate: adatum, Status: astatus, ReminderStatus: reminderStatus, ReminderID: auid)
                    }

        
        
        
                }        }
        
        
        
        // Reminder & Status Action
        
        let StatusActionEntfernen = UIAlertAction(title: "Errinerung entfernen", style: UIAlertActionStyle.default) { (alert:UIAlertAction) -> Void in
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
//                let adatum = self.sortedData[indexPath.section].1[indexPath.row].ADatum
//                let aperson = self.sortedData[indexPath.section].1[indexPath.row].APerson
                let auid = self.sortedData[indexPath.section].1[indexPath.row].AUid
                //        let aabgabe = self.sortedData[indexPath.section].1[indexPath.row].AAbgabe
                //        let aanzahlstunden = self.sortedData[indexPath.section].1[indexPath.row].AAnzahlStunden
//                let astatus = self.sortedData[indexPath.section].1[indexPath.row].AStatus
//                let reminderStatus = self.sortedData[indexPath.section].1[indexPath.row].ReminderStatus
            
                var IDentifiers = ["\(auid)YYYYYY","\(auid)XXXXXX"]
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: IDentifiers)
            
            self.ref?.child("users").child("Schüler").child(uid!).child("name").observe(.value, with: { (snapshot) in
                
                
                if let item1 = snapshot.value as? String{
                    
                    
                    self.ref!.child("SchülerAbsenzen").child(item1).child(auid).updateChildValues([
                        "AReminderStatus": false,])
                    
                }
            })
         self.databaseListener()
                    }

        
        // Delete Action
        let deleteaction = UIAlertAction(title: "Löschen", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
            
            let absenz = self.sortedData[indexPath.section].1[indexPath.row]
            self.ref!.child("SchülerAbsenzen/\(self.myName)/\(absenz.AUid)").removeValue()
            print("deleted pressed")
            self.databaseListener()
        }
        
        
        //        AbsenzenSheet.addAction(StatusAction)
        
        // Check if Reminders are wished
        if UserDefaults.standard.bool(forKey: "CanDelete") == true {
            print("User can Delete")
            AbsenzenSheet.addAction(deleteaction)
            
        } else if UserDefaults.standard.bool(forKey: "CanDelete") == false {
            print("User cant Delete")
        }
        
        
        
        if self.sortedData[indexPath.section].1[indexPath.row].ReminderStatus == true{
           
//            Check if Reminders are wished
        if UserDefaults.standard.bool(forKey: "Reminders") == true {
         print("wants reminders")
         AbsenzenSheet.addAction(StatusActionEntfernen)
         
        } else if UserDefaults.standard.bool(forKey: "Reminders") == false {
           print("dont want's reminders")
                                                                                   }

            
            
         
            
        } else{
            
            //            Check if Reminders are wished
            if UserDefaults.standard.bool(forKey: "Reminders") == true {
                print("wants reminders")
                 AbsenzenSheet.addAction(StatusAction)
                
            } else if UserDefaults.standard.bool(forKey: "Reminders") == false {
                print("dont want's reminders")
            }

            
            
        
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
    
    
    
    
    func Reminder(Person: String, AbsenzDate: Int, Status: String, ReminderStatus: Bool, ReminderID: String){
        
        // CHeck if AUID is already in Array if true then kein reminder vlt chenti au neues child mache sobalds serste mal downgloadet wirt AbsenzenReminder == truem denn da check hei isches scho oder ned!
        if ReminderStatus == true{
            
            print("already set Reminder for this Absenz")
        } else if ReminderStatus == false{
            
            //                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [ReminderID])
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            
            
            
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
            
            //                        print(PreReminderDate!)
            //                        print(ReminderDate!)
            
            // Content for PreReminder
            let content = UNMutableNotificationContent()
            content.title = "Absenz Errinerung"
            content.body = "\(Person), du musst deine Absenz vom \(DateString)\(TodayTomorrow)."
            content.sound = UNNotificationSound.default()
            content.badge = 1
            
            
            // Content for Reminder
            let content2 = UNMutableNotificationContent()
            content2.title = "Absenz Errinerung"
            content2.body = "\(Person), du musst deine Absenz vom \(DateString) heute abgeben."
            content2.sound = UNNotificationSound.default()
            content2.badge = 1
            
            //                        print(content.body)
            //                        print(content.title)
            //                        print(content.title)
            //
            
            let triggerdate1 = PreReminderDate! - 43200
            let TriggerDateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: triggerdate1)
            let trigger = UNCalendarNotificationTrigger(dateMatching: TriggerDateComponents, repeats: false)
            // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier:  "\(ReminderID)YYYYYY", content: content, trigger: trigger)
            //                        print(trigger)
            
            
            
            let triggerdate2 = ReminderDate! - 43200
            let TriggerDateComponents2 = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: triggerdate2)
            let trigger2 = UNCalendarNotificationTrigger(dateMatching: TriggerDateComponents2, repeats: false)
            // let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request2 = UNNotificationRequest(identifier: "\(ReminderID)XXXXXX", content: content2, trigger: trigger2)
            //                        print(trigger2)
            
            
            
            
            //            if request2.identifier == ""{
            //
            //                }
            var identifiers: [String] = []
            
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                
                
                for notification:UNNotificationRequest in notificationRequests {
                    
                    identifiers.append(notification.identifier)
                    print("IDentifieersss\(identifiers)")
                    
                }
            }
            
            
            
            
            if identifiers.contains(request2.identifier){
                
                // Yes there is already reminder with this Identfier, dont create new Reminder!
                
                print("Reminder already existis, not going to create a new one ID2")
                
                
                
            }else{
                //No there isn't a reminder with this Idntifier, create a new one!
                
                print("Reminder deosn't existis, going to create a new oneID2")
                if PreReminderDate! < Date() {
                    // error the trigger Date already happened
                    //                            remindernotValid()
                }else {
                    UNUserNotificationCenter.current().add(request2, withCompletionHandler: { (error) in
                        if let error = error{
                            print("Could not create Local notification", error)
                        }else if let newdate = trigger2.nextTriggerDate(){
                            print("Next notification date:", newdate)
                            print("Errinierung an")
                            
                            self.ref?.child("users").child("Schüler").child(uid!).child("name").observe(.value, with: { (snapshot) in
                                
                                
                                if let item1 = snapshot.value as? String{
                                    
                                    
                                    self.ref!.child("SchülerAbsenzen").child(item1).child(ReminderID).updateChildValues([
                                        "AReminderStatus": true,])
                                    
                                }
                            })
                            
                            
                            
                            
                            
                        }
                    }
                    )
                }}
            
            if identifiers.contains(request.identifier){
                // Yes there is already reminder with this Identfier, dont create new Reminder!
                
                print("Reminder already existis, not going to create a new one ID1")
                
                
                
            }else{
                //No there isn't a reminder with this Idntifier, create a new one!
                
                print("Reminder deosn't existis, going to create a new oneID1")
                if PreReminderDate! < Date() {
                    // error the trigger Date already happened
                    //                            remindernotValid()
                }else {
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                        if let error = error{
                            print("Could not create Local notification", error)
                        }else if let newdate = trigger2.nextTriggerDate(){
                            print("Next notification date:", newdate)
                            print("Errinierung an")
                            
                            self.ref?.child("users").child("Schüler").child(uid!).child("name").observe(.value, with: { (snapshot) in
                                
                                
                                if let item1 = snapshot.value as? String{
                                    
                                    
                                    self.ref!.child("SchülerAbsenzen").child(item1).child(ReminderID).updateChildValues([
                                        "AReminderStatus": true,])
                                    self.databaseListener()
                                    
                                }
                            })
                            
                        }
                    }
                    )
                }}
            
            
        }}
    
    
}

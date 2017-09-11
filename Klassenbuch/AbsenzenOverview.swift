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
struct ReminderStruct{

    var ADatum: Int
    var AStatus: String
    var APerson: String
    var AUid: String

}

class AbsenzenOverview: UITableViewController, UNUserNotificationCenterDelegate, UITabBarDelegate{
    
 
    
    // Variables
    
    var data = [Int: [AbsenzenStruct4]]() // Date: Homework Object
    var sortedData = [(Int, [AbsenzenStruct4])]()
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    var getdataTimer2 : Timer = Timer()
    var PersonenTitel: String?
    var Absenzdauer: String?
    var AbsenzDatumDate: String?
    var myKlasse = String()
    var TodayTomorrow = "bis Morgen unterschrieben abgeben."
    var myPerson = String()
    var NewStatus = String()
    var AAStatus = String()
//    var AnzahlStundenSchüler = Int()
    var theStatus   =   String()
    var theNewStatus   =   String()
    override func viewWillDisappear(_ animated: Bool) {
        self.getdataTimer2.invalidate()
        print("timer killed")
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.getdataTimer2.invalidate()
        print("timer killed")
    }
    override func viewWillAppear(_ animated: Bool) {
        databaseListener()
        getClass()
    }
//    override func vi
    override func viewDidLoad() {
        
        // Set the EmptyState
        // Remove listener
  
        super.viewDidLoad()
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        getClass()
        tableView.reloadData()
        UNUserNotificationCenter.current().delegate = self
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        //TableViewCell Auto resizing
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set the Firebase refrence
        ref = FIRDatabase.database().reference()
        
        // Listen for added and removed
//    self.getdataTimer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AbsenzenOverview.databaseListener) , userInfo: nil, repeats: true)
//    self.getdataTimer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AbsenzenOverview.getClass) , userInfo: nil, repeats: true)
//        self.databaseListener()
        
        
    }
    
    
    @IBAction func cancelNewAbsenz (_ segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveNewAbsenz (_ segue:UIStoryboardSegue) {
    }
    
    func databaseListener() {
        
//        getClass()
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        if self.data.isEmpty == false {
            
            self.sortedData.removeAll()
            self.data.removeAll()
        }
        
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
//                self.childaddedReminder()
//                print(aID)
                
//                // Check if Reminders are wished
//                if UserDefaults.standard.bool(forKey: "TeacherReminders") == true {
//                    print("wants reminders")
//                    self.Reminder(Person: aperson, AbsenzDate: adatum, Status: astatus)
//                } else if UserDefaults.standard.bool(forKey: "TeacherReminders") == false {
//                    print("dont want's reminders")
//                }
                
            }
            
            self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
            self.tableView.reloadData()
            
        })
        

       // CHild added, add Reminder
                
            
            
            
            
            
            
            }
        })
//        removed()
    }
    
    func getClass(){
       
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
            
            
            if let item = snapshot.value as? String{
                
                self.myKlasse = item
                self.childaddedReminder(Meineklasse: item)
            }})
    }
    
    func childaddedReminder(Meineklasse: String){
    
        print("\(Meineklasse)XYXYXYXYXYXYXYX")
//        self.Reminder(Person: "asd", AbsenzDate: 1232134251, Status: "adasfasf")
        
        ref = FIRDatabase.database().reference()
        
  
                // Added listener
               self.ref!.child("AbsenzenKlassen/\(Meineklasse)").queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
                    if let fdata = snapshot.value as? NSDictionary {
                        
                        let adatum = fdata["ADatum"] as! Int
                        
                        let astatus = fdata["AStatus"] as! String
                        
                        let aperson = fdata["APerson"] as! String
                        
                        let ReminderID = snapshot.key
                        
                        let ReminderState = fdata["AReminderStatus"] as! Bool
                 
                        self.Reminder(Person: aperson, AbsenzDate: adatum, Status: astatus, ReminderStatus: ReminderState, ReminderID: ReminderID)

                        
//                         Check if Reminders are wished
//                                        if UserDefaults.standard.bool(forKey: "TeacherReminders") == true {
//                                            print("wants reminders")
//                                           self.Reminder(Person: aperson, AbsenzDate: adatum, Status: astatus)
//                                        } else if UserDefaults.standard.bool(forKey: "TeacherReminders") == false {
//                                            print("dont want's reminders")
////                                             self.Reminder(Person: aperson, AbsenzDate: adatum, Status: astatus)
//                                        }
                }
//                    self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
//                    self.tableView.reloadData()
//                    self.EmptyScreen()
                })
        
    
    
    
    
    }
    
    
    func removed(){
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myKlasse = item
                self.ref!.child("AbsenzenKlassen/\(self.myKlasse)").observe(.childRemoved, with: { (snapshot) in
                    
                    if let fdata = snapshot.value as? NSDictionary {
                        
                        let adatum = fdata["ADatum"] as! Int
                        let aID = snapshot.key
                        
                        let filterdArr = self.data[adatum]?.filter({$0.AUid != aID})
                        
                        if (filterdArr?.count)! > 0 {
                            self.data[adatum] = filterdArr
                        }else {
                            self.data.removeValue(forKey: adatum)
                        }
                    }
                    
                    self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
                    self.tableView.reloadData()
                    
                })}})

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
        
        if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Entschuldigt"{
            
            cell.backgroundColor = UIColor.green
            
        } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Unentschuldigt"{
            
            cell.backgroundColor = UIColor.red
            
        } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "offen"{
            
       
        } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "ForceOffen"{
            
        }
        return cell
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        // Taking Sectionheader Title and putting it in a variable
        let sectionHeaderView = tableView.headerView(forSection: indexPath.section)
        
        let sectionTitle = sectionHeaderView!.textLabel!.text
        
        // let absenzstat = self.sortedData[indexPath.section].1[indexPath.row].AStatus
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        
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
        
 
        let PostUID = self.sortedData[indexPath.section].1[indexPath.row].AUid
        var myperson = self.sortedData[indexPath.section].1[indexPath.row].APerson
        let AnzahlStundenSchüler = self.sortedData[indexPath.section].1[indexPath.row].AAnzahlStunden
        
        
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
            let TheStatus = self.sortedData[indexPath.section].1[indexPath.row].AAbgabe
          
            self.domath(StundenzumAbziehen: stunden, SchülerName: Schülername, Status: TheStatus)
            let absenz = self.sortedData[indexPath.section].1[indexPath.row]
           
            self.ref!.child("AbsenzenKlassen/\(self.myKlasse)/\(absenz.AUid)").removeValue()
            print("deleted pressed")

            let absenz2 = self.sortedData[indexPath.section].1[indexPath.row]

            self.ref!.child("SchülerAbsenzen/\(Schülername)/\(absenz2.AUid)").removeValue()
            self.databaseListener()
            self.tableView.reloadData()
        }
        
        // Abegegeben Action
        let AbegegebenAction = UIAlertAction(title: "Entschuldigt", style: UIAlertActionStyle.default) { (alert:UIAlertAction) -> Void in
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            self.NewStatus = "Entschuldigt"
            
//            self.changeAStatus(AbsenzID: PostUID, Person: myperson, Neuerstatus: "banane")
            
            if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Entschuldigt"{
              
                // Hey die Absenz wurde schon abgegeben
                // Keine Statistikänderung
                
                let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Die Absenz wurde bereits als entschuldigt gespeichert!", attributes: titleFont)
                
                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                
                let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)
                
            } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "offen" {
              
                self.AAStatus = "offen"
                // write int from offen to abgegeben und INT zu entschuldigz
           
                self.changeAStatus(AbsenzID: PostUID, Person: myperson, Neuerstatus: self.NewStatus)
                // Statistikänderung, von Offen Subtrahieren und dann Absenzenzahl.azahl in entshculdigt writen
//                self.doStatistcsMath(AStatus: self.AAStatus, ANeuerStatus: self.NewStatus, AnzahlStunden: self.AnzahlStundenSchüler, ASchülerName: myperson)
                
                
//                self.changeAStatus(AbsenzID: PostUID, Person: myperson, Neuerstatus: self.NewStatus)
                self.databaseListener()
                self.doStatisticMath(Status: self.AAStatus, NeuerStatus: self.NewStatus, AnzahlStunden: AnzahlStundenSchüler, Schülername: myperson)
                
             
                
            } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Unentschuldigt"{
                self.AAStatus = "Unentschuldigt"
                // Pop up die Absenz ist abgelofen und wurde auch als soolche gespeichert, sie können güte zeigen und sie trozdem als abgelaufen im nachihnein erklären.
                let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Diese Absenz wurde als Unentschuldigt eingestuft, Sie könne Sie aber nun entschuldigen!", attributes: titleFont)
                
                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                let Action1 = UIAlertAction(title: "Entschuldigen", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
                    
                    self.changeAStatus(AbsenzID: PostUID, Person: myperson, Neuerstatus: self.NewStatus)
                    self.doStatisticMath(Status: self.AAStatus, NeuerStatus: self.NewStatus, AnzahlStunden: AnzahlStundenSchüler, Schülername: myperson)
                    self.databaseListener()
//                    self.tableView.reloadData()

                 }
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                
                actionSheet.addAction(Action1)
                
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)

            }
            else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "ForceOffen"{
                 self.AAStatus = "ForceOffen"
                // Pop up die Absenz ist abgelofen und wurde auch als soolche gespeichert, sie können güte zeigen und sie trozdem als abgelaufen im nachihnein erklären.
                let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Diese Absenz wurde als Passiv eingestuft, Sie könne Sie aber nun entschuldigen!", attributes: titleFont)
                
                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                let Action1 = UIAlertAction(title: "Entschuldigen", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
                    self.changeAStatus(AbsenzID: PostUID, Person: myperson, Neuerstatus: self.NewStatus)
                    self.doStatisticMath(Status: self.AAStatus, NeuerStatus: self.NewStatus, AnzahlStunden: AnzahlStundenSchüler, Schülername: myperson)
                    self.databaseListener()
                }
                
                let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                
                actionSheet.addAction(Action1)
                
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)
                
            }
            
            
        }
        
        // Abgelofen Action
        let AbgelofenAction = UIAlertAction(title: "Unentschuldigt", style: UIAlertActionStyle.default) { (alert:UIAlertAction) -> Void in
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            self.NewStatus = "Unentschuldigt"
            
            if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Entschuldigt"{
                
                self.AAStatus = "Entschuldigt"
                
             // Absenz wurde als abgegeben gespiechet sind sie icher dass sie abgelofen ist Pop up
                let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Diese Absenz wurde als Entschuldigt eingestuft! Wollen Sie die Absenz nun nicht mehr entschuldigen?", attributes: titleFont)
                
                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                let Action1 = UIAlertAction(title: "Unentschuldigen", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
                    self.changeAStatus(AbsenzID: PostUID, Person: myperson, Neuerstatus: self.NewStatus)
                    self.doStatisticMath(Status: self.AAStatus, NeuerStatus: self.NewStatus, AnzahlStunden: AnzahlStundenSchüler, Schülername: myperson)
                    self.databaseListener()

                }
                
                let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                
                actionSheet.addAction(Action1)
                
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)
            } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "offen"{
                
                // Person hat noch zeit
                // Hey die Absenz wurde schon abgegeben
                self.AAStatus = "offen"
                
                // Absenz wurde als abgegeben gespiechet sind sie icher dass sie abgelofen ist Pop up
                let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Diese Absenz  als Entschuldigt eingestuffen?", attributes: titleFont)
                
                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                let Action1 = UIAlertAction(title: "ja", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
                    self.changeAStatus(AbsenzID: PostUID, Person: myperson, Neuerstatus: self.NewStatus)
                    self.doStatisticMath(Status: self.AAStatus, NeuerStatus: self.NewStatus, AnzahlStunden: AnzahlStundenSchüler, Schülername: myperson)
                    self.databaseListener()
                    
                }
                
                let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                
                actionSheet.addAction(Action1)
                
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)
                
            } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Unentschuldigt"{
                
              
                  // Hey die Absenz wurde schon als abeglofen markiert
                // Hey die Absenz wurde schon abgegeben
                let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Die Absenz wurde bereits als unentschuldigt gespeichert!", attributes: titleFont)
                
                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                
                let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)

            } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "ForceOffen"{
                
                self.AAStatus = "ForceOffen"
                // Pop up die Absenz ist abgelofen und wurde auch als soolche gespeichert, sie können güte zeigen und sie trozdem als abgelaufen im nachihnein erklären.
                let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Diese Absenz wurde als Passiv eingestuft, Sie könne Sie aber nun definitv nicht entschuldigen!", attributes: titleFont)
                
                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                let Action1 = UIAlertAction(title: "Unentschuldigen", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
                    self.changeAStatus(AbsenzID: PostUID, Person: myperson, Neuerstatus: self.NewStatus)
                    self.doStatisticMath(Status: self.AAStatus, NeuerStatus: self.NewStatus, AnzahlStunden: AnzahlStundenSchüler, Schülername: myperson)
                    self.databaseListener()
                }
                
                let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                
                actionSheet.addAction(Action1)
                
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)
                
            }

//            self.tableView.reloadData()

        }
        
        // Offen Action
        let OffenAction = UIAlertAction(title: "Offen", style: UIAlertActionStyle.default) { (alert:UIAlertAction) -> Void in
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            self.NewStatus = "ForceOffen"
            
            if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Entschuldigt"{
                  self.AAStatus = "Entschuldigt"
                // super absenz abgegeben
                // Hey die Absenz wurde schon abgegeben
                let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Die Absenz wurde bereits als entschuldigt gespeichert. Sie können Sie aber auch in einem passiven Offenen Status speichern.", attributes: titleFont)
                
                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                let Action1 = UIAlertAction(title: "Passiver Status", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
                    self.changeAStatus(AbsenzID: PostUID, Person: myperson, Neuerstatus: self.NewStatus)
                    self.doStatisticMath(Status: self.AAStatus, NeuerStatus: self.NewStatus, AnzahlStunden: AnzahlStundenSchüler, Schülername: myperson)
                    self.databaseListener()
                }
                let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                actionSheet.addAction(Action1)
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)
                
            

                
            } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "offen" ||  self.sortedData[indexPath.section].1[indexPath.row].AAbgabe ==  "ForceOffen" {
                
                // Ist immer noch offen
                // Hey die Absenz wurde schon abgegeben
                // Hey die Absenz wurde schon abgegeben
                let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Die Absenz ist momentan immer noch Offen!", attributes: titleFont)
                
                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                
                let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)
                
            

                
            } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Unentschuldigt"{
                
                self.AAStatus = "Unentschuldigt"
                // Force making offen die absenz bleibt solange offen bis sie dis manuell ändern.
                // Hey die Absenz wurde schon abgegeben
                let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
                let titleAttrString = NSMutableAttributedString(string: "Die Absenz wurde bereits als unentschuldigt gespeichert! Sie können sie manuell in einen passiven Status setzen. Sie ist weder unentschuldigt noch entschuldigt. Sie müssen sie aber wieder manuell entschuldigen/unentschuldigen!", attributes: titleFont)
                
                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                let Action1 = UIAlertAction(title: "Passiver Status", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
                    self.changeAStatus(AbsenzID: PostUID, Person: myperson, Neuerstatus: self.NewStatus)
                    self.doStatisticMath(Status: self.AAStatus, NeuerStatus: self.NewStatus, AnzahlStunden: AnzahlStundenSchüler, Schülername: myperson)
                    self.databaseListener()
                }

                
                let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                actionSheet.addAction(Action1)
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)
                
          

            }

            
        }

        
        
        
        
        AbsenzenSheet.addAction(AbegegebenAction)
        AbsenzenSheet.addAction(AbgelofenAction)
        AbsenzenSheet.addAction(OffenAction)
        AbsenzenSheet.addAction(deleteaction)
        AbsenzenSheet.addAction(cancelAction)
        
        self.present(AbsenzenSheet, animated: true, completion: nil)
        
        
    }
    
    func changeAStatus(AbsenzID: String, Person: String, Neuerstatus: String){
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
    
        self.ref!.child("SchülerAbsenzen/\(Person)/\(AbsenzID)").updateChildValues(["AAbgabe": Neuerstatus])
        print(AbsenzID)
        print(Person)
        print(Neuerstatus)
        
        self.ref = FIRDatabase.database().reference()
        self.ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
            if let item1 = snapshot.value as? String{
                self.myKlasse = item1
                self.ref!.child("AbsenzenKlassen/\(self.myKlasse)/\(AbsenzID)").updateChildValues(["AAbgabe": Neuerstatus])
            }})
    
    
    }


    func domath(StundenzumAbziehen: Int, SchülerName: String, Status: String) {
       
        if Status == "Unentschuldigt"{
            theStatus = "AAbsenzenunentschuldigt"
        } else if Status == "Entschuldigt"{
            theStatus = "AAbsenzenentschuldigt"
        }  else  if Status == "offen"{
            theStatus = "AAbsenzenOffen"
        } else if Status == "ForceOffen"{
            theStatus = "AAbsenzenOffen"
        }
        
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
                
                self.ref?.child("Statistiken").child(self.myKlasse).child(SchülerName).child(self.theStatus).observeSingleEvent(of: .value, with:                    { (snapshot) in
                    
                    if let gesamtanzahl = snapshot.value as? Int {
                        
                        let newgesamtzahl = gesamtanzahl - StundenzumAbziehen
                        
                        
                        self.ref!.child("Statistiken").child(self.myKlasse).child(SchülerName).updateChildValues([self.theStatus : newgesamtzahl])
                        
                
                    }})

                
                
//            self.ref?.child("Statistiken").child(self.myKlasse).child(SchülerName).child("")
            }})
    
    }
    

    
    func doStatisticMath(Status: String, NeuerStatus: String, AnzahlStunden: Int, Schülername: String){
    
        
        if Status == "Unentschuldigt"{
        theStatus = "AAbsenzenunentschuldigt"
        } else if Status == "Entschuldigt"{
            theStatus = "AAbsenzenentschuldigt"
        }  else  if Status == "offen"{
         theStatus = "AAbsenzenOffen"
        } else if Status == "ForceOffen"{
           theStatus = "AAbsenzenOffen"
        }
        
        if NeuerStatus == "Unentschuldigt"{
            theNewStatus = "AAbsenzenunentschuldigt"
        } else if NeuerStatus == "Entschuldigt"{
            theNewStatus = "AAbsenzenentschuldigt"
        }  else  if NeuerStatus == "offen"{
            theNewStatus = "AAbsenzenOffen"
        } else if NeuerStatus == "ForceOffen"{
            theNewStatus = "AAbsenzenOffen"
        }
        
        
   
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        print("doing math 1")
        ref = FIRDatabase.database().reference()
        ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
                  print("doing math 2")
            if let meineklasse = snapshot.value as? String{
                
                print("adf")
                self.myKlasse = meineklasse
                
                self.ref?.child("Statistiken").child(self.myKlasse).child(Schülername).child(self.theStatus).observeSingleEvent(of: .value, with:                    { (snapshot) in
                    
                    if let gesamtanzahl = snapshot.value as? Int {
                        
                        let newgesamtzahl = gesamtanzahl - AnzahlStunden
                         print("doing math 4")
                        print("\(gesamtanzahl)Gesmatzahl")
                         print("\(newgesamtzahl)newgesamtzahl")
                         print("\(AnzahlStunden)AnzahlStunden")
                          print("\(self.theStatus)theStatus")
                       print("\(self.theNewStatus)theNewStatus")
                            
                            
                        self.ref!.child("Statistiken").child(self.myKlasse).child(Schülername).updateChildValues([self.theStatus : newgesamtzahl])
                       
                        
//          self.ref!.child("Statistiken").child(self.myKlasse).child(Schülername).updateChildValues([self.theNewStatus : AnzahlStunden])
                        
               
                
                self.ref?.child("Statistiken").child(self.myKlasse).child(Schülername).child(self.theNewStatus).observeSingleEvent(of: .value, with:                    { (snapshot) in
                    
                    if let gesamtanzahl = snapshot.value as? Int {
                        
                        let newgesamtzahl = gesamtanzahl + AnzahlStunden
                        print("doing math 4")
                        print("\(gesamtanzahl)Gesmatzahl")
                        print("\(newgesamtzahl)newgesamtzahl")
                        print("\(AnzahlStunden)AnzahlStunden")
                        print("\(self.theStatus)theStatus")
                        print("\(self.theNewStatus)theNewStatus")
                        

                        
                        
                        self.ref!.child("Statistiken").child(self.myKlasse).child(Schülername).updateChildValues([self.theNewStatus : newgesamtzahl])
                        
                        
                    }})
                    }})
                
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
    

    
    func Reminder(Person: String, AbsenzDate: Int, Status: String, ReminderStatus: Bool, ReminderID: String){
        
        // CHeck if AUID is already in Array if true then kein reminder vlt chenti au neues child mache sobalds serste mal downgloadet wirt AbsenzenReminder == truem denn da check hei isches scho oder ned!
        if ReminderStatus == true{
        
            print("already set Reminder for this Absenz")
        } else if ReminderStatus == false{
        
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
//            remindernotValid()
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
//            remindernotValid()
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
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
          self.ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
                
                
                if let item1 = snapshot.value as? String{
                    
                    
                    self.ref!.child("AbsenzenKlassen").child(item1).child(ReminderID).updateChildValues([
                        "AReminderStatus": true,])
                    
                }
            })}
    }
   
    func remindernotValid(){
        
        let alertController = UIAlertController(title: "Warnung!", message: "Diese Absenz ist bereits abgelaufen und sie werden keine Benachrichtigung erhalten.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(alertController, animated: true, completion: nil)
    }
    


func AbsenzBereitsEntschuldigt(){


    // Hey die Absenz wurde schon abgegeben
    let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
    
    let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
    
    let titleAttrString = NSMutableAttributedString(string: "Die Absenz wurde bereits als entschuldigt gespeichert!", attributes: titleFont)
    
    actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
    
    
    let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
        
    }
    actionSheet.addAction(cancelAction)
    
    present(actionSheet, animated: true, completion: nil)
}

func AbsenzschonOffen(){
    let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.alert)
    
    let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
    
    let titleAttrString = NSMutableAttributedString(string: "Die Absenz ist immer noch als offen gespeichert!", attributes: titleFont)
    
    actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
    
    
    let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
        
    }
    actionSheet.addAction(cancelAction)
    
   present(actionSheet, animated: true, completion: nil)


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


import UIKit
import FirebaseDatabase
import FirebaseAuth
import UserNotifications

struct AbsenzenStruct16 {
    var ADatum: Int
    var AStatus: String
    var APerson: String
    var AAbgabe : String
    var AAnzahlStunden : Int
    var AUid: String

}

class StudentAbsenzen: UITableViewController, UITabBarDelegate{
    
    
    
    // Variables
    
   // var Schüler Info vo voher
    
    var data = [Int: [AbsenzenStruct16]]() // Date: Homework Object
    var sortedData = [(Int, [AbsenzenStruct16])]()
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    
    var PersonenTitel: String?
    var Absenzdauer: String?
    var AbsenzDatumDate: String?
    var StudentName = String()
    var myklasse = String()
    var myPerson = String()
    var NewStatus = String()
    var AAStatus = String()
    var theStatus   =   String()
    var theNewStatus   =   String()
    var getdataTimer1 : Timer = Timer()
    @IBOutlet weak var Header: UINavigationItem!
    
    override func viewDidLoad() {
        
        // Set the EmptyState
        
        
        super.viewDidLoad()
        
//        UNUserNotificationCenter.current().delegate = self
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
        
        //TableViewCell Auto resizing
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsMultipleSelectionDuringEditing = true
        
        // Set the Firebase refrence
        ref = FIRDatabase.database().reference()
        
        // Listen for added and removed
    
//        removed()
        Header.title = StudentName
        
        self.getdataTimer1 = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(StudentAbsenzen.databaseListener) , userInfo: nil, repeats: true)
//             getData()
        
        
        ref!.child("SchülerAbsenzen/\(StudentName)").observe(.value, with: { (snapshot) in
        
        
        
        
        
        
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
   
        self.databaseListener()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.getdataTimer1.invalidate()
        print("timer killed")
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.getdataTimer1.invalidate()
        print("timer killed")
    }
    @IBAction func cancelNewAbsenz (_ segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveNewAbsenz (_ segue:UIStoryboardSegue) {
    }
    
   
    @objc func databaseListener() {
        
        
        
        if self.data.isEmpty == false {
            
            self.sortedData.removeAll()
            self.data.removeAll()
        }
        
        // Added listener
        // da muess mer de schüeler wert wo mer voher mit nimmt ine tueh
        
        ref!.child("SchülerAbsenzen/\(StudentName)").observe(.childAdded, with: { (snapshot) in
            
            if let fdata = snapshot.value as? NSDictionary {
                
                let adatum = fdata["ADatum"] as! Int
                
                let astatus = fdata["AStatus"] as! String
                
                let aperson = fdata["APerson"] as! String
                
                let aanzahlStunden = fdata["AAnzahlStunden"] as! Int
                
                let aabgabe = fdata["AAbgabe"] as! String
                
                let aID = snapshot.key
                
                let homeObject3 = AbsenzenStruct16(ADatum: adatum, AStatus: astatus, APerson: aperson, AAbgabe: aabgabe, AAnzahlStunden: aanzahlStunden, AUid: aID)
                
                if self.data[adatum] == nil {
                    self.data[adatum] = [homeObject3]
                }else {
                    self.data[adatum]!.append(homeObject3)
                }
            }
            
            self.sortedData = self.data.sorted(by: { $0.key < $1.key})
            self.tableView.reloadData()
        })
        
//        // Remove listener
//        ref!.child("SchülerAbsenzen/\(StudentName)").observe(.childRemoved, with: { (snapshot) in
//            
//            if let fdata = snapshot.value as? NSDictionary {
//                
//                let adatum = fdata["ADatum"] as! Int
//                let aID = snapshot.key
//                
//                let filterdArr = self.data[adatum]!.filter({$0.AUid != aID})
//                
//                if filterdArr.count > 0 {
//                    self.data[adatum] = filterdArr
//                }else {
//                    self.data.removeValue(forKey: adatum)
//                }
//            }
//            
//            self.sortedData = self.data.sorted(by: { $0.0.key < $0.1.key})
//            self.tableView.reloadData()
//            
//        })
        tableView.reloadData()
    }
    
    
    func removed(){
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myklasse = item
                self.ref!.child("SchülerAbsenzen/\(self.StudentName)").observe(.childRemoved, with: { (snapshot) in
                    
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
                    
                    self.sortedData = self.data.sorted(by: { $0.key < $1.key})
                    self.tableView.reloadData()
                    
                })}})
        
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
            if self.data.isEmpty == false {
  
        cell.textLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].APerson
        cell.detailTextLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].AStatus
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .detailButton
        cell.tintColor = UIColor(red:0.17, green:0.22, blue:0.45, alpha:1.0)
        
        if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Entschuldigt"{
            
            cell.backgroundColor = UIColor(red:0.53, green:0.80, blue:0.55, alpha:1.0)
            
        } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Unentschuldigt"{
            
            cell.backgroundColor = UIColor(red:0.99, green:0.43, blue:0.43, alpha:1.0)
            
        } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "offen"{
            
            
        } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "ForceOffen"{
            
        }
        }
        return cell

    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//
//        // Taking Sectionheader Title and putting it in a variable
//        let sectionHeaderView = tableView.headerView(forSection: indexPath.section)
//        
//        let sectionTitle = sectionHeaderView!.textLabel!.text
//        
//        // let absenzstat = self.sortedData[indexPath.section].1[indexPath.row].AStatus
//        
//        
//        
//        // Get the cell and the Persontitle from the Cell
//        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AbsenzenCell")
//        //cell.textLabel?.text = self.sortedData[indexPath.section].1[indexPath.row].APerson
//        
//        let PersonTitle = self.sortedData[indexPath.section].1[indexPath.row].APerson
//        
//        
//        
//        // Taking the SectionheaderTitle and saving it and changig it from a String to Date
//        
//        let SectiondateInString = sectionTitle
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "dd MMM yyyy"
//        let SectionDateinDate = dateformatter.date(from: (SectiondateInString)!)
//        //print(SectionDateinDate as Any)
//        
//        
//        // Addition of 14 Days to SectionDateinDate to get FutureDateinDate
//        let daysToAdd = 14
//        var dateComponent = DateComponents()
//        dateComponent.day = daysToAdd
//        
//        let futureDateinDate = Calendar.current.date(byAdding: dateComponent, to: SectionDateinDate!)
//        // print(futureDateinDate as Any)
//        
//        
//        // Putting FutureDateinDate to FutureDateInString to display it
//        let futureDateinString = dateformatter.string(from: futureDateinDate!)
//        //print(futureDateinString)
//        
//        
//        
//        
//        
//        // Creating an ActivitySheet with the Options to Delete and set an Reminder
//        
//        let AbsenzenSheet = UIAlertController(title: "", message: "\(String(describing: PersonTitle)) du musst deine Absenz vom \(String(describing: sectionTitle!)) bis am \(futureDateinString) unterschreiben lassen und abgeben.", preferredStyle: UIAlertControllerStyle.actionSheet)
//        
//        let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
//        
//        let titleAttrString = NSMutableAttributedString(string: "Absenz Information", attributes: titleFont)
//        
//        
//        
//        
//        AbsenzenSheet.view.tintColor = UIColor.black
//        AbsenzenSheet.setValue(titleAttrString, forKey: "attributedTitle")
//        
//        
//        
//        
//        
//        
//        // Cancel Action
//        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
//            print("Cancel Pressed")
//        }
//        
//                
//        // Delete Action
//        let deleteaction = UIAlertAction(title: "Löschen", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
//            
//            let user = FIRAuth.auth()?.currentUser
//            let uid = user?.uid
//            
////            let absenz = self.sortedData[indexPath.section].1[indexPath.row]
////            self.ref!.child("absenzen/\(uid!)/\(absenz.AUid)").removeValue()
// 
//            let absenz = self.sortedData[indexPath.section].1[indexPath.row]
//            let myperson = self.sortedData[indexPath.section].1[indexPath.row].APerson
//            self.ref!.child("SchülerAbsenzen/\(myperson)/\(absenz.AUid)").removeValue()
//            print("deleted pressed")
//        
//        }
//       
//        // Delete Action
//        let deleteaction2 = UIAlertAction(title: "Abgegeben", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
//            
//            let user = FIRAuth.auth()?.currentUser
//            let uid = user?.uid
//            
//            //            let absenz = self.sortedData[indexPath.section].1[indexPath.row]
//            //            self.ref!.child("absenzen/\(uid!)/\(absenz.AUid)").removeValue()
//            
//            let absenz = self.sortedData[indexPath.section].1[indexPath.row]
//            let myperson = self.sortedData[indexPath.section].1[indexPath.row].APerson
//            self.ref!.child("SchülerAbsenzen/\(myperson)/\(absenz.AUid)").updateChildValues(["AAbgabe": "abgegeben"])
//
//            self.ref = FIRDatabase.database().reference()
//            self.ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
//                if let item1 = snapshot.value as? String{
//             self.myklasse = item1
//                        self.ref!.child("AbsenzenKlassen/\(self.myklasse)/\(absenz.AUid)").updateChildValues(["AAbgabe": "abgegeben"])
//                }})
//        }
//
//        
//        
//      
//        
//        AbsenzenSheet.addAction(deleteaction)
//        
//          AbsenzenSheet.addAction(deleteaction2)
//        
//        AbsenzenSheet.addAction(cancelAction)
//        
//        self.present(AbsenzenSheet, animated: true, completion: nil)
        
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
        
        let AbsenzenSheet = UIAlertController(title: "Absenz Information", message: "\(String(describing: PersonTitle)) muss  die Absenz vom \(String(describing: sectionTitle!)) bis am \(futureDateinString) unterschreiben lassen und abgeben.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
//        let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
        
//        let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
        
        
        
        
        AbsenzenSheet.view.tintColor = UIColor.black
//        AbsenzenSheet.setValue(titleAttrString, forKey: "attributedTitle")
        
        
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
            
            
//            ref = FIRDatabase.database().reference()
            self.ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
                
                
                if let item1 = snapshot.value as? String{
   
            self.ref!.child("AbsenzenKlassen/\(item1)/\(absenz.AUid)").removeValue()
            print("deleted pressed")
                    
                } })
            
            
            
            let absenz2 = self.sortedData[indexPath.section].1[indexPath.row]
            
            self.ref!.child("SchülerAbsenzen/\(Schülername)/\(absenz2.AUid)").removeValue()
//            self.databaseListener()
            self.removed()
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
                
                let actionSheet = UIAlertController(title: "Die Absenz wurde bereits als entschuldigt gespeichert!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
//                let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
//                let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
                
//                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
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
                let actionSheet = UIAlertController(title: "Diese Absenz wurde als Unentschuldigt eingestuft, Sie könne Sie aber nun entschuldigen!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
//                let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
//                let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
                
//                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                let Action1 = UIAlertAction(title: "Entschuldigen", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
                    
                    self.changeAStatus(AbsenzID: PostUID, Person: myperson, Neuerstatus: self.NewStatus)
                    self.doStatisticMath(Status: self.AAStatus, NeuerStatus: self.NewStatus, AnzahlStunden: AnzahlStundenSchüler, Schülername: myperson)
                    self.databaseListener()
                    //                    self.tableView.reloadData()
                    
                }
                
                let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                
                actionSheet.addAction(Action1)
                
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)
                
            }
            else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "ForceOffen"{
                self.AAStatus = "ForceOffen"
                // Pop up die Absenz ist abgelofen und wurde auch als soolche gespeichert, sie können güte zeigen und sie trozdem als abgelaufen im nachihnein erklären.
                let actionSheet = UIAlertController(title: "Diese Absenz wurde als Passiv eingestuft, Sie könne Sie aber nun entschuldigen!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
//                let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
//                let titleAttrString = NSMutableAttributedString(string: "Diese Absenz wurde als Passiv eingestuft, Sie könne Sie aber nun entschuldigen!", attributes: titleFont)
                
//                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
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
                let actionSheet = UIAlertController(title: "Diese Absenz wurde als Entschuldigt eingestuft! Wollen Sie die Absenz nun nicht mehr entschuldigen?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
//                let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
//                let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
                
//                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
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
                let actionSheet = UIAlertController(title: "Diese Absenz  als Entschuldigt eingestuffen?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
//                let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
//                let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
                
//                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
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
                let actionSheet = UIAlertController(title: "Die Absenz wurde bereits als unentschuldigt gespeichert!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
//                let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
//                let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
                
//                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)
                
            } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "ForceOffen"{
                
                self.AAStatus = "ForceOffen"
                // Pop up die Absenz ist abgelofen und wurde auch als soolche gespeichert, sie können güte zeigen und sie trozdem als abgelaufen im nachihnein erklären.
                let actionSheet = UIAlertController(title: "Diese Absenz wurde als Passiv eingestuft, Sie könne Sie aber nun definitv nicht entschuldigen!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
//                let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
//                let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
                
//                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
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
                let actionSheet = UIAlertController(title: "Die Absenz wurde bereits als entschuldigt gespeichert. Sie können Sie aber auch in einem passiven Offenen Status speichern.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
//                let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
//                let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
                
//                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
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
                let actionSheet = UIAlertController(title: "Die Absenz ist momentan immer noch Offen!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
//                let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
//                let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
                
//                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
                
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                    
                }
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true, completion: nil)
                
                
                
                
            } else if self.sortedData[indexPath.section].1[indexPath.row].AAbgabe == "Unentschuldigt"{
                
                self.AAStatus = "Unentschuldigt"
                // Force making offen die absenz bleibt solange offen bis sie dis manuell ändern.
                // Hey die Absenz wurde schon abgegeben
                let actionSheet = UIAlertController(title: "Die Absenz wurde bereits als unentschuldigt gespeichert! Sie können sie manuell in einen passiven Status setzen. Sie ist weder unentschuldigt noch entschuldigt. Sie müssen sie aber wieder manuell entschuldigen/unentschuldigen!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
//                let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
                
//                let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
                
//                actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
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
//        AbsenzenSheet.addAction(deleteaction)
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
                self.myklasse = item1
                self.ref!.child("AbsenzenKlassen/\(self.myklasse)/\(AbsenzID)").updateChildValues(["AAbgabe": Neuerstatus])
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
                
                
                self.myklasse = meineklasse
                
                self.ref?.child("Statistiken").child(self.myklasse).child(SchülerName).child("AAnzahlStunden").observeSingleEvent(of: .value, with:                    { (snapshot) in
                    
                    if let gesamtanzahl = snapshot.value as? Int {
                        
                        let newgesamtzahl = gesamtanzahl - StundenzumAbziehen
                        
                        
                        self.ref!.child("Statistiken").child(self.myklasse).child(SchülerName).updateChildValues(["AAnzahlStunden" : newgesamtzahl])
                        
                        
                    }})
                
                self.ref?.child("Statistiken").child(self.myklasse).child(SchülerName).child(self.theStatus).observeSingleEvent(of: .value, with:                    { (snapshot) in
                    
                    if let gesamtanzahl = snapshot.value as? Int {
                        
                        let newgesamtzahl = gesamtanzahl - StundenzumAbziehen
                        
                        
                        self.ref!.child("Statistiken").child(self.myklasse).child(SchülerName).updateChildValues([self.theStatus : newgesamtzahl])
                        
                        
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
                self.myklasse = meineklasse
                
                self.ref?.child("Statistiken").child(self.myklasse).child(Schülername).child(self.theStatus).observeSingleEvent(of: .value, with:                    { (snapshot) in
                    
                    if let gesamtanzahl = snapshot.value as? Int {
                        
                        let newgesamtzahl = gesamtanzahl - AnzahlStunden
                        print("doing math 4")
                        print("\(gesamtanzahl)Gesmatzahl")
                        print("\(newgesamtzahl)newgesamtzahl")
                        print("\(AnzahlStunden)AnzahlStunden")
                        print("\(self.theStatus)theStatus")
                        print("\(self.theNewStatus)theNewStatus")
                        
                        
                        self.ref!.child("Statistiken").child(self.myklasse).child(Schülername).updateChildValues([self.theStatus : newgesamtzahl])
                        
                        
                        //          self.ref!.child("Statistiken").child(self.myKlasse).child(Schülername).updateChildValues([self.theNewStatus : AnzahlStunden])
                        
                        
                        
                        self.ref?.child("Statistiken").child(self.myklasse).child(Schülername).child(self.theNewStatus).observeSingleEvent(of: .value, with:                    { (snapshot) in
                            
                            if let gesamtanzahl = snapshot.value as? Int {
                                
                                let newgesamtzahl = gesamtanzahl + AnzahlStunden
                                print("doing math 4")
                                print("\(gesamtanzahl)Gesmatzahl")
                                print("\(newgesamtzahl)newgesamtzahl")
                                print("\(AnzahlStunden)AnzahlStunden")
                                print("\(self.theStatus)theStatus")
                                print("\(self.theNewStatus)theNewStatus")
                                
                                
                                
                                
                                self.ref!.child("Statistiken").child(self.myklasse).child(Schülername).updateChildValues([self.theNewStatus : newgesamtzahl])
                                
                                
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
    
    
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        if recognizer.state == .recognized {
            self.performSegue(withIdentifier: "backfromStudentAbsenzSegue", sender: self)
            
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "ReminderEinrichten"){
//            
//            let DestViewController = segue.destination as! NewReminderNC
//            let targetController = DestViewController.topViewController as! NewReminder
//            
//            //let targetController = segue.destination as! NewReminder
//            targetController.Person = PersonenTitel
//            targetController.DauerderAbsenz = Absenzdauer
//            targetController.Datum = AbsenzDatumDate
//            
//            
//        }
    }
    
    
    
    
    
}


//Vlt falss älter als 1 Jahr


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

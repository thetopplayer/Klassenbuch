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
import MessageUI


struct AbsenzenStatistiken{
    
    var APerson: String
    var AAnzahlStunden: Int
    var AAbsenzenOffen: Int
    var AAbsenzenentschuldigt: Int
    var AAbsenzenunentschuldigt: Int
    var AUid: String
    
}

class LehrerStatistiken: UITableViewController, MFMailComposeViewControllerDelegate {
    
    // Variables
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    var data = [AbsenzenStatistiken]()
    var filtereddata = [AbsenzenStatistiken]()
    var myclass = String()
    var classmembers = [String]()
    var getdataTimer1 : Timer = Timer()
    
    var selectedPerson = String()
    var selectedOffen = String()
    var selectedEnt = String()
    var selectedUnent = String()
    var selectedGesamt = String()
    var uniqueclassmembers = [String]()
 
    // Outlets
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //self.navigationController.presentViewController(e, animated: true, completion: nil)
      
   }
    override func viewDidAppear(_ animated: Bool) {
       
        self.ref = FIRDatabase.database().reference()
        
        self.ref?.child("KlassenMitglieder/N6aHS 17-18").observe(.value, with: { (snapshot2) in
            
            let count = snapshot2.childrenCount
            print(count, "this is the count")
             self.concurrentQueues(count: Int(count))
        })
        
       
    }
    
    
    func concurrentQueues(count: Int){
//        let anotherQueue = DispatchQueue(label: "asdasd", qos: .utility)
        
        var index1 = 0

//        anotherQueue.async {
        
            print("hit")
     
            repeat{
            
            self.ref?.child("KlassenMitglieder/N6aHS 17-18").observe(.childAdded, with: { (snapshot2) in
                
                
                if let item2 = snapshot2.value as? String{
                    self.classmembers.append(item2)
                    
                    
                    //print("This are all the Classmembers\(self.classmembers)")

                    
                }
            })
            index1 += 1
                
                if index1 == count{
                    
                    self.getData()
                    print("CALLLLLED")
                }

            } while (index1 < count)
        
//        }
        
    
        
    
    }

    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    override func viewWillAppear(_ animated: Bool){
        // Check hey werdet statistike überhaupt gfüehrtet? Has Child test süscht empty State
        // Set the Firebase refrence
        
        
        

        
        
        self.dismissKeyboard()
        //        self.getdataTimer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(LehrerStatistiken.getData) , userInfo: nil, repeats: true)
        //     getData()
         }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
         self.getdataTimer1.invalidate()
        print("timer killed")
    }
    override func viewDidDisappear(_ animated: Bool) {
         self.getdataTimer1.invalidate()
            print("timer killed")
    }
    
    func getData(){
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        
        if self.data.isEmpty == false {
            
            self.data.removeAll()
        
        }
            //                        self.data.removeAll()
        
        
        
        
        print("timer still going")
                ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                    print("adfasdfasf")
                    if let item = snapshot.value as? String{
                        self.myclass = item
                        print(self.myclass)
        
//        self.classmembers = ["jerome hadorn", "larina caspar"]
        var index = 0
//        var newindex = 0
        
        
            self.uniqueclassmembers = self.uniq(source: self.classmembers)
                        
                        
              print(self.uniqueclassmembers)
                        
                        
                        
                        repeat{
            
//            self.ref?.child("KlassenMitglieder/\(self.myclass)").observe(.value, with: { (snapshot2) in
//                
//                
//                if let item2 = snapshot2.value as? String{
//                    self.classmembers.append(item2)
//                    
//                    
//                    print("This are all the Classmembers 2.0\(self.classmembers)")
//                    //.append(item2)
////                    self.tableView.reloadData()
////                    self.SchülerAnzahlLabel.text = "\(self.Classmembers.count) Schüler"
//                    
//                }
//            })
            
            
            
            
            self.ref!.child("Statistiken/\(self.myclass)/\(self.uniqueclassmembers[index])").observe(.value, with: { (snapshot) in
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
                   
            
                    
//                    let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                    
                    self.filtereddata = self.data.filter{$0.APerson == "\(aperson)"}
                    print(self.filtereddata)
//                   let i = self. (where: {$0 == ("a") })//APerson classmembers.index(where: {$0 == (aperson) })
//                    var i = self.data.index(where: {_ in homeobject.APerson = "asd"})
                    
                    print("\(self.filtereddata)this is the filtered data")
                         print("\(self.data)this is the  data")
                    
                    
                    
                    
//                    var i = self.data.index(where: self.data.filter{$0.APerson == "adasd"})
//
//                    var i = self.data.index(of: filtereddata)
           
                    self.data.append(homeobject)
                    
                    print(aperson)
                    print(aanzahlStunden)
                    
                    
                }
                
                self.tableView.reloadData()
                
            })
            //            }})
            
            index += 1
        } while (index < self.uniqueclassmembers.count)
        
        
        
        

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPerson = self.data[indexPath.row].APerson
        selectedEnt = String(self.data[indexPath.row].AAbsenzenentschuldigt)
        selectedUnent = String(self.data[indexPath.row].AAbsenzenunentschuldigt)
        selectedGesamt = String(self.data[indexPath.row].AAnzahlStunden)
        selectedOffen = String(self.data[indexPath.row].AAbsenzenOffen)
        
        self.performSegue(withIdentifier: "changeStatistics", sender: nil)
        
    }
    
    @IBAction func Print(_ sender: Any) {
    
      
        
   generateCVSFile()
}
    
    func generateCVSFile(){
        //        generatePDF()
        print(uniqueclassmembers, "this are the unique classmembers")
        print(data, "all the data")
        
        let fileName = "AbsenzenStatistik.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        let pathPDF = "\(NSTemporaryDirectory())\(fileName)"

        
        var csvText = "Absenzen\n\nSchülerIn,Entschuldigt,Unentschuldigt,Offen,Geamt\n"
        
       // currentCar.fillups.sortInPlace({ $0.date.compare($1.date) == .OrderedDescending })
        
        let count = data.count
        
        if count > 0 {
            
            for xx in data {
                
         
                
                let newLine = "\(xx.APerson),\(xx.AAbsenzenentschuldigt),\(xx.AAbsenzenunentschuldigt),\(xx.AAbsenzenOffen),\(xx.AAnzahlStunden)\n"
                print(newLine)
                csvText.append(newLine)
            }
            
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                
             //   if MFMailComposeViewController.canSendMail() {
              //      let emailController = MFMailComposeViewController()
                //    emailController.mailComposeDelegate = self
                  //  emailController.setToRecipients([])
                 //   emailController.setSubject("Absenzen Statistiken export")
                  //  emailController.setMessageBody("Hi,\n\nThe .csv data export is attached\n\n\nSent from the MPG app: http://www.justindoan.com/mpg-fuel-tracker", isHTML: false)
              //  }
                 //   emailController.addAttachmentData(Data(contentsOf: path!) , mimeType: "text/csv", fileName: "Absenzen Statistik.csv")
                                     let mailComposeViewController = self.configuredMailComposeViewController()
                        
                        if MFMailComposeViewController.canSendMail() {
                            if let fileData = NSData(contentsOfFile: pathPDF)
                            {
                                print("File data loaded.")
                                
                                mailComposeViewController.addAttachmentData(fileData as Data, mimeType: "text/csv", fileName: "AbsenzenStatistik.csv")
                            }
                            
                            self.present(mailComposeViewController, animated: true, completion: nil)
                            
                        } else {
                            self.showSendMailErrorAlert()
                        }
  
                    
                
                
          

                   // present(emailController, animated: true, completion: nil)
                
                
            } catch {
                
                print("Failed to create file")
                print("\(error)")
            }
            
        } else {
           // showErrorAlert("Error", msg: "There is no data to export")
        }
    
    }
    

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }

    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        //mailComposerVC.setToRecipients(["klassenbuchteam@gmail.com"])
        mailComposerVC.setSubject("Absenzen Statistiken")
        mailComposerVC.setMessageBody("Absenzen Statistiken!", isHTML: false)
        
        return mailComposerVC
    }
   
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }
   
    
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlert = UIAlertController(title: "Die Email konnte nicht gesendet werden", message: "Aus unerklärlichen Gründen konnte die Email nicht gesendet werden. Überprüfe deine Email Einstellungen und versuche es nochmals.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        sendMailErrorAlert.addAction(defaultAction)
        
        self.present(sendMailErrorAlert, animated: true, completion: nil)
        
        
    }

    @IBAction func DetailStatisik (_ segue:UIStoryboardSegue) {
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatistikenCell
        
        // Configure the cell with tag 1,2,3
        if self.data.isEmpty == false {
            
            cell.NameLabel?.text = String(self.data[indexPath.row].APerson)
            cell.EntschuldigtLabel?.text = String(self.data[indexPath.row].AAbsenzenentschuldigt)
            cell.UnentschuldigtLabel?.text = String(self.data[indexPath.row].AAbsenzenunentschuldigt)
            cell.GesamtLabel?.text = String(self.data[indexPath.row].AAnzahlStunden)
            cell.OffenLabel?.text = String(self.data[indexPath.row].AAbsenzenOffen)
            
        }
        
       
        
        return cell
    }
    
//   override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////
////    let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! CustomHeaderCell
////        headerCell.backgroundColor = UIColor.cyan
////
////        switch (section) {
////        case 0:
////             headerCell.Label.text = "Semester 3000"
////        //return sectionHeaderView
////        case 1:
////              headerCell.Label.text = "Semester 4000"
////        //return sectionHeaderView
////        case 2:
////             headerCell.Label.text = "Semester 5000"
////        //return sectionHeaderView
////        default:
////              headerCell.Label.text = "Semester 2000"
////        }
////
////        return headerCell
//    }
    
//    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
//        
//        footerView.backgroundColor = UIColor.blackColor()
//        
//        return footerView
//    }
    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 40.0
//    }
//
    
    
    
    
    
    @IBAction func NewSemester(_ sender: Any) {
    
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        let actionSheet = UIAlertController(title: "Achtung!", message: "Ist das Semester zu Ende können sie Hier ihre alten Daten löschen. Bitte exportieren sie ihre alten Daten in ein PDF Dokument, da beim Neustart alle alten Daten gelöscht werden.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
//        let titleFont = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
        
//        let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
        
        
//        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
        
        
        
        
        let logoutAction = UIAlertAction(title: "Neues Semester starten", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
           
            // Statistiken löschen
            self.ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                print("adfasdfasf")
             
                
                
               self.generateCVSFile()
                
                
                
                
                
                if let item = snapshot.value as? String{

            
                self.ref?.child("Statistiken").child(item).removeValue()
                    

                self.ref?.child("AbsenzenKlassen").child(item).removeValue()
                
                
                self.getData()
                
                }})
        }
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        actionSheet.addAction(logoutAction)
        
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "changeStatistics"{
            let DestViewController = segue.destination as! ChangeStatisticsManually
            
            DestViewController.Name = selectedPerson
            DestViewController.Unentschudigt = selectedUnent
            DestViewController.Gesamt = selectedGesamt
            DestViewController.Offen = selectedOffen
            DestViewController.Entschudigt = selectedEnt

        }
    }
    

    
   override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
}

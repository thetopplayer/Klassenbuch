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
    var filtereddata = [AbsenzenStatistiken]()
    var myclass = String()
    var classmembers = [String]()
    var getdataTimer1 : Timer = Timer()
    
    var selectedPerson = String()
    var selectedOffen = String()
    var selectedEnt = String()
    var selectedUnent = String()
    var selectedGesamt = String()
 
    // Outlets
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check hey werdet statistike überhaupt gfüehrtet? Has Child test süscht empty State
        // Set the Firebase refrence
        
        
        ref = FIRDatabase.database().reference()
        self.dismissKeyboard()
//        self.getdataTimer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(LehrerStatistiken.getData) , userInfo: nil, repeats: true)
//     getData()
    }
    

    override func viewWillAppear(_ animated: Bool){
   
        
        DispatchQueue.main.async {
            
       

            self.getData()}
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
        
        self.classmembers = ["jerome hadorn", "larina caspar"]
        var index = 0
//        var newindex = 0
        
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
                    
                    var homeobject = AbsenzenStatistiken(APerson: aperson, AAnzahlStunden: aanzahlStunden, AAbsenzenOffen: aabsenzenOffen, AAbsenzenentschuldigt: aabsenzenentschuldigt, AAbsenzenunentschuldigt: aabsenzenunentschuldigt, AUid: aID)
                   
            
                    
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
        } while (index < self.classmembers.count)
        
        
        
        
//        repeat{
//            
//            self.ref!.child("Statistiken/\(self.myclass)/\(self.classmembers[newindex])").observe(.childAdded, with: { (snapshot) in
//                print("afasdfkbaskf")
//     
//                
//                
//                //        // Added listener
//                //                ref!.child("Statistiken/N6aHS 17-18").observe(.value, with: { (snapshot) in
//                //                                        print("afasdfkbaskf")
//                //
//                //                    // putting all members here and then running those to get data
//                //
//                //
//                
//                if let fdata = snapshot.value as? NSDictionary {
//                    
//                    let aperson = fdata["APerson"] as! String
//                    
//                    let aanzahlStunden = fdata["AAnzahlStunden"] as! Int
//                    
//                    let aabsenzenOffen = fdata["AAbsenzenOffen"] as! Int
//                    
//                    let aabsenzenentschuldigt = fdata["AAbsenzenentschuldigt"] as! Int
//                    
//                    let aabsenzenunentschuldigt = fdata["AAbsenzenunentschuldigt"] as! Int
//                    
//                    let aID = snapshot.key
//                    
//                    let homeobject = AbsenzenStatistiken(APerson: aperson, AAnzahlStunden: aanzahlStunden, AAbsenzenOffen: aabsenzenOffen, AAbsenzenentschuldigt: aabsenzenentschuldigt, AAbsenzenunentschuldigt: aabsenzenunentschuldigt, AUid: aID)
//                    
//                    if let i = self.classmembers.index(where: {$0 == (aperson) }){
//                        
//                        let absenz = self.data[i]
//                        self.ref!.child("Statistiken/N6aHS 17-18/\(self.classmembers[newindex])/\(absenz.AUid)").removeValue()
//                    }
//                    //                    self.ref!.child("HausaufgabenKlassen/\(self.myKlasse)/\(homework.HUid)").removeValue()
//                    self.data.append(homeobject)
//                    
//                    print(aperson)
//                    print(aanzahlStunden)
//                    
//                    
//                }
//                
//                self.tableView.reloadData()
//                
//            })
//            //            }})
//            
//            newindex += 1
//        } while (newindex < self.classmembers.count)
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
        
        
      pdfDataWithTableView(tableView: tableView)
        
    }
   
    func pdfDataWithTableView(tableView: UITableView) {
        let priorBounds = tableView.bounds
        let fittedSize = tableView.sizeThatFits(CGSize(width:priorBounds.size.width, height:tableView.contentSize.height))
        tableView.bounds = CGRect(x:0, y:0, width:fittedSize.width, height:fittedSize.height)
        let pdfPageBounds = CGRect(x:0, y:0, width:tableView.frame.width, height:self.view.frame.height)
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds,nil)
        var pageOriginY: CGFloat = 0
        while pageOriginY < fittedSize.height {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            pageOriginY += pdfPageBounds.size.height
        }
        UIGraphicsEndPDFContext()
        tableView.bounds = priorBounds
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("myDocument.pdf")
        pdfData.write(to: docURL as URL, atomically: true)
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
    
   override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! CustomHeaderCell
        headerCell.backgroundColor = UIColor.cyan
        
        switch (section) {
        case 0:
             headerCell.Label.text = "Semester 3000"
        //return sectionHeaderView
        case 1:
              headerCell.Label.text = "Semester 4000"
        //return sectionHeaderView
        case 2:
             headerCell.Label.text = "Semester 5000"
        //return sectionHeaderView
        default:
              headerCell.Label.text = "Semester 2000"
        }
    
        return headerCell
    }
    
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
        
        let actionSheet = UIAlertController(title: "", message: "Ist das Semester zu Ende können sie Hier ihre alten Daten löschen. Bitte exportieren sie ihre alten Daten in ein PDF Dokument, da beim Neustart alle alten Daten gelöscht werden.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: "Achtung!", attributes: titleFont)
        
        
        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
        
        
        
        
        let logoutAction = UIAlertAction(title: "Neues Semester starten", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
           
            // Statistiken löschen
            self.ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                print("adfasdfasf")
                if let item = snapshot.value as? String{

            
            self.ref?.child("Statistiken").child(item).removeValue()
                    
            // Klasenabsenzen bewegen Tree bewegen in Archiv.
//            ref?.child("AbsenzenKlassen").child(item).
             
                   
//                 self.ref?.child("AbsenzenKlassen").child(item).observe(.value, with: { (snapshot) in
//                    if let data = snapshot.value as! [String :AnyObject]? {
//                            self.ref?.child("Archiv").child(item).setValue(data)
//                    }
//                    })
//                
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

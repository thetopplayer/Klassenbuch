
    //
    //  AddClassMembers.swift
    //  Klassenbuch
    //
    //  Created by Developing on 26.08.17.
    //  Copyright © 2017 Hadorn Developing. All rights reserved.
    //
    
    import UIKit
    import Firebase
    
    class LehrerStudentListe: UITableViewController {
        
        
        //Variables
        //Pass this Value from ClassSelection
        var myClass = String()
        var Vorname = String()
        var Nachname = String()
        var Name = String()
        var myName = String()
        var Classmembers : [String] = []
        var handle2 : FIRDatabaseHandle?
        var ref2: FIRDatabaseReference?
        
        var selectedPerson = String()
        
      
        
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            self.hideKeyboardWhenTappedAround()
            
     
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            ref2 = FIRDatabase.database().reference()
            
            ref2?.child("users").child("Lehrer").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let item = snapshot.value as? String{
                    self.myClass = item
                    
                    
                    self.ref2?.child("KlassenMitglieder/\(self.myClass)").observe(.childAdded, with: { (snapshot2) in
                        
                        
                        if let item2 = snapshot2.value as? String{
                            self.Classmembers.insert(item2, at: 0)   //.append(item2)
                            self.tableView.reloadData()
                            
                        }
                    }
                        
                        
                    )
                    print(self.Classmembers)
                    self.tableView.reloadData()
                }
            
                self.ref2?.child("KlassenMitglieder/\(self.myClass)").observe(.childRemoved, with: { (snapshot) in
                    
                    
                    if let item2 = snapshot.value as? String{
                        
                        if let i = self.Classmembers.index(where: {$0 == (item2) }) {
                            self.Classmembers.remove(at: i)
                            self.tableView.reloadData()
                        }
                        
                    }
                })

            
            
            
            }
            )
            
        }
        
//        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//        {
//            // This is where you would change section header content
//            return tableView.dequeueReusableCell(withIdentifier: "header")
//        }
//        
//        override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
//        {
//            return 44
//        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            if view.bounds.contains(touch.location(in: view)) {
                return false
            }
            return true
        }

        
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return Classmembers.count
        }
        
     override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        
        
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = Classmembers[indexPath.row]
            cell.accessoryType = .disclosureIndicator

            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            
            print("tapped")
            
       
            
            selectedPerson = self.Classmembers[indexPath.row]
            
          
            self.performSegue(withIdentifier: "StudentAbsenzen", sender: self)
            
        }
        
        @IBAction func backfromStudentAbsenz (_ segue:UIStoryboardSegue) {
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "StudentAbsenzen"{
                let DestViewController = segue.destination as! StudentAbsenzen
                
                DestViewController.StudentName = selectedPerson
                print(selectedPerson)
            }

        }
}


    //
    //  AddClassMembers.swift
    //  Klassenbuch
    //
    //  Created by Developing on 26.08.17.
    //  Copyright © 2017 Hadorn Developing. All rights reserved.
    //
    
    import UIKit
    import Firebase
    
    class KlassenMitgliederadding: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
        
        
        //Variables
        //Pass this Value from ClassSelection
        var myClass = String()//"N5aFS18"
        var Vorname = String()
        var Nachname = String()
        var Name = String()
        var myName = String()
        var Classmembers : [String] = []
//        var Classlistt = ["asdsad","asasdsadd"]
        var handle2 : FIRDatabaseHandle?
        var ref2: FIRDatabaseReference?
        var identifier = String()
//        var PersonName = String()
        //Outlets
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var ClassNameLabel: UILabel!
        @IBOutlet weak var VornameTextField: UITextField!
        @IBOutlet weak var NachnameTextField: UITextField!
        @IBOutlet weak var hinzufügenButton: UIButton!
        @IBOutlet weak var SchülerAnzahlLabel: UILabel!
        
        override func viewWillAppear(_ animated: Bool) {
            let BGimage = #imageLiteral(resourceName: "Background")
            UINavigationBar.appearance().backgroundColor = UIColor(red:0.08, green:0.17, blue:0.41, alpha:1.0)
            let backgroundImage = UIImageView(image: BGimage)
            self.tableView.backgroundView = backgroundImage
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = backgroundImage.bounds
            
            backgroundImage.addSubview(blurView)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.navigationController?.navigationBar.tintColor = UIColor.white
            
            //        view.backgroundColor = UIColor(white:0.0, alpha:0.0)
            //        view.isOpaque = false
            
            ClassNameLabel.text = myClass
//            self.hideKeyboardWhenTappedAround()
            
            hinzufügenButton.layer.cornerRadius = 5
            tableView.delegate = self
            tableView.dataSource = self
            VornameTextField.delegate = self
            NachnameTextField.delegate = self
            
            //SchülerAnzahlLabel.text = "\(Classmembers.count) Schüler"
            
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            ref2 = FIRDatabase.database().reference()
            
            ref2?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let item = snapshot.value as? String{
                    self.myClass = item
                    
                    
//                    //Check if it's really the User
//                    self.ref2 = FIRDatabase.database().reference()
//                    self.handle2 = self.ref2?.child("users").child("Schüler").child(uid!).child("name").observe(.value, with: { (snapshot) in
//                        
//                        
//                        if let item3 = snapshot.value as? String{
//                            
//                            
//                            self.myName = item3
//                            
//                            self.ref2 = FIRDatabase.database().reference()
//                            self.handle2 = self.ref2?.child("users").child("Klasseneinstellungen").child(uid!).child("Admin").observe(.value, with: { (snapshot) in
//                                
//                                
//                                if snapshot.value as? String == item3 {
//                                    
//                                    print("Yes you are an Admin")
//                                    //                            self.AdminLabel.text = "Admin"
//                                    
//                                }
//                            }
//                                
//                                
//                            )
//                        }
//                    }
//                        
//                        
//                    )
//                    
         
                    self.ref2?.child("KlassenMitglieder/\(self.myClass)").observe(.childAdded, with: { (snapshot2) in
                        
                        
                        if let item2 = snapshot2.value as? String{
                            self.Classmembers.insert(item2, at: 0)
                            //.append(item2)
                            self.tableView.reloadData()
                            self.SchülerAnzahlLabel.text = "\(self.Classmembers.count) Schüler"
                            
                        }
                    }
                        
                        
                    )
                    print(self.Classmembers)
                    self.tableView.reloadData()
                
                
                    self.ref2?.child("KlassenMitglieder/\(self.myClass)").observe(.childRemoved, with: { (snapshot) in
                        
                        
                        if let item2 = snapshot.value as? String{
                            
                            if let i = self.Classmembers.index(where: {$0 == (item2) }) {
                                self.Classmembers.remove(at: i)
                                self.tableView.reloadData()
                                self.SchülerAnzahlLabel.text = "\(self.Classmembers.count) Schüler"
                            }
                            
                        }
                    })
                
                
                }
            })
            
      
        }
        
        
        
        func checkforAdmin(){
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
          }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == VornameTextField{
                
                NachnameTextField.becomeFirstResponder()
                
            }
            return true
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // MARK: - Table view data source
        
        @IBAction func AddClassMemberAction(_ sender: Any) {
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            Name = "\(VornameTextField.text!) \(NachnameTextField.text!)"
            
            
            if VornameTextField.text != "" || NachnameTextField.text != "" {
                
                VornameTextField.becomeFirstResponder()
                
                ref2?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let item = snapshot.value as? String{
                        self.myClass = item
                        
                        // self.ref2?.child("KlassenMitglieder/\(self.myClass)").updateChildValues([self.Klasse : self.Klasse])
                        
                        
                        
                        self.ref2 = FIRDatabase.database().reference()
                        
                        
                        self.ref2?.child("KlassenMitglieder/\(self.myClass)").observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if snapshot.hasChild(self.Name.lowercased()){
                                
                                print("true member exist")
                                // Error Message
                                
                                let alertController = UIAlertController(title: "Klassenmitglied bereits hinzugefügt!", message: "Die Person die du hinzufügen wolltest ist bereits in deiner Klasse. Falls du die Person entfernen möchtest kannst du sie Löschen!", preferredStyle: .alert)
                                
                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    self.VornameTextField.text = ""
                                    self.NachnameTextField.text = ""
                                    
                                }))
                                self.present(alertController, animated: true, completion: nil)
                                
                                
                            }else{
                                
                                print("Member doesn't exist")
                                // Add user
                                self.ref2?.child("KlassenMitglieder/\(self.myClass)").updateChildValues([self.Name.lowercased() : self.Name.lowercased()])
                            }
                            
                            
                        })
                        
                        
                        
                        self.VornameTextField.text = ""
                        self.NachnameTextField.text = ""
                        
                        
                    }
                })
                
            }
            
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return Classmembers.count
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = Classmembers[indexPath.row]
            
            // Check which person of the classmembers is an admin or not
            
            cell.contentView.alpha = 0.8
            cell.accessoryType = .disclosureIndicator
            
            
            return cell
        }
        
        
        
        // Override to support editing the table view.
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                
                
                
                let user = FIRAuth.auth()?.currentUser
                let uid = user?.uid
                
                
                ref2?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let item = snapshot.value as? String{
                        self.myClass = item
                        
                        
                        
                        self.ref2?.child("KlassenMitglieder/\(self.myClass)").child(self.Classmembers[indexPath.row]).removeValue()
                        
                        
                    }
                })
                
                // tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
         func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            if tableView.bounds.contains(touch.location(in: tableView)) {
                return false
            }
            return true
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            
            let PersonName = Classmembers[indexPath.row]
            

            let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: "Willst du \(PersonName) auch zum Admin machen? Du kannst diese Entscheidungn nicht wieder rückgängig machen", attributes: titleFont)
            
            actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
            
            let Action1 = UIAlertAction(title: "Zum Co-Admin machen", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
               
                
                self.ref2 = FIRDatabase.database().reference()
                self.handle2 = self.ref2?.child("users").child("Schüler").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
                    
                    
                    if let MeineKlasse = snapshot.value as? String{
                        
                        
                        self.myClass = MeineKlasse
                        

                self.ref2?.child("users").child("KlassenEinstellungen").child(self.myClass).child("Admin").updateChildValues(["\(PersonName)": PersonName])
                    }})
            }
            
            let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                
            }
            
            actionSheet.addAction(Action1)
            
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)

            }
      
        
        // Save Button Enabled
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            if (VornameTextField.text?.isEmpty)! || (NachnameTextField.text?.isEmpty)! || (VornameTextField.text == " ") || (NachnameTextField.text == " "){
                hinzufügenButton.isEnabled = false
            } else {
                hinzufügenButton.isEnabled = true
            }
        }
        
}

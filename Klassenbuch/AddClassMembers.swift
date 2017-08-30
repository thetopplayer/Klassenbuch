//
//  AddClassMembers.swift
//  Klassenbuch
//
//  Created by Developing on 26.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class AddClassMembers: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    //Variables
    //Pass this Value from ClassSelection
    var myClass = String()//"N5aFS18"
    var Vorname = String()
    var Nachname = String()
    var Name = String()
    var myName = String()
    var Classmembers : [String] = []
    var Classlistt = ["asdsad","asasdsadd"]
    var handle2 : FIRDatabaseHandle?
    var ref2: FIRDatabaseReference?
    
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
        
//        view.backgroundColor = UIColor(white:0.0, alpha:0.0)
//        view.isOpaque = false
        
        ClassNameLabel.text = myClass
        self.hideKeyboardWhenTappedAround()
        
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
            }
        })
        
        handle2 = ref2?.child("KlassenMitglieder/\(self.myClass)").observe(.childRemoved, with: { (snapshot) in
            
            
            if let item2 = snapshot.value as? String{
          
                if let i = self.Classmembers.index(where: {$0 == (item2) }) {
                    self.Classmembers.remove(at: i)
                    self.tableView.reloadData()
                       self.SchülerAnzahlLabel.text = "\(self.Classmembers.count) Schüler"
                }
                
            }
        })
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
        cell.contentView.alpha = 0.8
        

        return cell
    }
   

    @IBAction func FinishSetup(_ sender: Any) {
        
        // Nach Double Check mit jeweiligen Informationen
        self.performSegue(withIdentifier: "FinishSetup", sender: nil)
        
        
        
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
    
    @IBAction func CancelClassSetup(_ sender: Any) {
        
        //Check eb d Klass doppelt isch
        
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
       // let selectedClass = self.ClassList[indexPath.row]
        
        let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: "Wollen Sie wirklich abbrechen und diese Klasse somit Löschen?", attributes: titleFont)
        
        
        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
        
        
        
        
        let logoutAction = UIAlertAction(title: "Ja", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
            
            self.ref2?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let item = snapshot.value as? String{
                    
                    self.myClass = item
                    
                    UserDefaults.standard.set(false, forKey: "StudenthasClass")
                    UserDefaults.standard.synchronize()
                    // Delete in KlassenListe NED FERtIG!
                self.ref2?.child("users/Klassen").child(self.myClass).removeValue()                  // Delete in KlassenmitgliederListe
                    self.ref2?.child("KlassenMitglieder").child(self.myClass).removeValue()
                    // Delete User Data
                    self.ref2?.child("users").child("Schüler").child(uid!).child("Klasse").removeValue()
                    
                    self.ref2?.child("KlassenMitglieder/\(self.myClass)").removeValue()
                }
            })

            
            //  undwind to Klasseliste
            self.performSegue(withIdentifier: "CancelClassCreation", sender: self)
 
            
        }
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        actionSheet.addAction(logoutAction)
        
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

//
//  Add Hausaufgaben.swift
//  Klassenbuch
//
//  Created by Developing on 19.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class Add_Hausaufgaben: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    //Outlets
    
    @IBOutlet weak var HausaufgabenTextField: UITextField!
    @IBOutlet weak var SchulfachTextField: UITextField!
    @IBOutlet weak var DatumTextField: UITextField!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var PrivatSwitch: UISwitch!
    @IBOutlet weak var PrivatKlassenLabel: UILabel!
    
    // Variables
    var Label = UILabel()
    var HWSubjectpicker = UIPickerView()
    var ref:FIRDatabaseReference?
    var selectedDateZeroHour: Int?
    let todaysDate = Date()
    
    var myName = String()
    var myKlasse : String?
    var myEmail = String()
    
    var ClassList : [String] = []
    
    var neueKlasse = String()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
       // myKlasse =
        // Setting up TextFielddelegates and Pickerdelegates
        
        HWSubjectpicker.delegate = self
        HWSubjectpicker.dataSource = self
        DatumTextField.delegate = self
        SchulfachTextField.delegate = self
        HausaufgabenTextField.delegate = self
        SchulfachTextField.inputView = HWSubjectpicker
        
        //self.Savebuttonfont()
        self.hideKeyboardWhenTappedAround()
        SaveButton.isEnabled = false
        
        
        //Database Refrence Property
        ref = FIRDatabase.database().reference()
    
        // Left Swipe
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // Save Button Enabled
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (HausaufgabenTextField.text?.isEmpty)! || (SchulfachTextField.text?.isEmpty)! || (DatumTextField.text?.isEmpty)! {
            SaveButton.isEnabled = false
        } else {
            SaveButton.isEnabled = true
        }
    }
    
   // Save Button custom Font
    
    func Savebuttonfont() {
    
        SaveButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Helvetica-Bold", size: 17)!,
            NSForegroundColorAttributeName : UIColor.white],
                                          for: UIControlState.normal)

        SaveButton.isEnabled = false
    }
    
    
    // Next Button Klicked Textfield new First Responder
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == HausaufgabenTextField{
            SchulfachTextField.becomeFirstResponder()
        } else {
        }
        return true
    }
  
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

   
    // SubjectPicker
    
    var subjects = ["Bildnerisches Gestalten","Biologie","Chemie","Deutsch","Englisch","Ergänzungsfach","Französisch","Freifach","Geografie","Geschichte","Italienisch","Latein","Mathemathik","Musik","Physik","Religion","Spanisch","Sport","Wirtschaft"]
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return subjects.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SchulfachTextField.text = subjects[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjects[row]
    }

    // DatumPicker
    
    
    @IBAction func DTFBeginEditing(_ sender: UITextField) {
       
        let datepickerView = UIDatePicker()
        datepickerView.minimumDate = Date() // set minimum date of today
        datepickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datepickerView
        datepickerView.addTarget(self, action: #selector(Add_Hausaufgaben.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        DatumTextField.text = dateFormatter.string(from: sender.date)
        self.selectedDateZeroHour = sender.date.getDateFromZeroHour
    }
   
  
    //Fund for Left Swipe
    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        if recognizer.state == .recognized {
            self.performSegue(withIdentifier: "unwindtoHA", sender: self)
        }
    }
    
    
   
    //  write the data zur FirebaseRealtimed.    
    @IBAction func SaveButtonclicked(_ sender: Any) {
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        
        if PrivatSwitch.isOn == true {
        
            self.ref?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let item = snapshot.value as? String{
                    
                    self.myKlasse = item
                    
                    self.ref!.child("HausaufgabenKlassen").child(self.myKlasse!).childByAutoId().setValue([
                        "HText": self.HausaufgabenTextField.text!,
                        "HFach": self.SchulfachTextField.text!,
                        "HDatum": self.selectedDateZeroHour!
                        ])
                    
                }
            })
        
        } else if PrivatSwitch.isOn == false {
            
         
        
            self.ref?.child("users").child("Schüler").child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let item = snapshot.value as? String{
                    
                    self.myName = item
                    
                    self.ref!.child("HausaufgabenSchüler").child(self.myName).childByAutoId().setValue([
                        "HText": self.HausaufgabenTextField.text!,
                        "HFach": self.SchulfachTextField.text!,
                        "HDatum": self.selectedDateZeroHour!
                        ])
                    
                }
            })
            
            
            
        
        }
        

      
      


        self.performSegue(withIdentifier: "unwindtoHA", sender: self)
        FIRAnalytics.logEvent(withName: "Hausaufgabe gepostet", parameters: nil)
        
    }
    
    @IBAction func PrivatSwitch(_ sender: Any) {
        
        if PrivatSwitch.isOn == true{
        
        PrivatKlassenLabel.text = "Hausaufgabe ist für die Klasse"
        
        } else if PrivatSwitch.isOn == false {
        
        
        PrivatKlassenLabel.text = "Hausaufgabe ist privat"
        }
    }

    @IBAction func cancelButtonclicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
}


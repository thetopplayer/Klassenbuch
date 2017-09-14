//
//  Add Tests.swift
//  Klassenbuch
//
//  Created by Developing on 19.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class Add_Tests: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    //Outlets
    @IBOutlet weak var TestTextField: UITextField!
    @IBOutlet weak var TestSchulfachTextField: UITextField!
    @IBOutlet weak var TestDatum: UITextField!
    @IBOutlet weak var PrivatSwitch: UISwitch!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var PrivatKlassenLabel: UILabel!
    
    //Variables
    var TestSubjectPicker = UIPickerView()
    var ref:FIRDatabaseReference?
    var selectedDateZeroHour: Int?
    
    var myName = String()
    var myKlasse = String()
    var myEmail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Setting up TextFielddelegates and Pickerdelegates
        
        TestSubjectPicker.delegate = self
        TestSubjectPicker.dataSource = self
        TestTextField.delegate = self
        TestSchulfachTextField.delegate = self
        TestDatum.delegate = self
        TestSchulfachTextField.inputView = TestSubjectPicker
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
        
        if (TestTextField.text?.isEmpty)! || (TestSchulfachTextField.text?.isEmpty)! || (TestDatum.text?.isEmpty)! {
            SaveButton.isEnabled = false
        } else {
            SaveButton.isEnabled = true
        }
    }
    
    // Next Button Klicked Textfield new First Responder
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == TestTextField{
            TestSchulfachTextField.becomeFirstResponder()
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

   
    //SubjectPickerView
    
    var subjects = ["Bildnerisches Gestalten","Biologie","Chemie","Deutsch","Englisch","Französisch","Geografie","Geschichte","Italienisch","Latein","Mathemathik","Musik","Physik","Spanisch","Sport","Wirtschaft"]
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return subjects.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        TestSchulfachTextField.text = subjects[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjects[row]
    }

    
    
    // DatumPicker
    
    @IBAction func TDTextField(_ sender: UITextField) {
    
        let datepickerView = UIDatePicker()
        datepickerView.minimumDate = Date() // set minimum date of today
        
        datepickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datepickerView
        
        datepickerView.addTarget(self, action: #selector(Add_Hausaufgaben.datePickerValueChanged), for: UIControlEvents.valueChanged)
    
    }
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        TestDatum.text = dateFormatter.string(from: sender.date)
        self.selectedDateZeroHour = sender.date.getDateFromZeroHour
    }
 
    // Firebase Write Function
    
    @IBAction func Save(_ sender: Any) {
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
       
        if PrivatSwitch.isOn == true {
            
            self.ref?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let item = snapshot.value as? String{
                    
                    self.myKlasse = item
                    
                    self.ref!.child("TestsKlassen").child(self.myKlasse).childByAutoId().setValue([
                        "TText": self.TestTextField.text!,
                        "TFach": self.TestSchulfachTextField.text!,
                        "TDatum": self.selectedDateZeroHour!
                        ])
                    
                }
            })
            
        } else if PrivatSwitch.isOn == false {
            
            
            
            self.ref?.child("users").child("Schüler").child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let item = snapshot.value as? String{
                    
                    self.myName = item
                    
                    self.ref!.child("TestsSchüler").child(self.myName).childByAutoId().setValue([
                        "TText": self.TestTextField.text!,
                        "TFach": self.TestSchulfachTextField.text!,
                        "TDatum": self.selectedDateZeroHour!
                        ])
                    
                }
            })}

        
//        ref?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if let item = snapshot.value as? String{
//                self.myKlasse = item
//                
//      
//        self.ref!.child("tests/\(self.myKlasse)").childByAutoId().setValue([
//            "TText": self.TestTextField.text!,
//            "TFach": self.TestSchulfachTextField.text!,
//            "TDatum": self.selectedDateZeroHour!
//            ])      }
//        })
        
       self.performSegue(withIdentifier: "unwindtoTests", sender: self)
        FIRAnalytics.logEvent(withName: "Test gepostet", parameters: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Fund for Left Swipe
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        if recognizer.state == .recognized {
            self.performSegue(withIdentifier: "unwindtoTests", sender: self)
        }
    }
    func getInfos(){
        
        var ref:FIRDatabaseReference?
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref = FIRDatabase.database().reference()
        
        // handle = ref?.child("users").child("Schüler").child(uid!).observe(.value, with: { (snapshot) in
        
        //      self.ref?.child("users").child("Schüler").child(uid!).updateChildValues(["name": Namen])
        
        ref?.child("users").child("Schüler").child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myName = item
            }
        })
        
        ref?.child("users").child("Schüler").child(uid!).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myEmail = item
                
            }
        })
        
        
        ref?.child("users").child("Schüler").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? String{
                self.myKlasse = item
                
            }
        })
    }
    
    @IBAction func SwitchChanged(_ sender: Any) {
        
        if PrivatSwitch.isOn == true{
            
            
            PrivatKlassenLabel.text = "Test ist für die Klasse"
            
        } else if PrivatSwitch.isOn == false {
            
            
            PrivatKlassenLabel.text = "Test ist privat"
        }

    }
}

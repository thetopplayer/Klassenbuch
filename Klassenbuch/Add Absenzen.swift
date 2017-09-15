
    //
    //  LehrerNewAbsenz.swift
    //  Klassenbuch
    //
    //  Created by Developing on 25.08.17.
    //  Copyright © 2017 Hadorn Developing. All rights reserved.
    //
    
    
    import UIKit
    import FirebaseDatabase
    import FirebaseAuth
    import Firebase
    
    
    class Add_Absenzen: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
        
        
        //Outlets
        
       
        @IBOutlet weak var AbsenzenDatum: UITextField!
        @IBOutlet weak var vonStundenTextField: UITextField!
        @IBOutlet weak var bisStundenTextField: UITextField!
        @IBOutlet weak var SaveButton: UIBarButtonItem!
        @IBOutlet weak var GanzerTagSwitch: UISwitch!
        @IBOutlet weak var StundenStepperLabel: UILabel!
        @IBOutlet weak var StundenStepper: UIStepper!
        @IBOutlet weak var PersonLabel: UILabel!
        @IBOutlet weak var AbsenzenPersonLabel: UILabel!
        
        //Variables
        var Absenzstatus: String = ""
        var Beginn: String = ""
        var Ende: String = ""
        var ref:FIRDatabaseReference?
        var selectedDateZeroHour: Int?
        var StundeInt = Int()
        var Absenzenstatus2 = String()
        var AbsenzInfo = String()
        var name = String()
        var myklasse = String()
        var myklasse2 : String?
        
        
        var Classmembers : [String] = []
        //var Classlistt = ["asdsad","asasdsadd"]
        var handle2 : FIRDatabaseHandle?
        var ref2: FIRDatabaseReference?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let datepickerView = UIDatePicker()
            datepickerView.minimumDate = Date() - 31536000 //set minimum date of today
            datepickerView.datePickerMode = UIDatePickerMode.date
            
            AbsenzenDatum.inputView = datepickerView
            
            datepickerView.addTarget(self, action: #selector(Add_Hausaufgaben.datePickerValueChanged), for: UIControlEvents.valueChanged)

            
            // Setting up TextFielddelegates and Pickerdelegates
            StundeInt = 1
            
            StundenStepperLabel.text = "\(StundeInt) Lektion"
            Absenzenstatus2 = "1 Lektion"
           
            
            name = AbsenzenPersonLabel.text!
            Beginn = vonStundenTextField.text!
            Ende = bisStundenTextField.text!
            
            Absenzstatus = "Ganzer Tag"
            
            //AbsenzenPersons.delegate = self
            AbsenzenDatum.delegate = self
            vonStundenTextField.delegate = self
            bisStundenTextField.delegate = self
            
            self.hideKeyboardWhenTappedAround()
            
         
            
            SaveButton.isEnabled = false
            
            // Setting Up bisPicker
            
            let vonPickerView = UIPickerView()
            vonPickerView.delegate = self
            vonPickerView.tag = 1
            vonStundenTextField.inputView = vonPickerView
            vonStundenTextField.text = Beginn
            
            
            let bisPickerView = UIPickerView()
            bisPickerView.delegate = self
            bisPickerView.tag = 2
            bisStundenTextField.inputView = bisPickerView
            
  
            
            //Database Refrence Property
            ref = FIRDatabase.database().reference()
            
            // Left Swipe
            let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
            edgePan.edges = .left
            
            view.addGestureRecognizer(edgePan)
            
        }
        
        
        
        func getStudents(){
            
            ref2 = FIRDatabase.database().reference()
            
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            ref2 = FIRDatabase.database().reference()
            handle2 = ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observe(.value, with: { (snapshot) in
                
                
                if let item1 = snapshot.value as? String{
                    
                    
                    self.myklasse = item1
                    
                    
                    
                    self.handle2 = self.ref2?.child("KlassenMitglieder/\(self.myklasse)").observe(.childAdded, with: { (snapshot2) in
                        
                        
                        if let item2 = snapshot2.value as? String{
                            self.Classmembers.insert(item2, at: 0)   //.append(item2)
                            self.tableView.reloadData()
                            
                        }
                    })
                    print(self.Classmembers)
                    
                    
                }}
            )
            
            ref = FIRDatabase.database().reference()
           ref?.child("users").child("Schüler").child(uid!).child("name").observe(.value, with: { (snapshot) in
                
                
                if let item3 = snapshot.value as? String{
                    
                    
                    self.AbsenzenPersonLabel.text = item3
                    
                }
            }
            )
        }
        
        
        
        
        
        
        
        
        override func viewWillAppear(_ animated: Bool) {
            
            getStudents()
        }
        
        
        
        
        // Make SaveButton Appear
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            if (AbsenzenDatum.text?.isEmpty)! {
                SaveButton.isEnabled = false
            } else {
                
                if GanzerTagSwitch.isOn {
                    SaveButton.isEnabled = true
                }
                else{
                    SaveButton.isEnabled = false
                    
                    if (vonStundenTextField.text?.isEmpty)! || (bisStundenTextField.text?.isEmpty)! {
                        
                        SaveButton.isEnabled = false
                    }else{
                        
                        SaveButton.isEnabled = true
                    }
                }
            }
        }
        
        
        
  
        
        
        
        //Array to have diffrent rows for sections
        
        var rowArray = [["One Row"], ["One Row"], ["One Row","Second Row","One Row"]]
        
        
        
        // TableView Settings
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            
            return 3
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            
            return self.rowArray[section].count
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            if indexPath.section == 2 && indexPath.row == 1 && GanzerTagSwitch.isOn == true {
                return 0.0
            }
            return 44.0
        }
        
        
        // DatePicker
        
        @IBAction func ADTextField(_ sender: UITextField) {
            
            
        }
        func datePickerValueChanged(_ sender: UIDatePicker) {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            AbsenzenDatum.text = dateFormatter.string(from: sender.date)
            self.selectedDateZeroHour = sender.date.getDateFromZeroHour
            
            
            
        }
        
        
        
        // Stepper
        @IBAction func SteppingHours(_ sender: UIStepper) {
            
            StundeInt = Int(sender.value)
            
            if StundeInt < 1 || StundeInt == 1  {
                
                StundenStepperLabel.text = "\(StundeInt) Lektion"
                
            } else {
                StundenStepperLabel.text = "\(StundeInt) Lektionen"
                
            }
            Absenzenstatus2 = StundenStepperLabel.text!
        }
        
        
        
        // Switch changed
        
        @IBAction func ValueChanged(_ sender: UISwitch) {
            
            self.bisStundenTextField.text = ""
            self.vonStundenTextField.text = ""
            tableView.reloadData()
            SaveButton.isEnabled = false
            
            
            if GanzerTagSwitch.isOn {
                
                Absenzstatus = "Ganzer Tag"
                
                if  (AbsenzenDatum.text?.isEmpty)!{
                    
                    SaveButton.isEnabled = false
                    
                }else {
                    SaveButton.isEnabled = true
                }
            } else  {
                
                if (vonStundenTextField.text?.isEmpty)! || (bisStundenTextField.text?.isEmpty)! {
                    
                    SaveButton.isEnabled = false
                }else{
                    
                    SaveButton.isEnabled = true
                }
            }
        }
        
        
        
        
        
        //StundenPickerView von und bis
        
        
        
        let vonTime = ["7:55","8:50","9:50","10:50","11:50","12:45","13:45","14:45","15:45","16:45"]
        let bisTime = ["8:35","9:35","10:35","11:35","12:35","13:30","14:30","15:30","16:30","17:30"]
        
        
        
        public func numberOfComponents(in pickerView: UIPickerView) -> Int{
            return 1
        }
        
        public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
            
            if pickerView.tag == 1 {
                return vonTime.count
            }
            if pickerView.tag == 2 {
                return bisTime.count
            }
           
            
            return 0
        }
        
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
            if pickerView.tag == 1 {
                
                vonStundenTextField.text = vonTime[row]
            }
            
            if pickerView.tag == 2  {
                bisStundenTextField.text = bisTime[row]
                Absenzstatus = "\(vonStundenTextField.text!) - \(bisStundenTextField.text!)"
            }
           
            
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
            if pickerView.tag == 1 {
                
                return vonTime[row]
            }
            
            if pickerView.tag == 2 {
                
                return bisTime[row]
                
            }
            
            return nil
        }
        
        
        
        
        
        @IBAction func saveAbsenz(_ sender: Any) {
            
            
//            let user = FIRAuth.auth()?.currentUser
//            let uid = user?.uid
            
            
            name = AbsenzenPersonLabel.text!
            
            if  (AbsenzenDatum.text?.isEmpty)!
                
            {
                let alertController = UIAlertController(title: "Oops!", message: "Du hast nicht alle Angaben ausgefüllt.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                
            }else {
                AbsenzInfo = "\(Absenzstatus)  \(Absenzenstatus2)"
                
                self.ref!.child("SchülerAbsenzen").child(name).childByAutoId().setValue([ "APerson": name,"AStatus": AbsenzInfo,"ADatum": self.selectedDateZeroHour!,  "AAbgabe": "offen","AAnzahlStunden" : 0,"AReminderStatus": false])

 
                
             self.performSegue(withIdentifier: "ultimateSegue", sender: self)
                
            }
        }
        
        
        
        
        //Fund for Left Swipe
        
        @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
            
            if recognizer.state == .recognized {
                self.performSegue(withIdentifier: "ultimateSegue", sender: self)
            }
        }
        
        
}








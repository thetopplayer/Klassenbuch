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
    
    
 class LehrerNewAbsenz: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
        
        
        //Outlets
        
        @IBOutlet weak var AbsenzenPersons: UITextField!
        @IBOutlet weak var AbsenzenDatum: UITextField!
        @IBOutlet weak var vonStundenTextField: UITextField!
        @IBOutlet weak var bisStundenTextField: UITextField!
        @IBOutlet weak var SaveButton: UIBarButtonItem!
        @IBOutlet weak var GanzerTagSwitch: UISwitch!
        @IBOutlet weak var StundenStepperLabel: UILabel!
        @IBOutlet weak var StundenStepper: UIStepper!
        @IBOutlet weak var PersonLabel: UILabel!
        
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
        var newInttoUpload = Int()
    
    var Classmembers : [String] = []
    //var Classlistt = ["asdsad","asasdsadd"]
    var handle2 : FIRDatabaseHandle?
    var ref2: FIRDatabaseReference?
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Setting up TextFielddelegates and Pickerdelegates
            StundeInt = 1
            
            StundenStepperLabel.text = "\(StundeInt) Lektion"

          
            name = AbsenzenPersons.text!
            Beginn = vonStundenTextField.text!
            Ende = bisStundenTextField.text!
            
            Absenzstatus = "Ganzer Tag"
            
            AbsenzenPersons.delegate = self
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
            
            let StudentPicker = UIPickerView()
            StudentPicker.delegate = self
            StudentPicker.tag = 3
            AbsenzenPersons.inputView = StudentPicker
            
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
    }
    
            
 
        
        
        
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        getStudents()
    }
    
        
        
        
        // Make SaveButton Appear
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            if (AbsenzenPersons.text?.isEmpty)! || (AbsenzenDatum.text?.isEmpty)! {
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
        
        
        
        // Next Button Klicked Textfield new First Responder
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == AbsenzenPersons{
                AbsenzenPersons.text = name
                AbsenzenDatum.becomeFirstResponder()
            } else {
            }
            return true
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
            
            let datepickerView = UIDatePicker()
            datepickerView.minimumDate = Date() - 31536000 //set minimum date of today
            datepickerView.datePickerMode = UIDatePickerMode.date
            
            sender.inputView = datepickerView
            
            datepickerView.addTarget(self, action: #selector(Add_Hausaufgaben.datePickerValueChanged), for: UIControlEvents.valueChanged)
            
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
                
                if (AbsenzenPersons.text?.isEmpty)! || (AbsenzenDatum.text?.isEmpty)!{
                    
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
            if pickerView.tag == 3{
            return Classmembers.count
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
            if pickerView.tag == 3 {
            
            AbsenzenPersons.text = Classmembers[row]
            //AbsenzenPersons.text = name
            name = "\(AbsenzenPersons.text!)"
            print(name)
            }
            
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
            if pickerView.tag == 1 {
                
                return vonTime[row]
            }
            
            if pickerView.tag == 2 {
                
                return bisTime[row]
                
            }
            if pickerView.tag == 3{
            
            return Classmembers[row]
            }
            
            return nil
        }
        
        
        
    
        
    @IBAction func saveAbsenz(_ sender: Any) {
        
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        
        name = AbsenzenPersons.text!

                    if (AbsenzenPersons.text?.isEmpty)! || (AbsenzenDatum.text?.isEmpty)!
        
                    {
                        let alertController = UIAlertController(title: "Oops!", message: "Du hast nicht alle Angaben ausgefüllt.", preferredStyle: .alert)
        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
        
                        self.present(alertController, animated: true, completion: nil)
        
        
                    }else {
                        AbsenzInfo = "\(Absenzstatus)  \(Absenzenstatus2)"
        
                        
                        self.ref!.child("SchülerAbsenzen").child(name).childByAutoId().setValue([
                            "APerson": name,
                            "AStatus": AbsenzInfo,
                            "ADatum": self.selectedDateZeroHour!
                            ])
                        
                        // here check für welli klass klasselehrerin denn child()ihir Klass wo jetzte uid isch
                        
                        self.ref?.child("users").child("Lehrer").child(uid!).child("Klasse").observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if let item = snapshot.value as? String{
                                
                                self.myklasse2 = item
                                self.ref!.child("AbsenzenKlassen").child(self.myklasse2!).childByAutoId().setValue([
                                    "APerson": self.AbsenzenPersons.text!,
                                    "AStatus": self.AbsenzInfo,
                                    "ADatum": self.selectedDateZeroHour!,
                                    "AAnzahlStunden" : self.StundeInt])
                                
                                
                          // Hier Statistiken Upload.
                                
                                
                            // Zuerst mal Check gits überhaupt das Child. Wenn ja denn wert abelafe und denn wieder ufelade. Und
                            //    zwar de gesamt wert nur süscht denn bi de overview oder bi de Klass absenzstatus ändere.
                          
                                

                            self.ref?.child("Statistiken").child(self.myklasse2!).observeSingleEvent(of: .value, with:                    { (snapshot) in
                                 
                            if snapshot.hasChild(self.name){
                             
                            // Ja Statisitke werden geführt Wert abelade und neu ufelade
                                
                                
                                  self.ref?.child("Statistiken").child(self.myklasse2!).child(self.name).observeSingleEvent(of: .value, with:                    { (snapshot) in
                                
                                    if let item3 = snapshot.value as? Int {
                                    
                                     self.newInttoUpload = item3 + self.StundeInt
                                    
                                    self.ref!.child("Statistiken").child(self.myklasse2!).child(self.name).updateChildValues(["AAnzahlStunden" : self.newInttoUpload])
                                    
                                    }})
                                
                                
                                
                                
                            print("true, Statistiken werden bereits geführt")
                      
                            } else{
                            print("false, Statistiken werden bereits geführt")
                                 // Wert sette
                                self.ref!.child("Statistiken").child(self.myklasse2!).child(self.name).updateChildValues(["AAnzahlStunden" : self.StundeInt, "APerson": self.AbsenzenPersons.text!])
                                }
                                 
     
                            }
                        )
                            }
                        }
                        )

                   
                        self.performSegue(withIdentifier: "canceltoOverView", sender: self)
                    }
    }

    
    
        
        //Fund for Left Swipe
        
        func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
            
            if recognizer.state == .recognized {
                self.performSegue(withIdentifier: "UnwindToOverview", sender: self)
            }
        }
        
        
}








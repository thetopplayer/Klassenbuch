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
    
    // Variables
    
    var HWSubjectpicker = UIPickerView()
    var ref:FIRDatabaseReference?
    var selectedDateZeroHour: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

   
    // SubjectPicker
    
    var subjects = ["Bildnerisches Gestalten","Biologie","Chemie","Deutsch","Englisch","Französisch","Geografie","Geschichte","Italienisch","Latein","Mathemathik","Musik","Physik","Spanisch","Sport","Wirtschaft"]
    
    
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
   
  
    
    
    
    
    
    
    // Here I write the data to the Firabase
    
    @IBAction func SaveButtonclicked(_ sender: Any) {
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        self.ref!.child("homeworks").child(uid!).childByAutoId().setValue([
            "HText": HausaufgabenTextField.text!,
            "HFach": SchulfachTextField.text!,
            "HDatum": self.selectedDateZeroHour!
            ])
        
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func cancelButtonclicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


//
//  Add Hausaufgaben.swift
//  Klassenbuch
//
//  Created by Developing on 19.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit

class Add_Hausaufgaben: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    //Outlets
    
    @IBOutlet weak var HausaufgabenTextField: UITextField!
    
    @IBOutlet weak var SchulfachTextField: UITextField!
    
    @IBOutlet weak var DatumTextField: UITextField!
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    
    // Variables
    
    var HWSubjectpicker = UIPickerView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        HWSubjectpicker.delegate = self
        HWSubjectpicker.dataSource = self
        DatumTextField.delegate = self
        SchulfachTextField.delegate = self
        HausaufgabenTextField.delegate = self
        SchulfachTextField.inputView = HWSubjectpicker
        self.hideKeyboardWhenTappedAround()
        SaveButton.isEnabled = false
    
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
    
   
        
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    // SubjectPicker
    
    var subjects = ["Mathemathik","Deutsch","Spanisch","Englisch","Französisch","Biologie","Chemie","Physik","Geschichte","Geografie","Wirtschaft"]
    
    
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
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = DateFormatter.Style.medium
        
        dateformatter.timeStyle = DateFormatter.Style.none
        
        DatumTextField.text = dateformatter.string(from: sender.date)
        
    }
   
    @IBAction func SaveButtonclicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonclicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
}

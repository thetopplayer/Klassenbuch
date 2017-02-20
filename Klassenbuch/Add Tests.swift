//
//  Add Tests.swift
//  Klassenbuch
//
//  Created by Developing on 19.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit

class Add_Tests: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    //Outlets
    @IBOutlet weak var TestTextField: UITextField!
   
    @IBOutlet weak var TestSchulfachTextField: UITextField!
    
    @IBOutlet weak var TestDatum: UITextField!
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    
    //Variables
    var TestSubjectPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TestSubjectPicker.delegate = self
        TestSubjectPicker.dataSource = self
        TestTextField.delegate = self
        TestSchulfachTextField.delegate = self
        TestDatum.delegate = self
        TestSchulfachTextField.inputView = TestSubjectPicker
        self.hideKeyboardWhenTappedAround()
        SaveButton.isEnabled = false


    
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

        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    //SubjectPickerView
    
    var subjects = ["Mathemathik","Deutsch","Spanisch","Englisch","Französisch","Biologie","Chemie","Physik","Geschichte","Geografie","Wirtschaft"]
    
    
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
        
        datepickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datepickerView
        
        datepickerView.addTarget(self, action: #selector(Add_Tests.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = DateFormatter.Style.medium
        
        dateformatter.timeStyle = DateFormatter.Style.none
        
        TestDatum.text = dateformatter.string(from: sender.date)
        
    }
 
        
    
    
}

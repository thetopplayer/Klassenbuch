//
//  Add Absenzen.swift
//  Klassenbuch
//
//  Created by Developing on 19.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit

class Add_Absenzen: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
   

    //Outlets
    
    @IBOutlet weak var AbsenzenPersons: UITextField!
    
    @IBOutlet weak var AbsenzenDatum: UITextField!
    
    @IBOutlet weak var vonStundenTextField: UITextField!
    
    @IBOutlet weak var bisStundenTextField: UITextField!
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!

    var Absenzstatus: String?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        AbsenzenPersons.delegate = self
        AbsenzenDatum.delegate = self
        vonStundenTextField.delegate = self
        bisStundenTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        // print(Absenzstatus as Any)
        // Absenzstatus = "Ganzer Tag"
        
        SaveButton.isEnabled = false
        
        // Setting Up bisPicker
        
        let vonPickerView = UIPickerView()
        vonPickerView.delegate = self
        vonPickerView.tag = 1
        vonStundenTextField.inputView = vonPickerView
        
        let bisPickerView = UIPickerView()
        bisPickerView.delegate = self
        bisPickerView.tag = 2
        bisStundenTextField.inputView = bisPickerView

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

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

  
    


    //Array to have diffrent rows for sections
    
    var rowArray = [["One Row"], ["One Row"], ["One Row","Second Row"], ["One Row"]]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
       return self.rowArray[section].count
}


    // DatePicker

    @IBAction func ADTextField(_ sender: UITextField) {
  
        let datepickerView = UIDatePicker()
        
        datepickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datepickerView
        
        datepickerView.addTarget(self, action: #selector(Add_Absenzen.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = DateFormatter.Style.medium
        
        dateformatter.timeStyle = DateFormatter.Style.none
        
        AbsenzenDatum.text = dateformatter.string(from: sender.date)
        
    }

    // Switch changed

    
    @IBOutlet weak var GanzerTagSwitch: UISwitch!
    
   
    
    @IBAction func ValueChanged(_ sender: UISwitch) {
        
        self.bisStundenTextField.text = ""
        self.vonStundenTextField.text = ""
        tableView.reloadData()
        SaveButton.isEnabled = false
       
        
        if GanzerTagSwitch.isOn {
            
            if (AbsenzenPersons.text?.isEmpty)! || (AbsenzenDatum.text?.isEmpty)!{
            
            SaveButton.isEnabled = false

               Absenzstatus = "Ganzer Tag"
       
                
            }else {
            SaveButton.isEnabled = true
            }
        } else  {
            
            if (vonStundenTextField.text?.isEmpty)! || (bisStundenTextField.text?.isEmpty)! {
                
                SaveButton.isEnabled = false
            }else{
                
                
               /*
                var vonZeit: String?
                var bisZeit: String?
                vonZeit = vonStundenTextField.text!
                bisZeit = bisStundenTextField.text!
                Absenzstatus = "\(vonZeit)-\(bisZeit)"
           
                print(Absenzstatus as Any)
              */
                
                SaveButton.isEnabled = true
            }
        }

        
        
        
        
        }
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 2 && indexPath.row == 1 && GanzerTagSwitch.isOn == true {
            return 0.0
        }
    
        return 44.0
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
   
}

    
    
  



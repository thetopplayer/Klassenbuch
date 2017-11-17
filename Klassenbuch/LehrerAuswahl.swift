
    //
    //  KlassenLehrerAuswahl.swift
    //  Klassenbuch
    //
    //  Created by Developing on 30.08.17.
    //  Copyright © 2017 Hadorn Developing. All rights reserved.
    //
    
  
    
    import UIKit
    import Firebase



    
    class LehrerAuswahl: UITableViewController, UISearchBarDelegate {
        
        
        @IBOutlet var searchBar: UISearchBar!
        
        
        
        
        var teachers = [Teacher2(name: "martine vetterli"), Teacher2(name: "joachim bruder"), Teacher2(name: "klassenbuchteam@gmail.com")]
        // array sollte Downgelodet werden mit allen Lehrer Namen vlt.
        //var KlassenLehrerArray = ["martine vetterli", "Joachim bruder","Mein LehrerAccount"]
        var handle : FIRDatabaseHandle?
        var ref: FIRDatabaseReference?
        var myKlasse = String()
        var filteredData = [Teacher2]()
        var isSearching = false
        var SelectedTeacher = String()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            searchBar.delegate = self
            searchBar.returnKeyType = UIReturnKeyType.done
            filteredData = teachers
            searchBar.becomeFirstResponder()
            
        }
        
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
        
        
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            
            if isSearching {
                
                return filteredData.count
            }
            
            // #warning Incomplete implementation, return the number of rows
            return teachers.count
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            
            cell.textLabel?.numberOfLines = 0
            cell.accessoryType = .disclosureIndicator
            
            if isSearching{
                cell.textLabel?.text = self.filteredData[indexPath.row].name
                
            } else {
                cell.textLabel?.text = self.teachers[indexPath.row].name
            }
            
            return cell
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text == nil || searchBar.text == "" {
                
                isSearching = false
                view.endEditing(true)
                tableView.reloadData()
                
            } else {
                
                isSearching = true
                //            {$0.name?.range(of: searchBar.text!) != nil
                filteredData = teachers.filter({$0.name.lowercased().contains(searchBar.text!.lowercased())})            //($0.name?.range(of: searchBar.text!) != nil﻿)
                
                tableView.reloadData()
                
            }
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            
            // Lehrer uf de Tippt wird wird KlasseLehrer, nach Firebase gschribe zum einte wer de Lehrer isch zum andere au das die Klass en Lehrer besitzt. Denn gits en Segue zrug und dete setts Label updatet werde.
            
            SelectedTeacher = self.filteredData[indexPath.row].name
            
           
            let actionSheet = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let titleFont = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 20.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: "Sind Sie wirklich \(SelectedTeacher)?", attributes: titleFont)
            
            
            actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
            
            
            
            
            let logoutAction = UIAlertAction(title: "Ja", style: UIAlertActionStyle.destructive) { (alert:UIAlertAction) -> Void in
                
                
                // Check ischer Student vo de Klass???
                
                self.ref = FIRDatabase.database().reference()
                
                
                self.performSegue(withIdentifier: "backtoRegisterwithTeacher", sender: self)
                
                
                
                            }
            
            
            let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) -> Void in
                print("Cancel Pressed")
            }
            
            actionSheet.addAction(logoutAction)
            
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
            
            
            
            
            
            
        }
        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            
            if segue.identifier == "backtoRegisterwithTeacher"{
            
                let DestViewController = segue.destination as! Register

                DestViewController.LehrPerson = SelectedTeacher
                DestViewController.FromLogin = false
                DestViewController.Funktion = "Lehrer"
                
            }
        }
        
        
}

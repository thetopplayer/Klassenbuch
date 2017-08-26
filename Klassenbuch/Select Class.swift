//
//  Select Class.swift
//  Klassenbuch
//
//  Created by Developing on 25.08.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
import Firebase

class Select_Class: UITableViewController {

    
    @IBOutlet weak var BarButton: UIBarButtonItem!
  
    var ClassList : [String] = []
    var handle : FIRDatabaseHandle?
    var ref: FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
    ref = FIRDatabase.database().reference()
        handle = ref?.child("users/Klassen").observe(.childAdded, with: { (snapshot) in
   
            
            if let item = snapshot.value as? String{
            self.ClassList.append(item)
            self.tableView.reloadData()
        
            }
        }
            
            
        )}



    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ClassList.count
    }

    override func viewWillAppear(_ animated: Bool) {
        let BGimage = #imageLiteral(resourceName: "Background")
        UINavigationBar.appearance().backgroundColor = UIColor(red:0.08, green:0.17, blue:0.41, alpha:1.0)
        let backgroundImage = UIImageView(image: BGimage)
        self.tableView.backgroundView = backgroundImage
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = backgroundImage.bounds
        
        backgroundImage.addSubview(blurView)}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.textLabel?.text = ClassList[indexPath.row]
        cell.textLabel?.numberOfLines = 0
       
        
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       
    }
 
    @IBAction func cancelClassErsellen (_ segue:UIStoryboardSegue) {
    }
    
}

//
//  Hausaufgaben.swift
//  Klassenbuch
//
//  Created by Developing on 11.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit

class Hausaufgaben: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.EmptyHausaufgaben()
        self.FirstLoginOnboarding()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        
        return 0
    }

    
    // Func for EmptyState
    
    func EmptyHausaufgaben () {
    
        if tableView.visibleCells.count == 0 {
            
        tableView.backgroundView = UIImageView(image: UIImage(named: "EmptyHomework"))
         tableView.separatorStyle = .none
        
  
        } else{}
   
    }
    
    
    // UIBarButtons Functions
    
    @IBAction func cancelHausaufgaben (_ segue:UIStoryboardSegue) {
        
    }

    @IBAction func saveHausaufgaben (_ segue:UIStoryboardSegue) {
        
      
    }
    
    //Login Onboarding Setup
    func FirstLoginOnboarding() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        
        if launchedBefore  {
            
            print("Not first launch.")
            
        } else {
            //User hat die App noch nicht gebraucht und bekommt einen Walkthrough
            
            
            let alert = UIAlertController(title: "Sieh dir die App an!", message: "Du wirst nun eine Einführung für das Klassenbuch App erhalten", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                
                
                self.performSegue(withIdentifier: "LoginOnboarding", sender: self)
                
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
    }
   
    // Cancel App Onboarding
    
    @IBAction func cancelAppOnboarding (_ segue:UIStoryboardSegue) {
        
    }
}



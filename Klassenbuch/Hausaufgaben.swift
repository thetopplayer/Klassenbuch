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

}



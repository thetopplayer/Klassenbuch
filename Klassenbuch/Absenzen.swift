//
//  Absenzen.swift
//  Klassenbuch
//
//  Created by Developing on 11.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit

class Absenzen: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    self.EmptyAbsenzen()
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
    
    func EmptyAbsenzen () {
        
        if tableView.visibleCells.count == 0 {
            
            tableView.backgroundView = UIImageView(image: UIImage(named: "EmptyAbsenzen"))
            tableView.separatorStyle = .none
            
            
        } else{}
        
    }
    
    //UIBarButton Functions
    
    @IBAction func cancelAbsenzen (_ segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveAbsenzen (_ segue:UIStoryboardSegue) {
        
    }

}

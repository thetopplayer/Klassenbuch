//
//  Tests.swift
//  Klassenbuch
//
//  Created by Developing on 20.12.16.
//  Copyright © 2016 Hadorn Developing. All rights reserved.
//

import UIKit

class Tests: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.EmptyTest()
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
    
    func EmptyTest () {
        
        if tableView.visibleCells.count == 0 {
            
            tableView.backgroundView = UIImageView(image: UIImage(named: "EmptyTest"))
            tableView.separatorStyle = .none
            
            
        } else{}
        
    }
    
    // UIBarButtons Functions
    
    @IBAction func cancelTests (_ segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveTests (_ segue:UIStoryboardSegue) {
        
    }

}

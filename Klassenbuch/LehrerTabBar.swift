//
//  LehrerTabBar.swift
//  Klassenbuch
//
//  Created by Developing on 08.09.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

class LehrerTabBar: UITabBarController {

    // Variables
    var Counter = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {

        if Counter == 0{
            
            selectedIndex = 0
            Counter = 0
        
        }else if Counter == 2{
          
            selectedIndex = 2
            Counter = 0
        }
    }
}

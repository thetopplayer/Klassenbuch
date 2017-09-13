//
//  AbsenzenCellStatus.swift
//  Klassenbuch
//
//  Created by Developing on 13.09.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

class AbsenzenCellStatus: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitlelabel: UILabel!
    @IBOutlet weak var imagebell: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

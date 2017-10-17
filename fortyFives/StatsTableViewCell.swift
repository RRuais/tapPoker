//
//  StatsTableViewCell.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/16/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var handLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var table: UIImageView!
    @IBOutlet weak var chip: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
    }

  

}

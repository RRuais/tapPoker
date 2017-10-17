//
//  AchievementsTableViewCell.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/10/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var achievementLabel: UILabel!
    @IBOutlet weak var pointsWorthLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkmarkImage.layer.cornerRadius = 10
        checkmarkImage.layer.borderWidth = 3
        checkmarkImage.clipsToBounds = true
        checkmarkImage.contentMode = .scaleAspectFit
        self.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

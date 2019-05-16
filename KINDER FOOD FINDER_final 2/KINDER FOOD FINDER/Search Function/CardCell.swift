//
//  CardCell.swift
//  KINDER FOOD FINDER
//
//  Created by Boning He on 2019/03/28.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var accradLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    @IBOutlet weak var backImageView: UIImageView!
    // love shape change

    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//
//  DetailCell.swift
//  KINDER FOOD FINDER
//
//  Created by heboning on 2019/04/07.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//


import UIKit

class DetailCell: UITableViewCell {
    
    
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

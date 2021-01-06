//
//  ProteinsCustomCell.swift
//  swifty-proteins
//
//  Created by arthur on 04/01/2021.
//

import UIKit

class ProteinsCustomCell: UITableViewCell {
    
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var State: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  StationCell.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 05/12/2021.
//

import UIKit

class StationCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dieselLabel: UILabel!
    @IBOutlet weak var lpgLabel: UILabel!
    @IBOutlet weak var cngLabel: UILabel!
    @IBOutlet weak var petrolLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

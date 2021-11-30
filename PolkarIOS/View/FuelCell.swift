//
//  FuelCell.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 29/11/2021.
//

import UIKit

class FuelCell: UITableViewCell {

    @IBOutlet weak var amountTextField: UILabel!
    @IBOutlet weak var sumTextField: UILabel!
    @IBOutlet weak var averageTextField: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

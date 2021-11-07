//
//  CarCell.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 29/10/2021.
//

import UIKit

class CarCell: UITableViewCell {

    @IBOutlet weak var carCellView: UIView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carMileageLabel: UILabel!
    @IBOutlet weak var carEventView: UIView!
    @IBOutlet weak var carEventLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

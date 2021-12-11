//
//  ModelCell.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 11/12/2021.
//

import UIKit

class ModelCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  productsTableViewCell.swift
//  ConectStote POS
//
//  Created by Unique Consulting Firm on 30/12/2024.
//

import UIKit

class productsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var priceTF: UILabel!
    @IBOutlet weak var retailPrice: UILabel!
    @IBOutlet weak var dateTF: UILabel!
    @IBOutlet weak var quantiotTF: UILabel!
    @IBOutlet weak var availableQty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  customerTableViewCell.swift
//  ConectStote POS
//
//  Created by Unique Consulting Firm on 31/12/2024.
//

import UIKit

class customerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var emailTF: UILabel!
    @IBOutlet weak var phonetf: UILabel!
    @IBOutlet weak var genderTF: UILabel!
    @IBOutlet weak var addressTF: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  AllViewCell.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/29.
//

import UIKit

class AllViewCell: UITableViewCell {

    @IBOutlet weak var logoimg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

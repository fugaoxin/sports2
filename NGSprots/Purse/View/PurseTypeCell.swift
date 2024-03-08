//
//  PurseTypeCell.swift
//  NGSprots
//
//  Created by Jean on 22/12/2023.
//

import UIKit

class PurseTypeCell: UITableViewCell {

    
    @IBOutlet weak var typeIV: UIImageView!
    
    @IBOutlet weak var typeLB: UILabel!
    
    @IBOutlet weak var selectIV: UIImageView!
    
    @IBOutlet weak var promptLB: UILabel!
    
    @IBOutlet weak var selectIVWidth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

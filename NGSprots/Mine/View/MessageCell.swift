//
//  MessageCell.swift
//  NGSprots
//
//  Created by Jean on 9/1/2024.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var selectIV: UIImageView!
    
    @IBOutlet weak var bgViewLeftSpace: NSLayoutConstraint!
    
    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var timeLB: UILabel!
    
    @IBOutlet weak var detailLB: UILabel!
    
    @IBOutlet weak var redView: UIView!
    
    var edit : Bool?{
        didSet{
            self.bgViewLeftSpace.constant = edit ?? false ? 40 : 10
            self.selectIV.isHidden = !(edit ?? false)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

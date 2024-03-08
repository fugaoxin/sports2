//
//  MineCell.swift
//  NGSprots
//
//  Created by Jean on 3/1/2024.
//

import UIKit

class MineCell: UITableViewCell {
   
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var imageVTopSpace: NSLayoutConstraint!
    var type : Int?{
        didSet{
            if type == -1{
                self.bgView.layer.cornerRadius = 15
                self.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }else if type == 0{
                self.bgView.layer.cornerRadius = 15
                self.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }else if type == 1{
                self.bgView.layer.cornerRadius = 0
            }else{
                self.bgView.layer.cornerRadius = 15
                self.bgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
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

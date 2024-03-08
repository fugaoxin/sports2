//
//  RegisterActivityStepCell.swift
//  NGSprots
//
//  Created by Jean on 1/3/2024.
//

import UIKit

class RegisterActivityStepCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var detailLB: UILabel!
    
    var model : RegisterActivityTaskStepModel?{
        didSet{
            if model?.status == 2{
                self.imageV.image = UIImage(named: "stepSelect")
            }else{
                self.imageV.image = UIImage(named: "stepUnSelect")
            }
            self.detailLB.text = model?.text ?? "--"
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

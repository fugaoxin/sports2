//
//  AccumulatorViewNewTbCell.swift
//  NGSprots
//
//  Created by wen xi on 2024/2/20.
//

import UIKit

protocol AccumulatorViewNewTbCellDelegate{
    //func deleteBtn(index:Int)
}

class AccumulatorViewNewTbCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wfLabel: UILabel!
    @IBOutlet weak var peilvLabel: UILabel!
    @IBOutlet weak var bgview: UIView!
    
    var delegate:AccumulatorViewNewTbCellDelegate?
    @IBOutlet weak var bgimg: UIImageView!
    
    @IBOutlet weak var selectIV: UIImageView!
    var selectBet:Bool = false{
        didSet{
            if selectBet == true{
                selectIV.layer.borderColor = UIColor.clear.cgColor
                selectIV.image = UIImage(named: "sportScreen")
            }else{
                selectIV.image = UIImage(named: "")
                selectIV.layer.borderWidth = 1
                selectIV.layer.borderColor = UIColor.hexColor(hex: "D0D1D5").cgColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgview.layer.cornerRadius = 15
        bgview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

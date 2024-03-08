//
//  AccumulatorViewCell.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/12.
//

import UIKit

protocol AccumulatorViewCellDelegate{
    func deleteBtn(index:Int)
}

class AccumulatorViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wfLabel: UILabel!
    @IBOutlet weak var peilvLabel: UILabel!
    @IBOutlet weak var detBtn: UIButton!
    var delegate:AccumulatorViewCellDelegate?
    @IBOutlet weak var bgimg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteBtn(_ sender: UIButton) {
        delegate?.deleteBtn(index: sender.tag)
    }
    
}

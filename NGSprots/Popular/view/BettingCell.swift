//
//  BettingCell.swift
//  SportsDemo
//
//  Created by wen xi on 2023/10/18.
//

import UIKit

protocol BettingCellDelegate{
    func clickOdLabel(index: Int)
}

class BettingCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var odLabel: UILabel!
    @IBOutlet weak var suoimg: UIImageView!
    
    var delegate: BettingCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func setUI(){
        odLabel.isUserInteractionEnabled = true
        let odtap = UITapGestureRecognizer(target: self, action: #selector(clickOdLabel))
        odLabel.addGestureRecognizer(odtap)
    }
    
    @objc func clickOdLabel(){
        delegate?.clickOdLabel(index: odLabel.tag)
    }

}

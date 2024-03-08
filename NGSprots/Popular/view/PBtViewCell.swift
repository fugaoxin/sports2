//
//  PBtViewCell.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/18.
//

import UIKit

protocol PBtViewCellDelegate{
    func clickOdLabel(index: Int)
}

class PBtViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeimg: UIImageView!
    @IBOutlet weak var odLabel: UILabel!
    @IBOutlet weak var suoimg: UIImageView!
    @IBOutlet weak var bgview: UIView!
    
    var delegate: PBtViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func setUI(){
        bgview.isUserInteractionEnabled = true
        let odtap = UITapGestureRecognizer(target: self, action: #selector(clickOdLabel))
        bgview.addGestureRecognizer(odtap)
    }
    
    @objc func clickOdLabel(){
        delegate?.clickOdLabel(index: odLabel.tag)
    }

}

//
//  CouponCell.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/9.
//

import UIKit

class CouponCell: UITableViewCell {
    
    @IBOutlet weak var leftMomey: UILabel!
    @IBOutlet weak var rightMoney: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var rightBgview: UIView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var tipsImg: UIImageView!
    @IBOutlet weak var leftTips: UILabel!
    @IBOutlet weak var unitImg: UIImageView!
    
    var clickSelectBtn:((_ btn: UIButton) -> Void)?
    
    var tipsHidden: Bool? {
        didSet {
            tipsImg.isHidden = tipsHidden ?? true
            leftTips.isHidden = tipsHidden ?? true
        }
    }
    
    var unitImgHidden: Bool? {
        didSet {
            unitImg.isHidden = unitImgHidden ?? true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    private func setUI(){
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: kScreenW - 125, height: 105)
        layer.colors = [UIColor.hexColor(hex: "3E3E3E").cgColor, UIColor.hexColor(hex: "000000").cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        rightBgview.layer.insertSublayer(layer, at: 0)
        tipsImg.image = UIImage(named: "tag_Deposit")?.withTintColor(.hexColor(hex: "FF9933"))
        selectBtn.layer.cornerRadius = 11
        selectBtn.layer.borderWidth = 1.5
    }
    
    @IBAction func selBtn(_ sender: UIButton) {
        clickSelectBtn!(sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

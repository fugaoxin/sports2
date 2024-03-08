//
//  ActivityBannerCell.swift
//  NGSprots
//
//  Created by Jean on 29/2/2024.
//

import UIKit

class ActivityBannerCell: UICollectionViewCell {
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var typeLB: UILabel!
    
    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var detailLB: UILabel!
    
    @IBOutlet weak var goBtn: UIButton!
    
    var model : PromotionsItemModel?{
        didSet{
            self.titleLB.text = model?.name ?? "--"
            self.detailLB.text = Tool.StringIsEmpty(value: model?.desc) == true ? "--" : model?.desc
            self.imageV.sd_setImage(with: URL(string: model?.bgImg ?? ""),placeholderImage: UIImage(named: "promoBg"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.goBtn.layer.borderWidth = 1
        self.goBtn.layer.borderColor = UIColor.white.cgColor
        
    }

}

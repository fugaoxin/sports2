//
//  LiveCasinoCell.swift
//  NGSprots
//
//  Created by Jean on 25/1/2024.
//

import UIKit
import SDWebImage

class LiveCasinoCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var nameLB: UILabel!
    
    @IBOutlet weak var introLB: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var promtIV: UIImageView!
    
    @IBOutlet weak var onePromptLB: UILabel!
    
    @IBOutlet weak var twoPromptLB: UILabel!
    
    var model : GameListModel?{
        didSet{
//            imageV.image = UIImage(named: "gamebg1")
            imageV.sd_setImage(with: URL(string: model?.coverImgUrl ?? ""), placeholderImage: UIImage(named: "gamebg1"))
            nameLB.text = model?.name
            introLB.text = "Contains more than games"//"Contains more than \(model?.gameNum ?? "0") games"
            if model?.subType == 2{
                playBtn.isHidden = true
                promtIV.isHidden = false
            }else{
                playBtn.isHidden = false
                promtIV.isHidden = true
            }
            
            if model?.isRecommend == 2 && model?.isNew == 2{
                onePromptLB.text = "NEW"
                onePromptLB.backgroundColor = .hexColor(hex: "0CD664")
                onePromptLB.isHidden = false
                twoPromptLB.isHidden = false
            }else{
                twoPromptLB.isHidden = true
                if model?.isRecommend == 2{
                    onePromptLB.isHidden = false
                    onePromptLB.text = "HOT"
                    onePromptLB.backgroundColor = .hexColor(hex: "FF3344")
                }else if model?.isNew == 2{
                    onePromptLB.isHidden = false
                    onePromptLB.text = "NEW"
                    onePromptLB.backgroundColor = .hexColor(hex: "0CD664")
                }else{
                    onePromptLB.isHidden = true
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.onePromptLB.layer.cornerRadius = 10
        self.onePromptLB.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        self.onePromptLB.layer.masksToBounds = true
        
        self.twoPromptLB.layer.cornerRadius = 10
        self.twoPromptLB.layer.maskedCorners = [.layerMaxXMaxYCorner]
        self.twoPromptLB.layer.masksToBounds = true
    }
    
    @IBAction func playClick(_ sender: Any) {
    }
    
}

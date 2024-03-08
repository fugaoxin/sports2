//
//  LiveCasinoGameCell.swift
//  NGSprots
//
//  Created by Jean on 25/1/2024.
//

import UIKit
import SDWebImage

class LiveCasinoGameCell: UICollectionViewCell {

    @IBOutlet weak var gameIV: UIImageView!
    
    @IBOutlet weak var nameBgView: UIView!
    
    @IBOutlet weak var nameLB: UILabel!
    
    @IBOutlet weak var unOpenBgView: UIView!
    
    @IBOutlet weak var openTimeLB: UILabel!
    
    @IBOutlet weak var onePromptLB: UILabel!
    
    @IBOutlet weak var twoPromptLB: UILabel!
    @IBOutlet weak var BgLogoTopHH: NSLayoutConstraint!
    @IBOutlet weak var tipsImg: UIImageView!
    
    var model : GameDataListModel?{
        didSet{
//            gameIV.image = UIImage(named: "")
            gameIV.sd_setImage(with: URL(string: model?.imgDefault ?? ""), placeholderImage: UIImage(named: "gamebg2"))
            nameLB.text = model?.enName
            if model?.hot == 1 && model?.recommend == 1{
                onePromptLB.text = "NEW"
                onePromptLB.backgroundColor = .hexColor(hex: "0CD664")
                onePromptLB.isHidden = false
                twoPromptLB.isHidden = false
            }else{
                twoPromptLB.isHidden = true
                if model?.hot == 1{
                    onePromptLB.isHidden = false
                    onePromptLB.text = "HOT"
                    onePromptLB.backgroundColor = .hexColor(hex: "FF3344")
                }else if model?.recommend == 1{
                    onePromptLB.isHidden = false
                    onePromptLB.text = "NEW"
                    onePromptLB.backgroundColor = .hexColor(hex: "0CD664")
                }else{
                    onePromptLB.isHidden = true
                }
            }
            if model?.status == 1{
                unOpenBgView.isHidden = true
            }else{
                unOpenBgView.isHidden = false
            }
        }
    }
    
    var modelNew : GameListModel?{
        didSet{
            gameIV.sd_setImage(with: URL(string: modelNew?.coverImgUrl ?? ""), placeholderImage: UIImage(named: "gamebg2"))
            nameLB.text = "Contains more than games"
            nameLB.font = .systemFont(ofSize: 10)
            if modelNew?.isRecommend == 2 && modelNew?.isNew == 2{
                onePromptLB.text = "NEW"
                onePromptLB.backgroundColor = .hexColor(hex: "0CD664")
                onePromptLB.isHidden = false
                twoPromptLB.isHidden = false
            }else{
                twoPromptLB.isHidden = true
                if modelNew?.isRecommend == 2{
                    onePromptLB.isHidden = false
                    onePromptLB.text = "HOT"
                    onePromptLB.backgroundColor = .hexColor(hex: "FF3344")
                }else if modelNew?.isNew == 2{
                    onePromptLB.isHidden = false
                    onePromptLB.text = "NEW"
                    onePromptLB.backgroundColor = .hexColor(hex: "0CD664")
                }else{
                    onePromptLB.isHidden = true
                }
            }
            if modelNew?.isMaintaining == 2{
                unOpenBgView.isHidden = true
            }else{
                unOpenBgView.isHidden = false
            }
            if modelNew?.subType == 2{
                tipsImg.isHidden = true
            }else{
                tipsImg.isHidden = false
            }
            BgLogoTopHH.constant = 100
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layer = nameBgView.layer.sublayers?[0]
        if layer is CAGradientLayer{
            nameBgView.layer.sublayers?.remove(at: 0)
        }
        var colors : Array<CGColor> = []
        colors = [UIColor.kRgbColor(red: 0, green: 0, blue: 0, alpha: 0.02).cgColor,UIColor.kRgbColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor]
        let gradient:CAGradientLayer = CAGradientLayer.init()
        //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
        gradient.startPoint = CGPoint.init(x: 0, y: 0)
        gradient.endPoint = CGPoint.init(x: 0, y: 1)
        gradient.colors = colors
        gradient.frame = CGRect(x: 0, y: 0, width: (Int(kScreenW)-30)/2, height: 46)
        gradient.cornerRadius=10
        nameBgView.layer.insertSublayer(gradient, at: 0)
        
        self.onePromptLB.layer.cornerRadius = 10
        self.onePromptLB.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        self.onePromptLB.layer.masksToBounds = true
        
        self.twoPromptLB.layer.cornerRadius = 10
        self.twoPromptLB.layer.maskedCorners = [.layerMaxXMaxYCorner]
        self.twoPromptLB.layer.masksToBounds = true
    }
    
}

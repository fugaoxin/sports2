//
//  OtherSportViewCell.swift
//  SportsDemo
//
//  Created by wen xi on 2023/11/15.
//

import UIKit

class OtherSportViewCell: UICollectionViewCell {
    var cancelCollectLeagueMatchSuccessBlock : ((_ model : Any?)->Void)?
    var collectLeagueMatchSuccessBlock : ((_ model : hlsModel?)->Void)?
    
    @IBOutlet weak var logoimg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mtLabel: UILabel!
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var collectBtn: UIButton!
    
    @IBOutlet weak var bgView: UILabel!
    var model : hlsModel?{
        didSet{
            collectBtn.isSelected = model?.isCollect ?? false
        }
    }
    var leagueMatchItemModel : CollectLeagueMatchItemModel?{
        didSet{
            collectBtn.isSelected = leagueMatchItemModel?.isCollect ?? false
        }
    }
    var type : Int?{
        didSet{
            if type == -1{
                self.bgView.layer.cornerRadius = 10
                self.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }else if type == 0{
                self.bgView.layer.cornerRadius = 10
                self.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }else if type == 1{
                self.bgView.layer.cornerRadius = 0
            }else{
                self.bgView.layer.cornerRadius = 10
                self.bgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func shoucangBtn(_ sender: UIButton) {
        if Tool.getuserInfoModel() == nil{
            Tool.keyWindow().showTextSB("Please Login", dismissAfterDelay: 1.5)
            return
        }
        if model?.isCollect == true || leagueMatchItemModel?.isCollect == true{
            var param = CancelCollectParam()
            if model == nil{
                param.lId = leagueMatchItemModel?.lId
            }else{
                param.lId = model?.id
            }
            CollectRequest.cancelCollectLeagueMatchWithParam(param: param) {
                sender.isSelected = !sender.isSelected
                if self.model != nil{
                    self.model?.isCollect = false
                }
                if self.cancelCollectLeagueMatchSuccessBlock != nil {
                    self.cancelCollectLeagueMatchSuccessBlock!(self.leagueMatchItemModel == nil ? self.model : self.leagueMatchItemModel)
                }
            }
        }else{
            var param = CollectParam()
            if model == nil{
                param.lId = leagueMatchItemModel?.lId
                param.logoUrl = leagueMatchItemModel?.logoUrl
                param.name = leagueMatchItemModel?.name
            }else{
                param.lId = model?.id
                param.logoUrl = model?.lurl
                param.name = model?.na
            }
            param.IsVirtual = false
            CollectRequest.collectLeagueMatchWithParam(param: param) {
                sender.isSelected = !sender.isSelected
                if self.model != nil{
                    self.model?.isCollect = true
                }
                if self.collectLeagueMatchSuccessBlock != nil {
                    self.collectLeagueMatchSuccessBlock!(self.model)
                }
            }
        }
    }

}

//
//  SportsStatusHeaderView.swift
//  NGSprots
//
//  Created by Jean on 13/12/2023.
//

import UIKit

class SportsStatusHeaderView: UICollectionReusableView {
    var batchCancelCollectBlock : (()->Void)?
    
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var clearBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func clearClick(_ sender: Any) {
        if Tool.getuserInfoModel() == nil{
            Tool.keyWindow().showTextSB("Please Login", dismissAfterDelay: 1.5)
            return
        }
        UserDefaults.standard.set(true, forKey: IsNeedGetCollect)
        UserDefaults.standard.synchronize()
        if batchCancelCollectBlock != nil{
            batchCancelCollectBlock!()
        }
    }
}

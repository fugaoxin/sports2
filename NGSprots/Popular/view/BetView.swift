//
//  BetView.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/29.
//

import UIKit

protocol BetViewDelegate{
    func stakeAndPromoview(index: Int)
}

class BetView: UIView {
    
    @IBOutlet weak var stake: UIButton!
    @IBOutlet weak var promo: UIButton!
    @IBOutlet weak var stakeview: UIView!
    @IBOutlet weak var promoview: UIView!
    @IBOutlet weak var bgviewHH: NSLayoutConstraint!
    
    @IBOutlet weak var ngnmLabel: UILabel!
    @IBOutlet weak var matchnmLabel: UILabel!
    @IBOutlet weak var opodLabel: UILabel!
    
    private var skv:StakeView!
    private var prov:PromoView!
    var delegate: BetViewDelegate?
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("BetView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        skv = StakeView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 230))
        stakeview.addSubview(skv)
        
        prov = PromoView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 130))
        promoview.addSubview(prov)
    }
    
    func res(){
        skv.codetext.resignFirstResponder()
        prov.codetext.resignFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    @IBAction func clickStake(_ sender: UIButton) {
        stake.backgroundColor = .hexColor(hex: "0CD664")
        promo.backgroundColor = .hexColor(hex: "F5F6F9")
        stake.setTitleColor(.white, for: .normal)
        promo.setTitleColor(.hexColor(hex: "19263C"), for: .normal)
        stakeview.isHidden = false
        promoview.isHidden = true
        bgviewHH.constant = 430
        delegate?.stakeAndPromoview(index: 1)
        res()
    }
    
    @IBAction func clickPromo(_ sender: UIButton) {
        stake.backgroundColor = .hexColor(hex: "F5F6F9")
        promo.backgroundColor = .hexColor(hex: "0CD664")
        stake.setTitleColor(.hexColor(hex: "19263C"), for: .normal)
        promo.setTitleColor(.white, for: .normal)
        stakeview.isHidden = true
        promoview.isHidden = false
        bgviewHH.constant = 300
        delegate?.stakeAndPromoview(index: 2)
        res()
    }

}

//
//  BetslipDelectTips.swift
//  NGSprots
//
//  Created by Jack Lin on 2024/3/4.
//

import UIKit

class BetslipDelectTips: UIView {

    var close: (()->Void)?
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("BetslipDelectTips", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    @IBAction func clickBtn(_ sender: UIButton) {
        close!()
    }

}

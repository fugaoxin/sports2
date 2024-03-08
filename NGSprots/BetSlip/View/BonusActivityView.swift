//
//  BonusActivityView.swift
//  NGSprots
//
//  Created by Jack Lin on 2024/2/29.
//

import UIKit

class BonusActivityView: UIView {

    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("BonusActivityView", owner: self, options: nil)?.first as! UIView
    }()
    
    var close: (()->Void)?
    var goLearnMore: (()->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        
    }
    
    @IBAction func clickClose(_ sender: UIButton) {
        close!()
    }
    
    @IBAction func learnMore(_ sender: UIButton) {
        goLearnMore!()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

}

//
//  PromoView.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/29.
//

import UIKit

class PromoView: UIView {
    @IBOutlet weak var codetext: UITextField!
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("PromoView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        codetext.layer.borderColor = UIColor.hexColor(hex: "F5F6F9").cgColor
        codetext.layer.borderWidth = 0.5
        codetext.keyboardType = .numberPad
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    @IBAction func clickCodeList(_ sender: UIButton) {
    }
    
    @IBAction func clickStake(_ sender: UIButton) {
    }
    
    
}

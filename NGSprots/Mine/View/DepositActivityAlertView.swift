//
//  DepositActivityAlertView.swift
//  NGSprots
//
//  Created by Jean on 29/2/2024.
//

import UIKit

class DepositActivityAlertView: UIView {

    @IBOutlet weak var rateLB: UILabel!
    
    @IBOutlet weak var rateLBBottomSpace: NSLayoutConstraint!
    
    var goToDepositActivity : (()->Void)?
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("DepositActivityAlertView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    func setUpUI(){
        if kScreenW <= 380{
            self.rateLBBottomSpace.constant = 115
        }else if kScreenW > 380 && kScreenW<=400{
            self.rateLBBottomSpace.constant = 120
        }else if kScreenW > 400{
            self.rateLBBottomSpace.constant = 130
        }
        self.rateLB.font = UIFont(name: "Arial Black", size: 50)
        self.rateLB.text = "600%"
    }
    @IBAction func goToActivityClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
        if self.goToDepositActivity != nil{
            self.goToDepositActivity!()
        }
    }
    @IBAction func closeClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
    }
}

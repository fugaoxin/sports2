//
//  RegisterActivityAlertView.swift
//  NGSprots
//
//  Created by Jean on 29/2/2024.
//

import UIKit

class RegisterActivityAlertView: UIView {

    @IBOutlet weak var numberLB: UILabel!
    
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("RegisterActivityAlertView", owner: self, options: nil)?.first as! UIView
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
       
    }
    
    @IBAction func goToActivityClick(_ sender: Any) {
        
        let vc = Tool.getCurrentVc()
        vc.hidesBottomBarWhenPushed = true
        vc.navigationController?.pushViewController(RegisterActivityController(), animated: true)
        if vc.navigationController?.children.count == 2{
            vc.hidesBottomBarWhenPushed = false
        }
        Tool.keyWindow().hiddenInWindow()
    }
    
    @IBAction func closeClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
    }
}

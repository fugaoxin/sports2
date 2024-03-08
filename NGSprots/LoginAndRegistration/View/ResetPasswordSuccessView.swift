//
//  ResetPasswordSuccessView.swift
//  NGSprots
//
//  Created by Jean on 28/11/2023.
//

import UIKit

class ResetPasswordSuccessView: UIView {
    var gotoLoginBlock : (()->Void)?
    
    @IBOutlet weak var promptLB: UILabel!
    
    @IBOutlet weak var introLB: UILabel!
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("ResetPasswordSuccessView", owner: self, options: nil)?.first as! UIView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    @IBAction func closeClick(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform.identity
        },completion:  { _ in
            Tool.keyWindow().hiddenInWindow()
        })
    }
   
    @IBAction func gotoLoginClick(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform.identity
        },completion:  { _ in
            Tool.keyWindow().hiddenInWindow()
            if self.gotoLoginBlock != nil{
                self.gotoLoginBlock!()
            }
        })
    }
}

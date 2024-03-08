//
//  TipsAleartView.swift
//  NGSprots
//
//  Created by Jean on 27/12/2023.
//

import UIKit

class TipsAleartView: UIView {
  
    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var detailLB: UILabel!
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("TipsAleartView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    func updateFrame(){
        self.view.frame = self.bounds
    }
    
    @IBAction func closeClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
    }
}

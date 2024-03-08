//
//  DeleteBankCardView.swift
//  NGSprots
//
//  Created by Jean on 10/1/2024.
//

import UIKit

class DeleteBankCardView: UIView {
    var deleteBankCardBlock : ((_ bank:BankCardModel?)->Void)?
    
    @IBOutlet weak var cardNumLB: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var determineBtn: UIButton!
    
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("DeleteBankCardView", owner: self, options: nil)?.first as! UIView
    }()
    var model : BankCardModel?
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
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.hexColor(hex: "C1C4C9").cgColor
    }
    @IBAction func cancelClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
    }
    
    @IBAction func determineClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
        if self.deleteBankCardBlock != nil{
            self.deleteBankCardBlock!(self.model)
        }
    }
}

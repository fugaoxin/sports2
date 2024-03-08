//
//  WithdrawFooterView.swift
//  NGSprots
//
//  Created by Jean on 26/12/2023.
//

import UIKit

class WithdrawFooterView: UIView {
    var withDrawEnterNumberBlock : (()->Void)?
    
    @IBOutlet weak var numberLB: UILabel!
    
    @IBOutlet weak var errorLB: UILabel!
    
    @IBOutlet weak var oneNumberLB: UILabel!
    
    @IBOutlet weak var twoNumberLB: UILabel!
    
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("WithdrawFooterView", owner: self, options: nil)?.first as! UIView
    }()

    lazy var tipsAleartView : TipsAleartView = {
        let view = TipsAleartView(frame: CGRect(x: (kScreenW-310)/2, y: (kScreenH-200)/2, width: 310, height: 0))
        return view
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
    func updateFrame(){
        self.view.frame = self.bounds
    }
    @IBAction func enterNumberClick(_ sender: Any) {
        if self.withDrawEnterNumberBlock != nil{
            self.withDrawEnterNumberBlock!()
        }
    }
    
    @IBAction func questionClick(_ sender: Any) {
        let str = "Your all-time withdrawal amount must be below your total stake or 2 times your total winnings. Bets placed using deposit bonuses do not count towards your total stake, and the bonus amount does not count towards your deposit amount."
        let h = self.calculateTextHeight(text: str, fontSize: 12)
        self.tipsAleartView.frame = CGRect(x: 30, y: (kScreenH-78-h)/2, width: kScreenW-60, height: 78+h)
        self.tipsAleartView.updateFrame()
        Tool.keyWindow().showInWindow(functionView: self.tipsAleartView)
    }
    func calculateTextHeight(text: String, fontSize: CGFloat) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            NSAttributedString.Key.font: UIFont(name: "PingFangSC-Regular",size: fontSize) ?? UIFont.systemFont(ofSize: fontSize) ,
        ])
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        self.tipsAleartView.detailLB.attributedText = attributedString
        return attributedString.boundingRect(with: CGSize(width: kScreenW-97, height: .greatestFiniteMagnitude),options: .usesLineFragmentOrigin ,context: nil).height
    }
}

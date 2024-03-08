//
//  PurseFooterView.swift
//  NGSprots
//
//  Created by Jean on 22/12/2023.
//

import UIKit

class PurseFooterView: UIView,UITextViewDelegate{
    
    @IBOutlet weak var detailV: UITextView!
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("PurseFooterView", owner: self, options: nil)?.first as! UIView
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
        detailV.delegate = self
        detailV.isEditable = false
        detailV.isUserInteractionEnabled = true
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "refresh_black") 
        attachment.bounds = CGRectMake(0, 0, 12, 12);
        let attachmentString = NSAttributedString(attachment: attachment)

        let attributedString = NSMutableAttributedString(string: "click here", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),
            NSAttributedString.Key.link : "clickhere://",
            NSAttributedString.Key.foregroundColor: UIColor.hexColor(hex: "0CD664"),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor: UIColor.hexColor(hex: "0CD664")]
        )
        
        let firstString = NSMutableAttributedString(string: "1. There are no fees charged for depositing with this payment method. Once your transaction is authorised, the amount will be credited to your account immediately. \n2. If the amount deposited doesn’t show, please click on \" ")
        let lastString =  NSMutableAttributedString(string:"\" button \n3. If you can’t deposit successfully, please ")
        let otherString =  NSMutableAttributedString(string:" to send us your feedback.")
        firstString.append(attachmentString)
        firstString.append(lastString)
        firstString.append(attributedString)
        firstString.append(otherString)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        firstString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: firstString.length))
        
        detailV.linkTextAttributes = [:]
        detailV.attributedText = firstString
       
        
    }
    
    @IBAction func sureClick(_ sender: Any) {
        
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
       
        return false
    }
    
}

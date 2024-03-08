//
//  AddBankCardController.swift
//  NGSprots
//
//  Created by Jean on 26/12/2023.
//

import UIKit

class AddBankCardController: BaseViewController,UITextFieldDelegate {

    
    @IBOutlet weak var bankIV: UIImageView!
    
    @IBOutlet weak var bankTF: UITextField!
    
    @IBOutlet weak var bankTFLeftSpace: NSLayoutConstraint!
    
    @IBOutlet weak var cardNumberTF: UITextField!
    
    @IBOutlet weak var bankBgView: UIView!
    
    @IBOutlet weak var cardNumberBgView: UIView!
    
    @IBOutlet weak var cardNumberPromptLB: UILabel!
    
    @IBOutlet weak var cardNumberErrorIV: UIImageView!
    
    @IBOutlet weak var cardNumberErrorLB: UILabel!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var tipIV: UIImageView!
    @IBOutlet weak var tipLB: UILabel!
    @IBOutlet weak var tipCloseBtn: UIButton!
    
    @IBOutlet weak var oneView: UIView!
    
    @IBOutlet weak var twoView: UIView!
    
    var setPasswordModel : SetPayPassWordModel?
    
    var selectBankModel : BankModel?
    
    lazy var selectBankView : SelectBankView = {
        let view = SelectBankView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: 500))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tipView.isHidden = true
    }
    func setUpUI(){
        cardNumberTF.delegate = self
        self.bankTFLeftSpace.constant = 10
        
        self.checkBtnStatus()
        self.requestBankList()
        
        self.selectBankView.completeSelectBankBlock = {[weak self]model in
            self!.bankIV.sd_setImage(with: URL(string: model.icon ?? ""),placeholderImage: UIImage(named: "bankCardPlaceholder"))
            self!.bankTF.text = model.name
            self!.selectBankModel = model
            self!.bankTFLeftSpace.constant = 42
            UIView.animate(withDuration: 0.25, animations: {
                self!.selectBankView.transform = CGAffineTransform.identity
            },completion:  { _ in
                Tool.keyWindow().hiddenInWindow()
            })
        }
        Tool.keyWindow().initBlackView()
        Tool.keyWindow().blackBg?.tapBgblock = {[weak self] in
            Tool.keyWindow().endEditing(true)
            UIView.animate(withDuration: 0.25, animations: {
                self?.selectBankView.transform = CGAffineTransform.identity
            },completion:  { _ in
                Tool.keyWindow().hiddenInWindow()
            })
        }
    }
    
    @IBAction func selectBankClick(_ sender: Any) {
        self.view.endEditing(true)
        Tool.keyWindow().showInWindow(functionView: self.selectBankView)
        UIView.animate(withDuration: 0.5) {
            self.selectBankView.transform = CGAffineTransformMakeTranslation(0, -500)
        }
    }
    
    @IBAction func nextClick(_ sender: Any) {
        self.requestAddBankCard()
    }
    
    @IBAction func closeTipClick(_ sender: Any) {
        self.tipView.isHidden = true
    }
    func requestBankList(){
        self.showHUD(text: "Loading...")
        let param = BaseSystemParam()
        let api = wxApi.getBankList(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<[BankModel]>.deserialize(from: data)
            if(result?.code == 0){
                for i in 0..<(result?.data?.count ?? 0){
                    result?.data?[i].isSelect = false
                }
                self.selectBankView.modelArr = result?.data ?? []
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
           
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func requestAddBankCard(){
        self.showHUD(text: "Loading...")
        var param = AddBankParam()
        param.bankId = self.selectBankModel?.id
        param.accountNum = self.cardNumberTF.text
        param.accessToken = self.setPasswordModel?.accessToken
        
        let api = wxApi.addBankCard(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            self.hudHide()
            let result = RequestCallBackViewModel<[BankModel]>.deserialize(from: data)
            self.showTip()
            self.tipView.isHidden = false
            if(result?.code == 0){
                self.tipIV.image = UIImage(named:"paySelect")
                self.tipLB.text = "Added successfully"
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    for i in 0..<(self.navigationController?.viewControllers.count)! {
                        let vc = self.navigationController?.viewControllers[i]
                        if vc is PurseController{
                           _ = self.navigationController?.popToViewController(self.navigationController?.viewControllers[i] as! PurseController, animated: true)
                        break
                       }
                        if vc is BankAccountController{
                           _ = self.navigationController?.popToViewController(self.navigationController?.viewControllers[i] as! BankAccountController, animated: true)
                        break
                       }
                    }
                }
            }else{
//                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
                self.tipIV.image = UIImage(named:"cardNumberError")
                self.tipLB.text = result?.message
            }
           
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    func showTip(){
        self.tipView.removeFromSuperview()
        self.tipView.frame = CGRect(x: 10, y: kNavigationBarH+kStatusBarH+20-53, width: kScreenW-20, height: 50)
        Tool.keyWindow().addSubview(self.tipView)
        
        self.tipIV.frame = CGRect(x: 16, y: 12.5, width: 25, height: 25)
        self.tipCloseBtn.frame = CGRect(x: kScreenW-92, y: 0, width: 64, height: 50)
        self.tipLB.frame = CGRect(x: CGRectGetMaxX(self.tipIV.frame)+16, y: 0, width: kScreenW-57-77, height: 50)
        
    }
    //MARK: -UITextFieldDelegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.checkBtnStatus()
        if textField == cardNumberTF {
            self.textFieldDidEndEditing(textField)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        var result : Bool = true
        if cardNumberTF.text?.count ?? 0 < 10 || cardNumberTF.text?.count ?? 0 > 20{
           result = false
        }
        if cardNumberTF.text == ""{
           result = true
        }
        cardNumberErrorIV.isHidden = result
        cardNumberErrorLB.isHidden = result
        cardNumberPromptLB.textColor = result  ? .hexColor(hex: "101010") : .hexColor(hex: "FF3344")
        cardNumberTF.textColor = result  ? .hexColor(hex: "101010") : .hexColor(hex: "FF3344")
        if result == false{
            twoView.backgroundColor = UIColor.hexColor(hex: "FF3344")
        }else{
            twoView.backgroundColor = UIColor.hexColor(hex: "B8B8B8")
        }
        
    }
    //MARK: -监听输入改变底部按钮高亮状态
    func checkBtnStatus(){
        if bankTF.text?.count ?? 0 > 0 && cardNumberTF.text?.count ?? 0 >= 10 && cardNumberTF.text?.count ?? 0 <= 20{
            nextBtn.isEnabled = true
            nextBtn.backgroundColor = .hexColor(hex: "0CD664")
        }else{
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = .kRgbColor(red: 119, green: 234, blue: 162)
        }
    }
}

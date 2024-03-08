//
//  PurseHeaderView.swift
//  NGSprots
//
//  Created by Jean on 22/12/2023.
//

import UIKit

class PurseHeaderView: UIView,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var changeBlock : ((_ type : Int)->Void)?
    
    var selectCouponBlock : (()->Void)?
    
    var textFiledEndEditBlock : (()->Void)?
    
    var textFiledWillEditBlock : (()->Void)?
    @IBOutlet weak var balanceNumberLB: UILabel!
    
    @IBOutlet weak var mainBalanceLB: UILabel!
    
    @IBOutlet weak var bonusBalanceLB: UILabel!
    
    @IBOutlet weak var rechargeBtn: UIButton!
    
    @IBOutlet weak var withdrawBtn: UIButton!
    
    @IBOutlet weak var enterNumberTFBgView: UIView!
    
    @IBOutlet weak var numberTF: CustomTextField!
    
    @IBOutlet weak var numberBgH: NSLayoutConstraint!
    
    @IBOutlet weak var selectNumberIV: UIImageView!
    
    @IBOutlet weak var promptLB: UILabel!
    
    @IBOutlet weak var numberBgView: UIView!
    
    @IBOutlet weak var numberCollectionView: UICollectionView!
    
    @IBOutlet weak var couponBgView: UIView!
    
    @IBOutlet weak var couponNumberLB: UILabel!
    
    @IBOutlet weak var gotoSelectCouponBtn: UIButton!
    var selectNumberBtn : UIButton?
    
    var dataArr : [PayTypeItemModel]?

    
    var numberArr : [AmountQuickItemModel] = []
    
    var isAutoChangeNumber : Bool = false
    
    var isNoFastNumber : Bool?{
        didSet{
            if isNoFastNumber == true{
                for i in 0..<self.numberArr.count{
                    self.numberArr[i].isChoose = false
                }
                self.numberCollectionView.reloadData()
            }
        }
    }
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("PurseHeaderView", owner: self, options: nil)?.first as! UIView
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
        let totalW = kScreenW - 20
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: (totalW-24)/3, height: 65)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 12
        
        numberCollectionView.collectionViewLayout = layout
        numberCollectionView.delegate = self
        numberCollectionView.dataSource = self
        numberCollectionView.register(UINib(nibName: "RechargeNumberCell", bundle: nil), forCellWithReuseIdentifier: "RechargeNumberCell")
        
        self.numberTF.delegate = self
        
        
//        let view = self.numberBgView.viewWithTag(2000)
//        view!.layer.borderWidth = 1
//        view!.layer.borderColor = UIColor.hexColor(hex: "0CD664").cgColor
//        self.selectNumberIV.isHidden = false
//
//        for subview in view!.subviews{
//            if subview is UIButton{
//                self.selectNumberBtn = subview as? UIButton
//            }
//            if subview is UILabel{
//                (subview as! UILabel).textColor = .hexColor(hex: "101010")
//            }
//        }
//
        self.enterNumberTFBgView.layer.cornerRadius = 8
        self.enterNumberTFBgView.layer.borderWidth = 0.5
        self.enterNumberTFBgView.layer.borderColor = UIColor.hexColor(hex: "B8B8B8").cgColor
        self.enterNumberTFBgView.layer.masksToBounds = true
    }
    func setNumberUI(){
        self.numberArr.removeAll()
      
        for i in 0..<(self.dataArr?.count ?? 0){
            let model = self.dataArr?[i]
            if model?.isSelect == true{
                for i in 0..<(model?.amountQuick?.count ?? 0){
                    if i == 0{
                        self.dataArr?[i].amountQuick?[i].isChoose = true
                        if self.isAutoChangeNumber == true{
                            self.numberTF.text = model?.amountQuick?[i].value
                        }
                    }else{
                        self.dataArr?[i].amountQuick?[i].isChoose = false
                    }
                    self.numberArr.append(self.dataArr?[i].amountQuick?[i] ?? AmountQuickItemModel())
                }
            }
        }
        if isNoFastNumber == true{
            for i in 0..<self.numberArr.count{
                self.numberArr[i].isChoose = false
            }
            self.numberCollectionView.reloadData()
        }
        self.numberCollectionView.reloadData()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    func setUpFrame(){
        self.view.frame = self.bounds
    }
    
    @IBAction func typeClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        btn.backgroundColor = UIColor.hexColor(hex: "0CD664")
        btn.setTitleColor(.white, for: .normal)
        var otherBtn : UIButton?
        if btn == rechargeBtn{
            otherBtn = withdrawBtn
            if self.changeBlock != nil{
                self.changeBlock!(0)
            }
        }else{
            otherBtn = rechargeBtn
            if self.changeBlock != nil{
                self.changeBlock!(1)
            }
        }
        otherBtn!.backgroundColor = .white
        otherBtn!.setTitleColor(UIColor.hexColor(hex: "101010"), for: .normal)
    }
    
    @IBAction func refreshBalanceClick(_ sender: Any) {
        if Tool.getuserInfoModel() == nil{
            Tool.getCurrentVc().showTextSB("Please Login", dismissAfterDelay: 1.5)
            return
        }
        Tool.countDown(60, btn: sender as! UIButton)
        Tool.requestGetUserInfo {
            let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
            self.balanceNumberLB.text = account.wallets?.first?.balance
            self.mainBalanceLB.text = account.wallets?.first?.balance
            self.bonusBalanceLB.text = account.wallets?.first?.bonus == nil ? "0.00" : account.wallets?.first?.bonus
        }
    }
    
    @IBAction func selectNumberClick(_ sender: Any) {
        let btn : UIButton = sender as! UIButton
        let superV : UIView = btn.superview!
        let numberLB : UILabel = superV.viewWithTag(1000) as! UILabel
        self.numberTF.text = numberLB.text
        if self.selectNumberBtn == btn{
            return
        }
        superV.layer.borderWidth = 1
        superV.layer.borderColor = UIColor.hexColor(hex: "0CD664").cgColor
        for view in superV.subviews{
            if view is UILabel{
                (view as! UILabel).textColor = .hexColor(hex: "101010")
            }
        }
        
        if self.selectNumberBtn != nil{
            let selectSuperV : UIView = (selectNumberBtn?.superview!)!
            selectSuperV.layer.borderWidth = 1
            selectSuperV.layer.borderColor = UIColor.white.cgColor
            for view in selectSuperV.subviews{
                if view is UILabel{
                    (view as! UILabel).textColor = .hexColor(hex: "969696")
                }
            }
        }
        self.selectNumberBtn = btn
        self.selectNumberIV.isHidden = false
        self.selectNumberIV.frame.size = CGSize(width: 20, height: 20)
        self.selectNumberIV.center = CGPoint(x: superV.center.x, y: CGRectGetMaxY(superV.frame))
    }
    
    
    @IBAction func gotoCouponClick(_ sender: Any) {
        if self.selectCouponBlock != nil{
            self.selectCouponBlock!()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.gotoSelectCouponBtn.isEnabled = false
        DispatchQueue.main.async{
                let position = textField.endOfDocument
                textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
        if self.textFiledWillEditBlock != nil{
            self.textFiledWillEditBlock!()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.textFiledEndEditBlock != nil{
            self.textFiledEndEditBlock!()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        if text == "0." && string.count == 0 {
            textField.text = ""
            return false
        }
        let toBeString = (text as NSString).replacingCharacters(in: range, with: string)
        if string == "." && text.count == 0 {
            textField.text = "0."
            return false
        }
        if string == "." && text.contains(".") {
            return false
        }
        if text.contains(".") && toBeString.components(separatedBy: ".").count > 1 && toBeString.components(separatedBy: ".").last?.count ?? 0 > 2 {
            return false
        }
        return true
    }
    
    ///collectionview delegate dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RechargeNumberCell", for: indexPath) as! RechargeNumberCell
        let model = self.numberArr[indexPath.item]
        cell.numberLB.text = model.value
        cell.hotIV.isHidden = model.isHot == 2 ? false : true
        cell.selectIV.isHidden = !(model.isChoose ?? false)
        if model.isChoose == true{
            cell.numberLB.textColor = .hexColor(hex: "101010")
            cell.unitLB.textColor = .hexColor(hex: "101010")
            cell.bgView.layer.borderWidth = 1
            cell.bgView.layer.borderColor = UIColor.hexColor(hex: "0CD664").cgColor
        }else{
            cell.numberLB.textColor = .hexColor(hex: "969696")
            cell.unitLB.textColor = .hexColor(hex: "969696")
            cell.bgView.layer.borderWidth = 1
            cell.bgView.layer.borderColor = UIColor.white.cgColor
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalW = kScreenW - 20
        return CGSize(width: (totalW-24)/3, height: 65)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<self.numberArr.count{
            if i == indexPath.item{
                self.numberArr[i].isChoose = true
            }else{
                self.numberArr[i].isChoose = false
            }
        }
        self.isNoFastNumber = false
        self.numberTF.text = self.numberArr[indexPath.item].value
        if self.textFiledEndEditBlock != nil{
            self.textFiledEndEditBlock!()
        }
        self.numberCollectionView.reloadData()
    }
}

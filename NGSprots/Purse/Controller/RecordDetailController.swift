//
//  RecordDetailController.swift
//  NGSprots
//
//  Created by Jean on 29/1/2024.
//

import UIKit

class RecordDetailController: BaseViewController {

    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var typeNameLB: UILabel!
    
    @IBOutlet weak var numberLB: UILabel!
    
    @IBOutlet weak var stateLB: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var accountLB: UILabel!
    
    @IBOutlet weak var currencyLB: UILabel!
    
    @IBOutlet weak var timeLB: UILabel!
    
    @IBOutlet weak var orderNumLB: UILabel!
    
    @IBOutlet weak var payTypeLB: UILabel!
    
    @IBOutlet weak var firstLB: UILabel!
    
    @IBOutlet weak var secondLB: UILabel!
    
    @IBOutlet weak var thirdLB: UILabel!
    
    @IBOutlet weak var bgViewH: NSLayoutConstraint!
    
    @IBOutlet weak var accountLBTopSpace: NSLayoutConstraint!
    
    var model : payRwList?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Record"
        self.addNavBar(.white)
        
        setUpUI()
    }

    func setUpUI(){
        self.drawDashLine(lineView: self.lineView, lineLength: 2, lineSpacing: 2, lineColor: .hexColor(hex: "E0E0E0"))
        accountLB.text = Tool.getuserInfoModel()?.account
        loadData(orderType: model?.orderType ?? "deposit", userOrderId: model?.userOrderId ?? "0")
    }
    
    private func loadUI(model: payRwDetailModel){
        if model.orderType == "deposit"{
            if model.bonusAmount == "0"{
                self.bgViewH.constant = 343
                self.accountLBTopSpace.constant = 20
                self.firstLB.isHidden = true
                self.payTypeLB.isHidden = true
                
                self.secondLB.text = "Pay"
                self.accountLB.text = model.payWayName
            }else{
                self.firstLB.text = "Pay"
                self.payTypeLB.text = model.payWayName
                
                self.secondLB.text = "Currency"
                self.accountLB.text = model.currency
                
                self.thirdLB.text = "Bonus"
                self.currencyLB.text = model.bonusAmount
            }
        }else{
            self.firstLB.text = "Banks"
            self.payTypeLB.text = model.bankName
            
            self.secondLB.text = "Account"
            self.accountLB.text = model.accountNum
            
            self.thirdLB.text = "Currency"
            self.currencyLB.text = model.currency
        }
        imageV.image = model.orderType == "deposit" ? UIImage(named: "depositRecord") : UIImage(named: "withdrawRecord")
        typeNameLB.text =  model.orderType == "deposit" ? "Deposit" : "Withdraw"
        timeLB.text = timeDate(time: "\((model.createTime ?? 0)/1000)")
        numberLB.text = model.orderType == "deposit" ? "+\(model.orderAmount ?? "")" : "-\(model.orderAmount ?? "")"
        stateLB.text = model.orderType == "deposit" ? depositStatus(key: model.status ?? 0): withdrawStatus(key: model.status ?? 0)
        if model.orderType == "deposit"{
            if model.status == 4{
                stateLB.textColor = .hexColor(hex: "F01717")
            }else{
                stateLB.textColor = .hexColor(hex: "2ABF83")
            }
        }else{
            if model.status == 4{
                stateLB.textColor = .hexColor(hex: "F01717")
            }else{
                stateLB.textColor = .hexColor(hex: "2ABF83")
            }
        }
    }
    
    private func loadData(orderType: String, userOrderId: String){
        var param = payRwDetailParam()
        param.orderType = orderType
        param.userOrderId = userOrderId
        let api = wxApi.payRwDetail(param: param)
        AdHttpRequest(url: api, successCallBack: { data in
            print("\(data)")
            let result = RequestCallBackViewModel<payRwDetailModel>.deserialize(from: data)
            if(result?.code == 0){
                self.loadUI(model: result?.data ?? payRwDetailModel())
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { error in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
    
    private func drawDashLine(lineView : UIView,lineLength : Int ,lineSpacing : Int,lineColor : UIColor){
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = lineView.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 0.8
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: lineView.bounds.size.width, y: 0))
        shapeLayer.path = path
        lineView.layer.addSublayer(shapeLayer)
    }
    
    private func timeDate(time: String) -> String{
        let timeInterval:TimeInterval = TimeInterval(time)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dformatter.string(from: date as Date)
    }
    
}

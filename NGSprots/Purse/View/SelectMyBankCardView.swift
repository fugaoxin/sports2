//
//  SelectMyBankCardView.swift
//  NGSprots
//
//  Created by Jean on 26/12/2023.
//

import UIKit

class SelectMyBankCardView: UIView,UITableViewDelegate,UITableViewDataSource {
    var addBankCardBlock : (()->Void)?
    var selectBankCardBlock : ((_ model : BankCardModel)->Void)?
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addBtn: UIButton!
    var dataArr : [BankCardModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    lazy var view : UIView = {
        return Bundle.main.loadNibNamed("SelectMyBankCardView", owner: self, options: nil)?.first as! UIView
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
       
        self.drawLayerDashedLine(width: 4, length: 2, space: 2, cornerRadius: 10, color: .hexColor(hex: "0CD664"))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectBankCell", bundle: nil), forCellReuseIdentifier: "SelectBankCell")
    }
    
    @IBAction func closeClick(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform.identity
        },completion:  { _ in
            Tool.keyWindow().hiddenInWindow()
        })
    }
    
    @IBAction func addClick(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform.identity
        },completion:  { _ in
            Tool.keyWindow().hiddenInWindow()
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if self.addBankCardBlock != nil{
                self.addBankCardBlock!()
            }
        }
    }
    ///tableview相关
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell : SelectBankCell! = tableView.dequeueReusableCell(withIdentifier: "SelectBankCell") as? SelectBankCell
        let model = self.dataArr[indexPath.row]
        cell.nameLB.text = "\(model.bankName ?? "")\(model.accountNum ?? "")"
        if cell.nameLB.numberOfLines == 1{
            cell.nameLB.font = UIFont(name: "PingFangSC-Regular",size: 14)
        }else{
            cell.nameLB.font = UIFont(name: "PingFangSC-Regular",size: 12)
        }
        cell.imageV.sd_setImage(with: URL(string: model.bankIcon ?? ""),placeholderImage: UIImage(named: "bankCardPlaceholder"))
        cell.isSelect = model.isSelect
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for model in dataArr {
            model.isSelect = false
        }
        self.dataArr[indexPath.row].isSelect = true
        self.tableView.reloadData()
        if self.selectBankCardBlock != nil{
            self.selectBankCardBlock!(self.dataArr[indexPath.row])
        }
        self.closeClick(UIButton())
    }
    func drawLayerDashedLine(width: CGFloat, length: CGFloat, space: CGFloat, cornerRadius: CGFloat, color: UIColor) {
        self.addBtn.layer.cornerRadius = cornerRadius
        let borderLayer =  CAShapeLayer()
        borderLayer.bounds = CGRect(x: 0, y: 0, width: kScreenW-30, height: 50)
        borderLayer.position = CGPoint(x: (kScreenW-30)/2, y: 25)
        borderLayer.path = UIBezierPath(roundedRect: borderLayer.bounds, cornerRadius: cornerRadius).cgPath
        borderLayer.lineWidth = width / UIScreen.main.scale
        borderLayer.lineDashPattern = [length,space] as? [NSNumber]
        borderLayer.lineDashPhase = 0.1
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        self.addBtn.layer.addSublayer(borderLayer)
    }
}

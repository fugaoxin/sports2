//
//  CouponView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/6.
//

import UIKit

class CouponView: UIView {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var notipsview: UIView!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    
    var clickSelectItems:((_ items: [itemModel]) -> Void)?
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("CouponView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "CouponCell", bundle: nil), forCellReuseIdentifier: "CouponCell")
        tableview.separatorStyle = .none
        tableview.showsVerticalScrollIndicator = false
        tableview.isHidden = true
        tipsLabel.text = "Select promo code to bet for free!\nA list of your active promo codes can be found in my account!\nIf you win, the money will be credited to your master account."
    }
    
    private var listModels = Array<itemModel>()
    func loadUI(models: [itemModel]){
        numLabel.text = "Available Coupon（" + "\(models.count)）"
        listModels = models
        tableview.isHidden = listModels.count > 0 ? false : true
        tableview.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    private func timeDate(time: String) -> String{
        let timeInterval:TimeInterval = TimeInterval(time)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "dd.MM.yyyy"
        return dformatter.string(from: date as Date)
    }

}

extension CouponView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listModels.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 115
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CouponCell = tableView.dequeueReusableCell(withIdentifier: "CouponCell") as! CouponCell
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .white
        cell.label1.backgroundColor = .white
        cell.label2.backgroundColor = .white
        cell.selectBtn.isHidden = false
//        if indexPath.row == 0{
//            cell.selectBtn.isSelected = true
//            cell.selectBtn.layer.borderColor = UIColor.clear.cgColor
//        }else{
//            cell.selectBtn.isSelected = false
//            cell.selectBtn.layer.borderColor = UIColor.hexColor(hex: "D0D1D5").cgColor
//        }
        
        cell.clickSelectBtn = { btn in
//            btn.isSelected = !btn.isSelected
//            if btn.isSelected{
//                cell.selectBtn.layer.borderColor = UIColor.clear.cgColor
//            }else{
//                cell.selectBtn.layer.borderColor = UIColor.hexColor(hex: "D0D1D5").cgColor
//            }
            
            var index = 0
            for _ in self.listModels{
                self.listModels[index].selectBool = false
                index += 1
            }
            self.listModels[indexPath.row].selectBool = true
            self.tableview.reloadData()
            self.clickSelectItems!(self.listModels)
        }
        
        let model = listModels[indexPath.row]
        cell.leftMomey.text = (model.type == 1 ? model.mainValue : "%" + (model.mainValue ?? "0"))
        cell.rightMoney.text = model.limitationShow
        cell.tipsLabel.text = model.desc
        cell.dateLabel.text = model.validityText
        cell.tipsHidden = model.type == 3 ? true : false
        cell.unitImgHidden = model.type == 1 ? false : true
        
        cell.selectBtn.isSelected = model.selectBool ?? false
        cell.selectBtn.layer.borderColor = (model.selectBool ?? false == true ? UIColor.clear.cgColor : UIColor.hexColor(hex: "D0D1D5").cgColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = 0
        for _ in self.listModels{
            self.listModels[index].selectBool = false
            index += 1
        }
        self.listModels[indexPath.row].selectBool = true
        self.tableview.reloadData()
        self.clickSelectItems!(self.listModels)
    }
    
}

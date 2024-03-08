//
//  AccumulatorViewNew.swift
//  NGSprots
//
//  Created by wen xi on 2024/2/20.
//

import UIKit

protocol AccumulatorViewNewDelegate {
    func accumulatorViewNewBet()
    func btshowHUD()
    func bthudHide()
    func btshowTextSB(msg: String)
    func delectList(index: Int, matchId: Int, marketId: Int)
    func uploadBetBg()
}

class AccumulatorViewNew: UIView {
    @IBOutlet weak var betNum: UILabel!
    @IBOutlet weak var peilv: UILabel!
    @IBOutlet weak var betBg: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var bottomViewHH: NSLayoutConstraint!
    var delegate:AccumulatorViewNewDelegate?
    private var showType = "xx"
    
    @IBOutlet weak var tipsimg: UIImageView!
    @IBOutlet weak var tipslabel: UILabel!
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("AccumulatorViewNew", owner: self, options: nil)?.first as! UIView
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
        tableview.register(UINib(nibName: "AccumulatorViewNewTbCell", bundle: nil), forCellReuseIdentifier: "AccumulatorViewNewTbCell")
        tableview.separatorStyle = .none
        tableview.showsVerticalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func viewWillLoadUI(type:Bool){
        self.setTipsDelegate(view: self)
        if chuanguanArray.count > 0{
            if type{
                betBg.isHidden = false
                self.isHidden = false
            }else{
                betBg.isHidden = true
                self.isHidden = true
            }
            setBetBg()
        }else{
            betBg.isHidden = true
            self.isHidden = true
        }
        
//        if chuanguanArray.count >= 5{
//            tipsimg.isHidden = false
//            tipslabel.isHidden = false
//            bottomViewHH.constant = 120
//        }else{
//            tipsimg.isHidden = true
//            tipslabel.isHidden = true
//            bottomViewHH.constant = 90
//        }
        tableview.reloadData()
    }
    
    private func setBetBg(){
        var index = 0
        for model in chuanguanArray{
            if model.selectType ?? true {
                index += 1
            }
        }
        betNum.text = "\(index)"
        if index == 0{
            peilv.text = "0"
        }
    }
    
    private var roadType = true
    private var chuanguanArrayOld = [opModel]()
    func loadData(model:marketOfJumpLineModel){
        chuanguanArrayOld.removeAll()
        chuanguanArrayOld = chuanguanArray
        
        var index = 0
        for citem in chuanguanArray{
            for item in model.bms ?? [bmsModel](){
                if citem.mksId == item.mid {
                    chuanguanArray[index].od = item.op?.od
                    chuanguanArray[index].ss = item.ss
                    chuanguanArray[index].opsOnm = item.op?.nm
                }
            }
            index += 1
        }
        
        if roadType{
            tableview.reloadData()
        }
    }
    
    @IBAction func clickBet(_ sender: UIButton) {
        showType = "xx"
        let account : AccountModel = Tool.getuserInfoModel() ?? AccountModel()
        let acnum: Float = Float(account.wallets?.first?.balance ?? "0") ?? 0
        if 600 > acnum{
            self.showTipsView(title: "Balance Insufficient", subTitle: "Balance in your account insufficient to place this bet.", leftTitle: "Later", rightTitle: "Deposit")
        }else{
            delegate?.accumulatorViewNewBet()
        }
    }
    
    private func timeDate(time: String) -> String{
        let timeInterval:TimeInterval = TimeInterval(time)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "dd MMM yyyy (HH:mm)"
        return dformatter.string(from: date as Date)
    }

    var deleteIndex = 0

}

extension AccumulatorViewNew: UITableViewDelegate, UITableViewDataSource, NYTipsViewDelegate{
    func clickLeftBtn() {
        self.hiddenTipsView()
    }
    
    func clickRightBtn() {
        if showType == "xx"{
            self.hiddenTipsView()
            Tool.getCurrentVc().tabBarController?.selectedIndex = 3
        }else{
            self.hiddenTipsView()
            delegate?.delectList(index: chuanguanArray.count, matchId: chuanguanArray[deleteIndex].recordsId ?? 0, marketId: chuanguanArray[deleteIndex].mksId ?? 0)
            chuanguanArray.remove(at: deleteIndex)
            tableview.reloadData()
            viewWillLoadUI(type: true)
            delegate?.uploadBetBg()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return chuanguanArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 115
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AccumulatorViewNewTbCell = tableView.dequeueReusableCell(withIdentifier: "AccumulatorViewNewTbCell") as! AccumulatorViewNewTbCell
        let model = chuanguanArray[indexPath.item]
        cell.titleLabel.text = model.recordsnm
        let kk = model.tps?.components(separatedBy: ",")
        var timeStr = timeDate(time: "\((model.recordsbt ?? 0)/1000)")
        if (kk?.count ?? 0) > 0{
            timeStr = timeStr + ", " + getMarketTag(key: kk?[0] ?? "")
        }
        cell.timeLabel.text = timeStr
        cell.wfLabel.text = (model.ngnm ?? "") + " : " + (model.opsOnm ?? "")
        cell.peilvLabel.text = "@" + (model.od ?? "0")
        if chuanguanArray.count == chuanguanArrayOld.count{
            let modelOld = chuanguanArrayOld[indexPath.item]
            if model.mksId == modelOld.mksId{
                cell.peilvLabel.text = "@" + (model.od ?? "0")
                let od1:Float = Float(model.od ?? "0") ?? 0
                let od2:Float = Float(modelOld.od ?? "0") ?? 0
                if od1 > od2{
                    cell.peilvLabel.textColor = .hexColor(hex: "FF3344")
                }else if od1 < od2{
                    cell.peilvLabel.textColor = .hexColor(hex: "0CD664")
                }else{
                    cell.peilvLabel.textColor = .hexColor(hex: "19263C")
                }
                
                if model.ss == -1{
                    cell.bgimg.isHidden = true
                    cell.bgview.backgroundColor = .hexColor(hex: "FAE1E6")
                }else{
                    cell.bgimg.isHidden = false
                    cell.bgview.backgroundColor = .hexColor(hex: "F5F5F7")
                }
            }
        }
        
        cell.selectBet = model.selectType ?? true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chuanguanArray[indexPath.item].selectType = !(chuanguanArray[indexPath.item].selectType ?? true)
        tableview.reloadData()
        setBetBg()
        delegate?.uploadBetBg()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "哈哈"
//    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        roadType = true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        roadType = false
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
//                self.dataSource.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .automatic)
            // 需要返回true，否则没有反应
//            completionHandler(true)
            self.showType = "ss"
            self.deleteIndex = indexPath.item
            self.showTipsView(title: "Deleting", subTitle: "Are you sure you want to delete the event?", leftTitle: "Cancel", rightTitle: "Delete")
        }
        deleteAction.backgroundColor = self.tableview.backgroundColor
        deleteAction.image = UIImage(named: "组 124639")
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        // 取消拉动长后自动删除
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete{
//            showType = "ss"
//            deleteIndex = indexPath.item
//            self.showTipsView(title: "Deleting", subTitle: "Are you sure you want to delete the event?", leftTitle: "Cancel", rightTitle: "Delete")
//        }
//    }
    
}

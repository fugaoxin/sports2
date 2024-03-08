//
//  BetSlipViewController.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/11.
//

import UIKit
import MJRefresh

class BetSlipViewController: UIViewController {

    @IBOutlet weak var collectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = appearance;
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        title = "Bet slip"
        // Do any additional setup after loading the view.
        setUI()
    }
    
    private func setUI(){
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = UICollectionView.ScrollDirection.vertical
        collectionview.setCollectionViewLayout(layout2, animated: true)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.register(UINib(nibName: "OrderViewCell", bundle: nil), forCellWithReuseIdentifier: "OrderViewCell")
        //collectionview.showEmptyView(image: "yishoucang_icon", title: "NONE", subtitle: "No data of interest is currently accessible")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        orderBetListRequest()
    }
    
    private var wjslistArrays = Array<obRecordModel>()
    private func uplodaUI(models: orderBetListModel){
        wjslistArrays.removeAll()
        for record in models.records ?? [obRecordModel](){
            wjslistArrays.append(record)
        }
        //print("wjslistArrays===\(wjslistArrays)")
        collectionview.reloadData()
    }
    
    private func timeDate(time: String) -> String{
        let timeInterval:TimeInterval = TimeInterval(time)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "dd MMM yyyy (HH:mm)"
        return dformatter.string(from: date as Date)
    }

}

extension BetSlipViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wjslistArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderViewCell", for: indexPath) as! OrderViewCell
        let obRecords:obRecordModel = wjslistArrays[indexPath.row]
        if obRecords.ops?.count ?? 0 > 0{
            cell.label1.text = obRecords.ops?[0].ln
            cell.label2.text = "\(obRecords.ops?[0].onm ?? "")" + "@" + "\(obRecords.ops?[0].od ?? "")"
            cell.type.text = obRecords.ops?[0].mgn ?? ""
            cell.label3.text = obRecords.ops?[0].mn ?? ""
            cell.label4.text = timeDate(time: "\((obRecords.cte ?? 0)/1000)")
            cell.label5.text = "₦ " + "\(obRecords.sat ?? "0")"
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: kScreenW - 20, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
}

extension BetSlipViewController{
    private func orderBetListRequest(){
        self.showHUD(text: "Loading...")
        var param = orderBetParam()
        param.languageType = "ENG"
        param.isSettled = false
        param.current = "1"
        param.size = "50"
        param.timeType = "1"
        param.current = "1"
        let api = wxApi.orderBetList(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            print(data)
            let result = RequestCallBackViewModel<orderBetListModel>.deserialize(from: data)
            if(result?.code == 0){
                guard let data = result?.data else{
                    return
                }
                self.uplodaUI(models: data)
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.hudHide()
        }
    }
}

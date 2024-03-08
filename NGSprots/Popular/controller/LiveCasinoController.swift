//
//  LiveCasinoController.swift
//  NGSprots
//
//  Created by Jean on 25/1/2024.
//

import UIKit

class LiveCasinoController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var model : GameListModel?
    
    var dataArr : [GameDataListModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (model?.name ?? "")// + "（\(model?.gameNum ?? "")）"
        self.addNavBar(.white)
        
        setUpUI()
    }
    func setUpUI(){
        
//        self.dataArr  = [LiveCasinoModel(url: "",name: "Turkish Blackjack 1",gameNum: "8",isPlay: false,isNew: true,isHot: true,isOpen: true),
//                         LiveCasinoModel(url: "",name: "Turkish Blackjack 2",gameNum: "20",isPlay: true,isNew: false,isHot: true,isOpen: true),
//                         LiveCasinoModel(url: "",name: "Unlimited Blackjack",gameNum: "20",isPlay: true,isNew: false,isHot: true,isOpen: true),
//                         LiveCasinoModel(url: "",name: "Gold Blackjack 4",gameNum: "20",isPlay: true,isNew: false,isHot: false,isOpen: false),
//                         LiveCasinoModel(url: "",name: "VIP Blackjack",gameNum: "8",isPlay: false,isNew: false,isHot: false,isOpen: true),
//                         LiveCasinoModel(url: "",name: "Russian Blackjack 2",gameNum: "8",isPlay: false,isNew: false,isHot: false,isOpen: true),
//                         LiveCasinoModel(url: "",name: "VIP Diamond Blackjack",gameNum: "8",isPlay: false,isNew: false,isHot: false,isOpen: true),
//                         LiveCasinoModel(url: "",name: "VIP Blackjack",gameNum: "8",isPlay: false,isNew: false,isHot: false,isOpen: false)]
        
        let layout = UICollectionViewFlowLayout()
        var W = (kScreenW - 30)/3
        var H = W*31/23
        var ww = 5
        if model?.id == 3{
            W = (kScreenW-30)/2
            H = W*280/345
            ww = 10
        }
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: W, height: H)
        layout.minimumLineSpacing = CGFloat(ww)
        layout.minimumInteritemSpacing = CGFloat(ww)
        
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "LiveCasinoGameCell", bundle: nil), forCellWithReuseIdentifier: "LiveCasinoGameCell")
        
        gameList(gameId: "\(model?.id ?? 0)")
    }
    
    private func roadData(models: [GameDataListModel]){
        self.dataArr = models
        collectionView.reloadData()
    }
    
    ///collectionview delegate dataSourc
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCasinoGameCell", for: indexPath) as! LiveCasinoGameCell
        cell.model = self.dataArr[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var W = (kScreenW - 30)/3
        var H = W*31/23
        if model?.id == 3{
            W = (kScreenW-30)/2
            H = W*280/345
        }
        return CGSize(width: W, height: H)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataArr[indexPath.item]
        let vc = GameViewController()
        vc.gameId = "\(model.gameId ?? 0)"
        vc.gameCode = model.gameCode
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LiveCasinoController{
    private func gameList(gameId: String){
        self.showHUD(text: "Loading...")
        var param = GameTokenParam()
        param.gameId = gameId
        let api = wxApi.gameDetailsList(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<GameDataModel>.deserialize(from: data)
            if(result?.code == 0){
                self.roadData(models: result?.data?.list ?? [GameDataListModel]())
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
}

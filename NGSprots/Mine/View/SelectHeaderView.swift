//
//  SelectHeaderView.swift
//  SportsDemo
//
//  Created by Jean on 3/11/2023.
//

import UIKit

class SelectHeaderView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var confirmBlock : ((_ image:UIImage)->Void)?

    @IBOutlet weak var headerCollectionView: UICollectionView!
    
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var titleLB: UILabel!
   
    
    var selectIndex = -1
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("SelectHeaderView", owner: self, options: nil)?.first as! UIView
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
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: 70, height: 70)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = (kScreenW-50-280)/4
        
        headerCollectionView.backgroundColor = .white
        headerCollectionView.collectionViewLayout = layout
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.showsVerticalScrollIndicator = false
        headerCollectionView.register(UINib(nibName: "SelectHeaderCell", bundle: nil), forCellWithReuseIdentifier: "SelectHeaderCell")
    }
    
    @IBAction func closeClick(_ sender: Any) {
        Tool.keyWindow().hiddenInWindow()
    }
    
    @IBAction func sureClick(_ sender: Any) {
        if self.selectIndex == -1{
            Tool.keyWindow().showTextSB("Please select", dismissAfterDelay: 1)
            return
        }
        if self.confirmBlock != nil{
            self.confirmBlock!(UIImage(named: String(self.selectIndex+1))!)
        }
        Tool.keyWindow().hiddenInWindow()
    }
    ///collectionview delegate dataSourc
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectHeaderCell", for: indexPath) as! SelectHeaderCell
        cell.headerIV.image = UIImage.init(named: String(indexPath.row+1))
        if indexPath.item == self.selectIndex{
            cell.isChoose = true
        }else{
            cell.isChoose = false
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectIndex = indexPath.item
        self.headerCollectionView.reloadData()
    }

}


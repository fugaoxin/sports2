//
//  SelectRegionStateCell.swift
//  NGSprots
//
//  Created by Jean on 9/1/2024.
//

import UIKit

class SelectRegionStateCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var selectStateBlock : ((_ type : String)->Void)?
    
    @IBOutlet weak var stateCollectionView: UICollectionView!
    
    var selectIndex : String = ""{
        didSet{
            self.stateCollectionView.reloadData()
        }
    }
    var dataArr : [String]? {
        didSet{
            self.stateCollectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    func setUpUI(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: (kScreenW-45)/2, height: 35)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 15
        
        stateCollectionView.backgroundColor = .white
        stateCollectionView.collectionViewLayout = layout
        stateCollectionView.delegate = self
        stateCollectionView.dataSource = self
        stateCollectionView.showsVerticalScrollIndicator = false
        stateCollectionView.register(UINib(nibName: "StateItemCell", bundle: nil), forCellWithReuseIdentifier: "StateItemCell")
    }
    
    ///collectionview delegate dataSourc
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StateItemCell", for: indexPath) as! StateItemCell
        cell.nameLB.text = self.dataArr?[indexPath.row]
        if self.dataArr?[indexPath.row] == self.selectIndex{
            cell.isSelect = true
        }else{
            cell.isSelect = false
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenW-45)/2, height: 35)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectIndex != self.dataArr?[indexPath.row]{
            if self.selectStateBlock != nil{
                self.selectStateBlock!(self.dataArr?[indexPath.row] ?? "")
            }
        }
        self.selectIndex = self.dataArr?[indexPath.row] ?? ""
        self.stateCollectionView.reloadData()
        
    }
}

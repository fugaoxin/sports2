//
//  SelectionCategoryView.swift
//  NGSprots
//
//  Created by wen xi on 2024/2/1.
//

import UIKit

class SelectionCategoryView: UIView {
    
    var xbtn:(() -> Void)?
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var cancel: UIButton!
    
    var typeArray = [("Sports",true), ("Live casino",false), ("Slot machine",false)]
    //, ("Esports",false), ("Simulate",false), ("League&Races",false), ("Virtual",false)
    
    var okbtn:((_ str: String) -> Void)?
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("SelectionCategoryView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
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
        collectionview.register(UINib(nibName: "DetailShuanxuanCell", bundle: nil), forCellWithReuseIdentifier: "DetailShuanxuanCell")
        
    }
    
    func loadUI(title: String){
        var index = 0
        var index2 = 0
        for dict in typeArray{
            if title == dict.0{
                index2 = index
            }
            typeArray[index].1 = false
            index += 1
        }
        typeArray[index2].1 = true
        collectionview.reloadData()
    }
    
    @IBAction func clickXBtn(_ sender: UIButton) {
        xbtn!()
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        xbtn!()
    }
    
    @IBAction func clickOk(_ sender: UIButton) {
        for dict in typeArray{
            if dict.1{
                okbtn!(dict.0)
                break
            }
        }
        xbtn!()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

}

extension SelectionCategoryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailShuanxuanCell", for: indexPath) as! DetailShuanxuanCell
        let dict = typeArray[indexPath.row]
        cell.titleLabel.text = dict.0
        if dict.1{
            cell.titleLabel.textColor = .hexColor(hex: "0CD664")
        }else{
            cell.titleLabel.textColor = .hexColor(hex: "101010")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenW, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index = 0
        for _ in typeArray {
            typeArray[index].1 = false
            index += 1
        }
        typeArray[indexPath.row].1 = true
        collectionview.reloadData()
        okbtn!(typeArray[indexPath.row].0)
        xbtn!()
    }
    
}

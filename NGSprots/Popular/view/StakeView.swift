//
//  StakeView.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/29.
//

import UIKit

class StakeView: UIView {

    @IBOutlet weak var codetext: UITextField!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var xianeLabel: UILabel!
    
    private var moneyArray = ["30","50","100","200","1000","2000"]
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("StakeView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        codetext.layer.borderColor = UIColor.hexColor(hex: "F5F6F9").cgColor
        codetext.layer.borderWidth = 0.5
        codetext.keyboardType = .numberPad
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collectionview.setCollectionViewLayout(layout, animated: true)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.register(UINib(nibName: "ClassCell", bundle: nil), forCellWithReuseIdentifier: "ClassCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    @IBAction func jianBtn(_ sender: UIButton) {
        let db1 = Float(codetext.text ?? "0")
        codetext.text = String(format: "%.2f", (db1 ?? 0) - 1)
    }
    
    @IBAction func jiaBtn(_ sender: UIButton) {
        let db1 = Float(codetext.text ?? "0")
        codetext.text = String(format: "%.2f", (db1 ?? 0) + 1)
    }

}

extension StakeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moneyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassCell", for: indexPath) as! ClassCell
        cell.titleLabel.text = moneyArray[indexPath.item] + " ₦"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        codetext.text = moneyArray[indexPath.item]
    }
}

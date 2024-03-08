//
//  DetailShuaixuanView.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/2.
//

import UIKit

protocol DetailShuaixuanViewDelegate{
    func shuaixuanRegsult(dic: (String,String,String))
}

class DetailShuaixuanView: UIView {

    @IBOutlet weak var sousuo: UITextField!
    @IBOutlet weak var listCollectionView: UICollectionView!
    private var classArray = [("Regular time","all","1")]
    
    var delegate: DetailShuaixuanViewDelegate?
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("DetailShuaixuanView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        sousuo.layer.borderColor = UIColor.hexColor(hex: "EDEDEF").cgColor
        sousuo.layer.borderWidth = 0.5
        
        //设置左侧放大镜
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 37, height: 22)
        let imgV = UIImageView()
        imgV.contentMode = .scaleToFill
        imgV.image = UIImage(named: "sousuo_icon")
        imgV.frame = CGRect(x: 15, y: 0, width: 22, height: 22)
        leftView.addSubview(imgV)
        sousuo.leftView = leftView
        //设置为空内容才显示放大镜，输入时不显示放大镜.unlessEditing  如要一直显示设置.always
        sousuo.leftViewMode = .always
        sousuo.contentVerticalAlignment = .center
        sousuo.returnKeyType = .search
        sousuo.delegate = self
        sousuo.addTarget(self, action: #selector(searchDidChange(textField:)), for: .editingChanged)
        sousuo.isUserInteractionEnabled = true
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = UICollectionView.ScrollDirection.vertical
        listCollectionView.setCollectionViewLayout(layout2, animated: true)
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.alwaysBounceVertical = true
        listCollectionView.showsVerticalScrollIndicator = false
        listCollectionView.register(UINib(nibName: "DetailShuanxuanCell", bundle: nil), forCellWithReuseIdentifier: "DetailShuanxuanCell")
        
    }
    
    func uploadUI(arr: [(String,String,String)]){
        classArray = arr
        oldClassArray = arr
        if !searchType{
            listCollectionView.reloadData()
        }
    }
    
    func uploadSearchView(str: String){
        if str == ""{
            searchType = false
            classArray = oldClassArray
        }else{
            searchType = true
            //classArray = oldClassArray.filter { $0.0.contains(str) }
            classArray = oldClassArray.filter({ (item) -> Bool in
                return item.0.range(of: str, options: .caseInsensitive) != nil
            })
        }
        listCollectionView.reloadData()
    }
    
    var searchType = false
    private var oldClassArray = Array<(String,String,String)>()
    @objc func searchDidChange(textField: UITextField) {
        uploadSearchView(str: textField.text ?? "")
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

}

extension DetailShuaixuanView: UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailShuanxuanCell", for: indexPath) as! DetailShuanxuanCell
        cell.titleLabel.text = classArray[indexPath.item].0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenW - 20, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.shuaixuanRegsult(dic: classArray[indexPath.item])
        sousuo.text = ""
        searchType = false
    }
    
}

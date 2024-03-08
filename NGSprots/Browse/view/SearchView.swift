//
//  SearchView.swift
//  NGSprots
//
//  Created by wen xi on 2023/11/29.
//

import UIKit

protocol SearchViewdelegate{
    func searchTitle(str: String)
    func delectSearchTitle(str: String)
    func clearSearchTitle()
}

class SearchView: UIView {

    @IBOutlet weak var clearLabel: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    private var searchLists = [String]()
    var delegate: SearchViewdelegate?
    
    lazy var view: UIView = {
        return Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)?.first as! UIView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        view.frame = bounds
        addSubview(view)
        setUI()
    }
    
    private func setUI(){
        let layout = TipsCollectionViewLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.collectionViewLayout = layout
        collectionview.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchViewCell")
        
        clearLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickClearLabel))
        clearLabel.addGestureRecognizer(tap)
        
        self.view.backgroundColor = .hexColor(hex: "F5F5F7")
    }
    
    @objc func clickClearLabel(){
        if searchLists.count > 0{
            self.showTipsView(title: "Deleting", subTitle: "Are you sure you want to delete the all?", leftTitle: "Cancel", rightTitle: "Delete")
        }
    }
    
    func loadUI(arr: Array<String>){
        self.setTipsDelegate(view: self)
        if arr.count > 0{
            clearLabel.text = "Clear Search（" + "\(arr.count)" + "）"
        }else{
            clearLabel.text = "Clear Search"
        }
        searchLists = arr
        collectionview.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

}

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchViewCelldelegate,NYTipsViewDelegate{
    func clickLeftBtn() {
        self.hiddenTipsView()
    }
    
    func clickRightBtn() {
        self.hiddenTipsView()
        delegate?.clearSearchTitle()
    }
    
    func searchDelectBtn(btn: UIButton) {
        let TL = searchLists[btn.tag - 100]
        searchLists.remove(at: btn.tag - 100)
        if searchLists.count > 0{
            clearLabel.text = "Clear Search（" + "\(searchLists.count)" + "）"
        }else{
            clearLabel.text = "Clear Search"
        }
        collectionview.reloadData()
        delegate?.delectSearchTitle(str: TL)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchViewCell", for: indexPath) as! SearchViewCell
        cell.titleLabel.text = searchLists[indexPath.item]
        cell.dtl.tag = indexPath.item + 100
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //除了文本宽度 还需给40 的宽度预留空白及删除按钮
        let textW = Tool.getLabelWith(text: searchLists[indexPath.item],font: UIFont.boldSystemFont(ofSize: 11) ,labelH: 26)
        var itemW : CGFloat = 0
        if textW > kScreenW-20-40{
            itemW = kScreenW-20
        }else{
            itemW = textW + 40
        }
        return CGSize(width: itemW, height: 26)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.searchTitle(str: searchLists[indexPath.item])
    }
    
}


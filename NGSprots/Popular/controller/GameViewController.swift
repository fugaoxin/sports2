//
//  GameViewController.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/30.
//

import UIKit
import WebKit

class GameViewController: BaseViewController,WKNavigationDelegate,WKUIDelegate {
    
    var gameId: String?
    var gameCode: String?
    
    lazy var webView : WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        let view = WKWebView(frame: CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - (kNavigationBarH + kStatusBarH)), configuration: configuration)
        view.backgroundColor = .white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Games"
        self.addNavBar(.white)
        self.view.backgroundColor = .white
        setUpUI()
    }
    
    private func setUpUI(){
        self.view.addSubview(self.webView)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        gameList()
    }
    //MARK:- 页面开始加载时候调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showHUD(text: "Loading...")
        print("页面开始加载")
    }

    //MARK:- 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("页面加载完成")
        self.hideHUD()
    }
    //MARK:- 页面加载失败的时候调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("页面加载失败")
        self.hideHUD()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideHUD()
    }
    
    private func loadUrl(url: String){
        if let encodeString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            if encodeString.count > 0{
                self.webView.load(URLRequest(url: URL(string: encodeString)!))
            }
        }
    }
    
}

extension GameViewController{
    private func gameList(){
        self.showHUD(text: "Loading...")
        var param = GameTokenParam()
        param.gameId = gameId
        var dict = configModel()
        if gameCode != "01"{
            dict.gameCode = gameCode
        }
//        dict.appType = 2
        param.config = dict
        
        let api = wxApi.gameAccessUrl(param: param)
        AdHttpRequest(url: api, successCallBack: { (data) in
            self.hudHide()
            let result = RequestCallBackViewModel<gameAccessUrlModel>.deserialize(from: data)
            if(result?.code == 0){
                self.loadUrl(url: result?.data?.url ?? "")
            }else{
                self.showTextSB(result?.message, dismissAfterDelay: 1.5)
            }
        }) { (error) in
            self.hudHide()
            self.showTextSB(error, dismissAfterDelay: 1.5)
        }
    }
}

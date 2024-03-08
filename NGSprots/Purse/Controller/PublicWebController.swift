//
//  PublicWebController.swift
//  NGSprots
//
//  Created by Jean on 23/1/2024.
//

import UIKit
import WebKit

class PublicWebController: BaseViewController,WKNavigationDelegate,WKUIDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody = message.body as? [String:Any]{
            if messageBody["message"] as! String == "goBet"{
                self.navigationController?.popToRootViewController(animated: true)
                self.tabBarController?.selectedIndex = 2
            }
            if messageBody["message"] as! String == "goToDeposit"{
                self.navigationController?.popToRootViewController(animated: true)
                self.tabBarController?.selectedIndex = 3
            }
        }
    }
    
    var url : String?
    
    var titleStr : String?
    
    lazy var webView : WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "goBet")
        configuration.userContentController.add(self, name: "goToDeposit")
        let view = WKWebView(frame: CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - (kNavigationBarH + kStatusBarH)), configuration: configuration)
        view.backgroundColor = .white
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if titleStr == nil{
            self.title = "Recharge"
        }else{
            self.title = self.titleStr
        }
        self.addNavBar(.white)
        self.view.backgroundColor = .white
        setUpUI()
    }

    private func setUpUI(){
        self.view.addSubview(self.webView)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        if Tool.StringIsEmpty(value: self.url) == false{
            if URL(string: self.url ?? "") == nil{
                if let encodeString = self.url!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                    self.webView.load(URLRequest(url: URL(string: encodeString)!))
                }
            }else{
                self.webView.load(URLRequest(url: URL(string: self.url ?? "")!))
            }
        }
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
    //MARK:- 在发送请求之前，决定是否跳转【可拦截URL做些操作什么的】
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        if let urlString = navigationAction.request.url?.absoluteString {
            print(urlString)
            if urlString.contains("/payment/success"){ //支付成功
                self.showTextSBimg("successful", dismissAfterDelay: 1.5, imgstr: "tipsV")
                if urlString.contains("?status=successful"){
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                return WKNavigationActionPolicy.cancel
            }
        }
        return WKNavigationActionPolicy.allow   //允许跳转
    }
    //MARK:- 在收到响应后 决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        return WKNavigationResponsePolicy.allow   //允许跳转
    }
}

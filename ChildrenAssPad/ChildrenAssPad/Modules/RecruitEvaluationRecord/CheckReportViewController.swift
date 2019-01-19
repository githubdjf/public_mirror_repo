//
//  CheckReportViewController.swift
//  FirstEducation
//
//  Created by 译泰视觉 on 2018/10/11.
//  Copyright © 2018 yitai. All rights reserved.
//

import UIKit
import WebKit

class CheckReportViewController: BaseViewController, WKNavigationDelegate {
    var navi: UIView!
    var urlStr = ""
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        createUI()
    }
    
    func createUI() -> Void {
        self.navi = self.addNavByTitle(title: "查看报告")
        self.addBackButtonForNavigationBar()
        

//        let userName = LoginManager.default.curUser?.userName
//        let info  = UIButton(type: .custom)
//        navi.addSubview(info)
//        info.setImage(UIImage.init(named: "icon_user"), for: .normal)
//        info.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
//        info.setTitle(userName, for: .normal)
//        info.setTitleColor(UIColor.white, for: .normal)
//        info.isUserInteractionEnabled = false

        
        
        let webConfiguration = WKWebViewConfiguration()
        let web = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        if let url = URL(string: urlStr) {
            var request = URLRequest(url: url)
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            web.load(request)
        }
        
        web.navigationDelegate = self
        
        self.view.addSubview(web)
        web.snp.makeConstraints { (make) in
            make.top.equalTo(navBarHeight())
            make.left.right.equalTo(0)
            make.bottom.equalTo(-safeBottomPadding())
        }
        self.activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
        
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.center = self.view.center
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
        self.activityIndicator.stopAnimating()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

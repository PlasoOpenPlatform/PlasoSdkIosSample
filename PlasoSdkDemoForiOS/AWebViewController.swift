//
//  AWebViewController.swift
//  PlasoSDKDemo
//
//  Created by Jing Jiang on 2021/8/13.
//  Copyright © 2021 com.plaso. All rights reserved.
//

import UIKit
import WebKit

class AWebViewController: UIViewController {

    var webview : WKWebView?
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false 
        webview = web
        self.view.addSubview(web)
        
        web.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        web.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        web.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        web.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        guard let u = url,let aurl = URL(string: u) else {
            return
        }
        let request = URLRequest(url: aurl)
        webview?.load(request)
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

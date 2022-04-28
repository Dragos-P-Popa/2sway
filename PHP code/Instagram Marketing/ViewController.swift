//
//  ViewController.swift
//  Instagram Marketing
//
//  Created by Abdullah Ibrahim on 17.11.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let myURL = URL(string:"https://www.instagram.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        webView.navigationDelegate = self
        
        
        
    }
    
    
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url
        {
            webView.getCookies() { data in
                print("=========================================")
                print("\(url.absoluteString)")
                print(data)
            }
        }
    }
}


extension WKWebView {

    private var httpCookieStore: WKHTTPCookieStore  { return WKWebsiteDataStore.default().httpCookieStore }

    func getCookies(for domain: String? = nil, completion: @escaping ([String : Any])->())  {
        var cookieDict = [String : AnyObject]()
        httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                if(cookie.name == "sessionid")
                {
                    
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
                
            }
            completion(cookieDict)
        }
    }
}

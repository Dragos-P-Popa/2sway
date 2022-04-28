//
//  WebViewViewController.swift
//  2Sway
//
//  Created by Abhishek Dubey on 26/12/21.
//

import UIKit
import WebKit
import Foundation

protocol WebViewCotrollerDelegate: AnyObject {
    func hideView()
}

class WebViewViewController: UIViewController {

    var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    var urlString = "https://www.instagram.com/accounts/login/"
    var delegate: WebViewCotrollerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: urlString)!))
        activateConstraints()
       
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        )
    }
}

extension WebViewViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url {
            webView.getCookies() { data, userId in
                print(data)
                self.dismiss(animated:true, completion:nil)
//                APIClient().getStoryCount(data: data, userID: userId) { storyCount, storyID in
//                    DispatchQueue.main.async {
//                        self.dismiss(animated: true, completion: {
//                            print("Hello Stories ", storyCount)
//                            self.delegate?.hideView()
//                        })
//                    }
//                } fail: { error in
//                    DispatchQueue.main.async {
//                        self.dismiss(animated: true, completion: {
//                            self.delegate?.hideView()
//                        })
//                    }
//                }
            }
        }
    }
}

extension WKWebView {
    private var httpCookieStore: WKHTTPCookieStore { return WKWebsiteDataStore.default().httpCookieStore }

    func getCookies(for domain: String? = nil, completion: @escaping(String, String) -> ()) {
        var cookieString = ""
        httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                cookieString += "\(cookie.domain)\t\(cookie.isSecure)\t\(cookie.path)\t\(cookie.isSecure)\t\(cookie.expiresDate?.timeIntervalSince1970 ?? 0)\t\(cookie.name)\t\(cookie.value)\n"
                //userID += cookie.value(forKey: "ds_user_id") as? String ?? ""
            }
            let headers=HTTPCookie.requestHeaderFields(with: cookies)
            var userID: String? = ""
            let cookies = headers["Cookie"] ?? ""
            if cookies.contains("ds_user_id=") {
                let userCompleteString = headers["Cookie"]?.components(separatedBy: "ds_user_id=")[1]
                userID = userCompleteString?.components(separatedBy: ";")[0]
                print("Headers ", headers)
                print("Hello UID", userID)
            } else {
                return
            }
            let plainData = cookieString.data(using: .utf8)
            K.cookieString = plainData?.base64EncodedString()
            K.userID = userID
            UserDefaults.standard.set(plainData?.base64EncodedString(), forKey: "cookie")
            UserDefaults.standard.set(userID, forKey: "userID")
            
            completion(plainData?.base64EncodedString() ?? "", userID ?? "")
        }
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

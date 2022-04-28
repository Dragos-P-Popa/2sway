//
//  Cookies.swift
//  Instagram Marketing
//
//  Created by Abdullah Ibrahim on 30.12.2021.
//

import WebKit

extension WKWebView {

    private var httpCookieStore: WKHTTPCookieStore  { return WKWebsiteDataStore.default().httpCookieStore }

    func getCookies(for domain: String? = nil, completion: @escaping (String, String)->())
    {
        var cookieString = ""
        var userId = ""
        httpCookieStore.getAllCookies { cookies in
            for cookie in cookies
            {
                if(cookie.name == "ds_user_id")
                {
                    userId = cookie.value
                }
                cookieString += "\(cookie.domain)\t\(cookie.isSecure)\t\(cookie.path)\t\(cookie.isSecure)\t\(cookie.expiresDate?.timeIntervalSince1970 ?? 0)\t\(cookie.name)\t\(cookie.value)\n"
            }
            let decodedCookieString = cookieString.data(using: .utf8)?.base64EncodedString() ?? ""
            completion(decodedCookieString, userId)
        }
    }
}

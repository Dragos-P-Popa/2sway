//
//  CheckNetWork.swift
//  2Sway
//
//  Created by Techcronus on 18/02/22.
//

import Foundation
import UIKit

protocol NetworkSpeedProviderDelegate: class {
    func callWhileSpeedChange(networkStatus: NetworkStatus)
}
public enum NetworkStatus :String
{case poor; case good; case disConnected}

class NetworkSpeedTest: UIViewController {
    
    weak var delegate: NetworkSpeedProviderDelegate?
    var startTime = CFAbsoluteTime()
    var stopTime = CFAbsoluteTime()
    var bytesReceived: CGFloat = 0
    var testURL:String?
    var speedTestCompletionHandler: ((_ megabytesPerSecond: CGFloat, _ error: Error?) -> Void)? = nil
    var timerForSpeedTest:Timer?
    
    func networkSpeedTestStart(UrlForTestSpeed:String!){
        testURL = UrlForTestSpeed
        timerForSpeedTest = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(testForSpeed), userInfo: nil, repeats: true)
        
    }
    func networkSpeedTestStop(){
        timerForSpeedTest?.invalidate()
    }
    @objc func testForSpeed()
    {
        testDownloadSpeed(withTimout: 2.0, completionHandler: {(_ megabytesPerSecond: CGFloat, _ error: Error?) -> Void in
            print("%0.1f; KbPerSec = \(megabytesPerSecond)")
            if (error as NSError?)?.code == -1009
            {
                self.delegate?.callWhileSpeedChange(networkStatus: .disConnected)
                let uiAlert = UIAlertController(title: "Error!", message: "Please check your network connection ! it looks like poor or disconnected", preferredStyle: UIAlertController.Style.alert)
                self.present(uiAlert, animated: true, completion: nil)
            }
            else if megabytesPerSecond == -1.0
            {
                self.delegate?.callWhileSpeedChange(networkStatus: .poor)
                let uiAlert = UIAlertController(title: "Error!", message: "Please check your network connection ! it looks like poor or disconnected", preferredStyle: UIAlertController.Style.alert)
                self.present(uiAlert, animated: true, completion: nil)
            }
            else
            {
                self.delegate?.callWhileSpeedChange(networkStatus: .good)
                
            }
        })
    }
}
extension NetworkSpeedTest: URLSessionDataDelegate, URLSessionDelegate {

func testDownloadSpeed(withTimout timeout: TimeInterval, completionHandler: @escaping (_ megabytesPerSecond: CGFloat, _ error: Error?) -> Void) {

    // you set any relevant string with any file
    let urlForSpeedTest = URL(string: testURL!)

    startTime = CFAbsoluteTimeGetCurrent()
    stopTime = startTime
    bytesReceived = 0
    speedTestCompletionHandler = completionHandler
    let configuration = URLSessionConfiguration.ephemeral
    configuration.timeoutIntervalForResource = timeout
    let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)

    guard let checkedUrl = urlForSpeedTest else { return }

    session.dataTask(with: checkedUrl).resume()
}

func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    bytesReceived += CGFloat(data.count)
    stopTime = CFAbsoluteTimeGetCurrent()
}

func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    let elapsed = (stopTime - startTime) //as? CFAbsoluteTime
    let speed: CGFloat = elapsed != 0 ? bytesReceived / (CGFloat(CFAbsoluteTimeGetCurrent() - startTime)) / 1024.0 : -1.0
    // treat timeout as no error (as we're testing speed, not worried about whether we got entire resource or not
    if error == nil || ((((error as NSError?)?.domain) == NSURLErrorDomain) && (error as NSError?)?.code == NSURLErrorTimedOut) {
        speedTestCompletionHandler?(speed, nil)
    }
    else {
        speedTestCompletionHandler?(speed, error)
    }
  }
}

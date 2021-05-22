//
//  ViewController.swift
//  NetGuardDemo
//
//  Created by Batıkan SOSUN on 24.01.2021.
//

import UIKit
import NetGuard
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let timer = Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { (timer) in
            self.getRequest()
            self.postRequest()
            self.getWrongRequest()
        }
        timer.fire()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //NetGuard().showNetGuard()
        // if 'shakeEnabled' property is not 'true' you can call this method in the anywhere you want to show the NetGuard
    }
    func postRequest() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 9.0
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfiguration.httpAdditionalHeaders = ["Accept-Language": "en","Content-Type": "application/json; charset=UTF-8"]
        
        
        var request = URLRequest(url: URL(string: "http://jsonplaceholder.typicode.com/posts")!)
        request.httpMethod = "POST"
        request.httpBody = "{\"userId\": 1,\"id\": 2,\"title\": \"qui est esse\",\"body\": \"i\"}".data(using: .utf8)
        
        let session = URLSession.init(configuration: sessionConfiguration)
        
        session.dataTask(with: request) { (data, res, err) in
            print(res?.description ?? "")
        }.resume()
    }
    
    
    
    func getRequest() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 9.0
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfiguration.httpAdditionalHeaders = ["Accept-Language": "en","Content-Type": "plain/text"]
        
        
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)
        request.httpMethod = "GET"
        
        let session = URLSession.init(configuration: sessionConfiguration)
        
        session.dataTask(with: request) { (data, res, err) in
            print(res?.description ?? "")
        }.resume()
    }
    
    func getWrongRequest() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 9.0
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfiguration.httpAdditionalHeaders = ["Accept-Language": "en","Content-Type": "plain/text"]
        
        
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com")!)
        request.httpMethod = "GET"
        
        let session = URLSession.init(configuration: sessionConfiguration)
        
        session.dataTask(with: request) { (data, res, err) in
            print(res?.description ?? "")
        }.resume()
    }


}


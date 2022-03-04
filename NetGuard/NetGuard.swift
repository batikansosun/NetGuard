//
//  NetGuard.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 23.01.2021.
//

import Foundation
import UIKit

public class NetGuard: NSObject{
    
    @objc public static var blackListHosts: [String] {
        get { return NetGuardHTTPProtocol.blacklistHosts }
        set { NetGuardHTTPProtocol.blacklistHosts = newValue }
    }
    
    @objc public static var requestLimit: NSNumber? {
        get { StorageManager.requestLimit }
        set { StorageManager.requestLimit = newValue }
    }
    
    @objc public static var enabled: Bool {
        get { return NetGuardHTTPProtocol.enabled }
        set { NetGuardHTTPProtocol.enabled = newValue }
    }
    
    /// default value is true
    @objc public static var shakeEnabled = true
    
    static func enable(_ enable: Bool) {
        if enable{
            URLProtocol.registerClass(NetGuardHTTPProtocol.self)
        }else{
            URLProtocol.unregisterClass(NetGuardHTTPProtocol.self)
        }
    }
    
    @objc public static func enable(_ enable: Bool, sessionConfiguration: URLSessionConfiguration) {
        var urlProtocolClasses = sessionConfiguration.protocolClasses
        let protocolClassNetGuard = NetGuardHTTPProtocol.self
        
        guard urlProtocolClasses != nil else{
            return
        }
        
        let index = urlProtocolClasses?.firstIndex(where: { (obj) -> Bool in
            var found = false
            if obj == protocolClassNetGuard{
                found = true
            }
            return found
        })
        
        if enable && index == nil{
            urlProtocolClasses!.insert(protocolClassNetGuard, at: 0)
        }
        else if !enable && index != nil{
            urlProtocolClasses!.remove(at: index!)
        }
        sessionConfiguration.protocolClasses = urlProtocolClasses
    }
    
    private func addObserverShowNetGuard() {
        NotificationCenter.default.addObserver(forName: RequestNotifications.showNetGuardRequestNotification, object: nil, queue: nil) { (notification) in
            self.presentNetGuardUI()
        }
    }
    /// shakeEnabled should be false for performing this method
    @objc public func showNetGuard() {
        guard !NetGuard.shakeEnabled && NetGuard.enabled else { return }
        NotificationCenter.default.post(name: RequestNotifications.showNetGuardRequestNotification, object: nil)
    }
    
    @objc public func loadNetGuard() {
        addObserverShowNetGuard()
        NetGuard.enable(true)
    }
    
    func presentNetGuardUI() {
        if let topVC = UIApplication.topViewController(), !topVC.isKind(of: BaseNC.classForCoder()) {
            let vc = NetGuardRequestListVC()
            let nc = BaseNC(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            topVC.present(nc, animated: true, completion: nil)
        }
    }
}

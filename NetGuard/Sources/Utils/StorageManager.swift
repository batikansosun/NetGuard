//
//  StorageManager.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 23.01.2021.
//

import Foundation

open class StorageManager: NSObject {
    public static let shared: StorageManager = StorageManager()
    public static var requestLimit: NSNumber? = nil
    public var requests: [RequestModel] = []
    func saveRequest(request: RequestModel?){
        guard request != nil else { return }
        if let index = requests.firstIndex(where: { (req) -> Bool in
            return request?.id == req.id ? true : false
        }){
            requests[index] = request!
        }else{
            requests.insert(request!, at: 0)
        }
        if let limit = Self.requestLimit?.intValue {
            requests = Array(requests.prefix(limit))
        }
        NotificationCenter.default.post(name: RequestNotifications.fetchNewRequestNotification, object: nil)
    }
    func clearRequests() {
        requests.removeAll()
    }
}

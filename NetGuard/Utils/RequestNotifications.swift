//
//  RequestNotifications.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 23.01.2021.
//

import Foundation

public struct RequestNotifications {
    public static let showNetGuardRequestNotification = NSNotification.Name(rawValue: "ShowNetGuardRequestNotification")
    public static let fetchNewRequestNotification      = NSNotification.Name(rawValue: "FetchNewRequestNotification")
}


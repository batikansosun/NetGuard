//
//  SectionModel.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 24.01.2021.
//

import Foundation
import UIKit

struct SectionModel {
    var title: String
    var detail: NSMutableAttributedString
    var type: SectionModelType
    
    init(title: String, detail:NSMutableAttributedString, type: SectionModelType) {
        self.title = title
        self.detail = detail
        self.type = type
    }
}

enum SectionModelType:CustomStringConvertible {
    case summary
    case requestHeader
    case requestBody
    case responseHeader
    case responseBody
    
    var description: String{
        switch self {
        case .summary:
            return "Summary"
        case .requestHeader:
            return "Request Header Details"
        case .requestBody:
            return "Request Body Details"
        case .responseHeader:
            return "Response Header Details"
        case .responseBody:
            return "Response Body Details"
        }
    }
    
}

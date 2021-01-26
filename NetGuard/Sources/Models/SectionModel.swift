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
            return NSLocalizedString("Summary", comment: "")
        case .requestHeader:
            return NSLocalizedString("Request Header Details", comment: "")
        case .requestBody:
            return NSLocalizedString("Request Body Details", comment: "")
        case .responseHeader:
            return NSLocalizedString("Response Header Details", comment: "")
        case .responseBody:
            return NSLocalizedString("Response Body Details", comment: "")
        }
    }
    
}

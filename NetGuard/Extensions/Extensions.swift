//
//  Extensions.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 23.01.2021.
//

import Foundation
import  UIKit

@objc private extension URLSessionConfiguration {
    private static var isFirstTime = true
    static func netGuardEngineStarter(){
        guard isFirstTime else { return }
        isFirstTime = false
        
        swizzleProtocolSetter()
        swizzleDefault()
        swizzleEphemeral()
    }
    
    private static func swizzleProtocolSetter() {
        let instance = URLSessionConfiguration.default
        
        let aClass: AnyClass = object_getClass(instance)!
        
        let origSelector = #selector(setter: URLSessionConfiguration.protocolClasses)
        let newSelector = #selector(setter: URLSessionConfiguration.protocolClasses_Swizzled)
        
        let origMethod = class_getInstanceMethod(aClass, origSelector)!
        let newMethod = class_getInstanceMethod(aClass, newSelector)!
        
        method_exchangeImplementations(origMethod, newMethod)
    }
    
    @objc private var protocolClasses_Swizzled: [AnyClass]? {
        get { return self.protocolClasses_Swizzled }
        set {
            guard let newTypes = newValue else { self.protocolClasses_Swizzled = nil; return }
            var types = [AnyClass]()
            for newType in newTypes {
                if !types.contains(where: { (existingType) -> Bool in
                    existingType == newType
                }) {
                    types.append(newType)
                }
            }
            self.protocolClasses_Swizzled = types
        }
    }
    
    private static func swizzleDefault() {
        let aClass: AnyClass = object_getClass(self)!
        let origSelector = #selector(getter: URLSessionConfiguration.default)
        let newSelector = #selector(getter: URLSessionConfiguration.default_swizzled)
        let origMethod = class_getClassMethod(aClass, origSelector)!
        let newMethod = class_getClassMethod(aClass, newSelector)!
        method_exchangeImplementations(origMethod, newMethod)
    }
    
    private static func swizzleEphemeral() {
        let aClass: AnyClass = object_getClass(self)!
        let origSelector = #selector(getter: URLSessionConfiguration.ephemeral)
        let newSelector = #selector(getter: URLSessionConfiguration.ephemeral_swizzled)
        let origMethod = class_getClassMethod(aClass, origSelector)!
        let newMethod = class_getClassMethod(aClass, newSelector)!
        method_exchangeImplementations(origMethod, newMethod)
    }
    
    @objc private class var default_swizzled: URLSessionConfiguration {
        get{
            let config = URLSessionConfiguration.default_swizzled
            config.protocolClasses?.insert(NetGuardHTTPProtocol.self, at: 0)
            return config
        }
    }
    
    @objc private class var ephemeral_swizzled: URLSessionConfiguration{
        get{
            let config = URLSessionConfiguration.ephemeral_swizzled
            config.protocolClasses?.insert(NetGuardHTTPProtocol.self, at: 0)
            return config
        }
    }
}

extension UITableView {
    convenience init(style: UITableView.Style, forAutoLayout:Bool = true) {
        self.init(frame: .zero, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
extension UILabel{
    convenience init(forAutoLayout:Bool = true) {
        self.init(frame:.zero)
        self.translatesAutoresizingMaskIntoConstraints = !forAutoLayout
    }
}

extension UIView{
    convenience init(autoLayout:Bool) {
        self.init(frame:.zero)
        self.translatesAutoresizingMaskIntoConstraints = !autoLayout
    }
}

extension UITextView{
    convenience init(forAutoLayout:Bool = true) {
        self.init(frame:.zero)
        self.translatesAutoresizingMaskIntoConstraints = !forAutoLayout
    }
}

extension UIButton{
    convenience init(forAutoLayout:Bool = true) {
        self.init(type:.system)
        self.translatesAutoresizingMaskIntoConstraints = !forAutoLayout
    }
}


extension UIApplication{
    static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topViewController = keyWindow?.rootViewController {
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            return  topViewController
        }
        return nil
    }
}

extension UIViewController{
    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake && NetGuard.enabled && NetGuard.shakeEnabled {
            NotificationCenter.default.post(name: RequestNotifications.showNetGuardRequestNotification, object: nil)
        }
        
        next?.motionBegan(motion, with: event)
    }
}

extension UIColor{
    convenience init(hexString:String) {
        let hexString:String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as String
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return NSString(format:"#%06x", rgb) as String
    }
    
    func randomGreyColor() -> String{
        let value = arc4random_uniform(255)
        let grayscale = (value << 16) | (value << 8) | value;
        let color = "#" + String(grayscale, radix: 16);
        
        return color
    }
    
    static var successful:UIColor {
        return UIColor(hexString: "#297E4C")
    }
    static var redirection:UIColor {
        return UIColor(hexString: "#3D4140")
    }
    static var clientError:UIColor {
        return UIColor(hexString: "#f60c0c")
    }
    static var serverError:UIColor {
        return UIColor(hexString: "#D32C58")
    }
    static var generic:UIColor {
        return UIColor(hexString: "#999999")
    }
    static var genericLightGray:UIColor {
        return UIColor(hexString: "#f0efed")
    }
    
}

extension NSMutableAttributedString {
    @discardableResult func fontBold15(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 15)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func fontBoldGray15(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 15), .foregroundColor:UIColor.lightGray]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func font14(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
        let normal = NSMutableAttributedString(string:text, attributes: attrs)
        append(normal)
        return self
    }
    
    func chageTextColor(to color: UIColor) -> NSMutableAttributedString {
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: NSRange(location: 0,length: string.count))
        return self
    }
}

extension Dictionary {
    var prettyPrintedJSON: String? {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch _ {
            return nil
        }
    }
}

extension String {
    func characters(n: Int) -> String {
        return String(prefix(n))
    }
    
    var prettyPrintedJSON: String? {
        guard let data = self.data(using: .utf8),
              let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let formattedJSON = String(data: jsonData, encoding: .utf8) else { return nil }
        
        return formattedJSON.replacingOccurrences(of: "\\/", with: "/")
    }
}

extension RequestModel {
    var summary:NSMutableAttributedString {
        let final = NSMutableAttributedString()
        let request = self
        let url = NSMutableAttributedString().fontBold15(NSLocalizedString("Request URL ", comment: "")).font14(request.url + "\n")
        let method = NSMutableAttributedString().fontBold15(NSLocalizedString("Request HTTP Method ", comment: "")).font14(request.method + "\n")
        let responseCode = NSMutableAttributedString().fontBold15(NSLocalizedString("Request HTTP Code ", comment: "")).font14((request.code != 0 ? "\(request.code)" : "-") + "\n")
        let requestStartTime = NSMutableAttributedString().fontBold15(NSLocalizedString("Request Start Time ", comment: "")).font14((request.date.getStrDate() ?? "-" + "\n") + "\n")
        let duration = NSMutableAttributedString().fontBold15(NSLocalizedString("Request Time Duration ", comment: "")).font14(request.duration?.formattedMilliseconds() ?? "-" + "\n")
        for attrStr in [url, method, responseCode, requestStartTime, duration] {
            final.append(attrStr)
        }
        return final
    }
    var responseHeaderAttrText:NSMutableAttributedString {
        let headerDictionary = self.responseHeaders ?? ["":""]
        let final = NSMutableAttributedString()
        for (key, value) in headerDictionary {
            final.append(NSMutableAttributedString().fontBold15(key).font14(" " + value + "\n"))
        }
        return final
    }
    var requestHeaderAttrText:NSMutableAttributedString {
        let headerDictionary = self.headers
        let final = NSMutableAttributedString()
        for (key, value) in headerDictionary {
            final.append(NSMutableAttributedString().fontBold15(key).font14(" " + value + "\n"))
        }
        return final
    }
    var exportRequestDetails:String {
        let request = self
        return " \(SectionModelType.summary.description) \n  \(request.summary.string)  \n\n  \(SectionModelType.requestHeader.description) \n   \(request.requestHeaderAttrText.string) \n\n \(SectionModelType.requestBody.description) \n  \(request.httpBody.convertToStr)   \n\n   \(SectionModelType.responseHeader.description) \n  \(request.responseHeaderAttrText.string)  \n\n  \(SectionModelType.responseBody.description) \n  \(request.dataResponseAttrText) \n\n"
    }
    
    var dataResponseAttrText:NSMutableAttributedString {
        if let json = self.dataResponse?.prettyPrintedJSONString {
            return NSMutableAttributedString().font14(json)
        }
        if let htmlOrPlainText = self.dataResponse?.printedNotValidJSONString {
            return NSMutableAttributedString().font14(htmlOrPlainText)
        }
        return NSMutableAttributedString(string: "")
        
    }
    var dataRequestAttrText:NSMutableAttributedString {
        let text = NSMutableAttributedString().font14(self.httpBody?.prettyPrintedJSONString ?? "")
        return text
    }
}

extension Date {
    func getStrDate() -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d yyyy - HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}

extension Optional where Wrapped == Data{
    var convertToStr: String {
        if let data = self, let str = String(data: data, encoding: .utf8) {
            return str
        }
        return ""
    }
    
}

extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }
        
        return prettyPrintedString
    }
    
    var printedNotValidJSONString: String? {
        return String(data: self, encoding: .utf8)
    }
}

extension Double {
    func formattedMilliseconds() -> String {
        
        let rounded = self
        if rounded < 1000 {
            return "\(Int(rounded))ms"
        } else if rounded < 1000 * 60 {
            let seconds = rounded / 1000
            return "\(Int(seconds))s"
        } else if rounded < 1000 * 60 * 60 {
            let secondsTemp = rounded / 1000
            let minutes = secondsTemp / 60
            let seconds = (rounded - minutes * 60 * 1000) / 1000
            return "\(Int(minutes))m \(Int(seconds))s"
        } else if self < 1000 * 60 * 60 * 24 {
            let minutesTemp = rounded / 1000 / 60
            let hours = minutesTemp / 60
            let minutes = (rounded - hours * 60 * 60 * 1000) / 1000 / 60
            let seconds = (rounded - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            return "\(Int(hours))h \(Int(minutes))m \(Int(seconds))s"
        } else {
            let hoursTemp = rounded / 1000 / 60 / 60
            let days = hoursTemp / 24
            let hours = (rounded - days * 24 * 60 * 60 * 1000) / 1000 / 60 / 60
            let minutes = (rounded - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000) / 1000 / 60
            let seconds = (rounded - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            return "\(Int(days))d \(Int(hours))h \(Int(minutes))m \(Int(seconds))s"
        }
    }
}

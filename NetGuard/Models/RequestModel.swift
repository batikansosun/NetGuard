//
//  RequestModel.swift
//  NetGuard
//
//  Created by Batıkan SOSUN on 23.01.2021.
//

import Foundation
import UIKit

open class RequestModel: Codable {
    public let id: String
    public let url: String
    public let host: String?
    public let port: Int?
    public let scheme: String?
    public let date: Date
    public let method: String
    public let headers: [String: String]
    public var credentials: [String : String]
    public var cookies: String?
    open var httpBody: Data?
    open var code: Int
    open var responseHeaders: [String: String]?
    open var dataResponse: Data?
    open var errorClientDescription: String?
    open var duration: Double?
    
    init(request: NSURLRequest, session: URLSession?) {
        id = UUID().uuidString
        url = request.url?.absoluteString ?? ""
        host = request.url?.host
        port = request.url?.port
        scheme = request.url?.scheme
        date = Date()
        method = request.httpMethod ?? "GET" // The default HTTP method is “GET”.
        credentials = [:]
        var headers = request.allHTTPHeaderFields ?? [:]
        httpBody = request.httpBody
        code = 0

        session?.configuration.httpAdditionalHeaders?
            .filter {  $0.0 != AnyHashable("Cookie") }
            .forEach { element in
                guard let key = element.0 as? String, let value = element.1 as? String else { return }
                headers[key] = value
        }
        self.headers = headers
        
        if let credentialStorage = session?.configuration.urlCredentialStorage,
            let host = self.host,
            let port = self.port {
            let protectionSpace = URLProtectionSpace(
                host: host,
                port: port,
                protocol: scheme,
                realm: host,
                authenticationMethod: NSURLAuthenticationMethodHTTPBasic
            )

            if let credentials = credentialStorage.credentials(for: protectionSpace)?.values {
                for credential in credentials {
                    guard let user = credential.user, let password = credential.password else { continue }
                    self.credentials[user] = password
                }
            }
        }
        if let session = session, let url = request.url, session.configuration.httpShouldSetCookies {
            if let cookieStorage = session.configuration.httpCookieStorage,
                let cookies = cookieStorage.cookies(for: url), !cookies.isEmpty {
                self.cookies = cookies.reduce("") { $0 + "\($1.name)=\($1.value);" }
            }
        }
    }
    
    func initResponse(response: URLResponse) {
        guard let responseHttp = response as? HTTPURLResponse else {return}
        code = responseHttp.statusCode
        responseHeaders = responseHttp.allHeaderFields as? [String: String]
    }
}

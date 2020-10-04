//
//  URLRequestFactory.swift
//  Networking
//
//  Created by Duy Tran on 7/12/20.
//

import Foundation

public protocol URLRequestFactory {
    
    var host: String { get set }
    var cachePolicy: URLRequest.CachePolicy { get set }
    var timeoutInterval: TimeInterval { get set }
    
    func make(endpoint: Endpoint) throws -> URLRequest
}

public struct DefaultURLRequestFactory: URLRequestFactory {
    
    public var host: String
    public var cachePolicy: URLRequest.CachePolicy
    public var timeoutInterval: TimeInterval
    
    public init(
        host: String,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 60) {
        self.host = host
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
    }
    
    public func make(endpoint: Endpoint) throws -> URLRequest {
        let path = endpoint.path
        guard let url = URL(string: host + path) else {
            throw NetworkingError.invalidURL(host)
        }
        var request = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval)
        request.allHTTPHeaderFields = endpoint.headers
        request.httpMethod = endpoint.method.rawValue.uppercased()
        request.httpBody = try endpoint.body()
        return request
    }
}

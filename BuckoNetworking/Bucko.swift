//
//  Bucko.swift
//  Networking
//
//  Created by Chayel Heinsen on 2/6/17.
//  Copyright © 2017 Teeps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public protocol BuckoErrorHandler {
    func buckoRequest(request: URLRequest, error: Error)
}

public typealias BuckoResponseClosure = ((DataResponse<Any>) -> Void)
public typealias HttpMethod = HTTPMethod
public typealias HttpHeaders = HTTPHeaders
public typealias Encoding = ParameterEncoding
public typealias UrlEncoding = URLEncoding
public typealias JsonEncoding = JSONEncoding
public typealias Body = Parameters
public typealias Json = JSON

public struct Bucko {
    /**
     Can be overriden to configure the session manager.
     e.g - Creating server trust policies
     ```
     let manager: SessionManager = {
         // Create the server trust policies
         let serverTrustPolicies: [String: ServerTrustPolicy] = [
             "0.0.0.0": .disableEvaluation // Use your server obviously. Can be a url as well, example.com
         ]
         // Create custom manager
         let configuration = URLSessionConfiguration.default
         configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
         let manager = SessionManager(
         configuration: URLSessionConfiguration.default,
         serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
         )
         return manager
     }()
     
     Bucko.shared.manager = manager

     ```
    */
    public var manager: SessionManager = SessionManager()
    public static let shared = Bucko()
    public var delegate: BuckoErrorHandler?
    
    /**
     Make API requests
     
     Example:
     
     ```
     let request = Bucko.shared.request(.getUser(id: "1")) { response in
        if let response.result.isSuccess {
            let json = JSON(response.result.value!)
        } else {
            // Handle error
        }
     ```
     
      - parameter endpoint:   The endpoint to use.
      - parameter completion: The closure that will return the response from the server.
      - returns: The request that was made.
     */
    @discardableResult
    public func request(endpoint: Endpoint, completion: @escaping BuckoResponseClosure) -> Request {
        let request = manager.request(
            endpoint.fullURL,
            method: endpoint.method,
            parameters: endpoint.body,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        ).responseJSON { response in
            
            if response.result.isSuccess {
                debugPrint(response.result.description)
            } else {
                debugPrint(response.result.error ?? "Error")
                // Can globably handle errors here if you want
                if let urlRequest = response.request, let error = response.result.error {
                    self.delegate?.buckoRequest(request: urlRequest, error: error)
                }
            }
            
            completion(response)
        }
        
        print(request.description)
        return request
    }
}

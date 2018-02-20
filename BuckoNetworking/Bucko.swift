//
//  Bucko.swift
//  Networking
//
//  Created by Chayel Heinsen on 2/6/17.
//  Copyright © 2017 Teeps. All rights reserved.
//

import Foundation
import Alamofire

public protocol BuckoErrorHandler: class {
  func buckoRequest(request: URLRequest, error: Error)
}

public typealias BuckoResponseClosure = ((DataResponse<Any>) -> Void)
public typealias BuckoDataResponseClosure = ((DataResponse<Data>) -> Void)

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
  public weak var delegate: BuckoErrorHandler?
  
  public init() {
  }
  
  /**
   Make API requests. Use this to handle responses with your own response closure. The example
   uses responseData to handle the response. If you are expecting JSON, you should
   use `Bucko.shared.request(endpoint:,completion:)` instead.
   
   Example:
   
   ```
   let request = Bucko.shared.request(.getUser(id: "1"))
   request.responseData { response in
   
   if response.result.isSuccess {
    debugPrint(response.result.description)
    } else {
    debugPrint(response.result.error ?? "Error")
    }
   }
   ```
   
   - parameter endpoint:   The endpoint to use.
   - returns: The request that was made.
   */
  public func request(endpoint: Endpoint) -> DataRequest {
    let request = manager.request(
      endpoint.fullURL,
      method: endpoint.method,
      parameters: endpoint.body,
      encoding: endpoint.encoding,
      headers: endpoint.headers
    )
    
    print(request.description)
    return request
  }
  
  /**
   Make API requests with JSON response.
   
   Example:
   
   ```
   let request = Bucko.shared.request(.getUser(id: "1")) { response in
   
   if let response.result.isSuccess {
    let json = JSON(response.result.value!)
   } else {
    let error = JSON(data: response.data)
   }
   ```
   
   - parameter endpoint:   The endpoint to use.
   - parameter completion: The closure that will return the response from the server.
   - returns: The request that was made.
   */
  @discardableResult
  public func request(endpoint: Endpoint, completion: @escaping BuckoResponseClosure) -> DataRequest {
    let request = self.request(endpoint: endpoint).validate().responseJSON { response in
        
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
  
  @discardableResult
  public func requestData(endpoint: Endpoint, completion: @escaping BuckoDataResponseClosure) -> DataRequest {
    let request = self.request(endpoint: endpoint).validate().responseData { response in
      
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
  
  public func request(endpoint: Endpoint) -> Promise<DataResponse<Any>> {
    return Promise { seal in
      request(endpoint: endpoint) { response in
        
        if response.result.isSuccess {
          seal.fulfill(response)
        } else {
          if let responseError = response.result.value {
            do {
              let json = try JSONSerialization.data(withJSONObject: responseError, options: [])
              seal.reject(BuckoError(apiError: json))
            } catch {
              seal.reject(response.result.error!)
            }
          } else {
            seal.reject(response.result.error!)
          }
        }
      }
    }
  }
  
  public func requestData(endpoint: Endpoint) -> Promise<Data> {
    return Promise { seal in
      requestData(endpoint: endpoint) { response in
        
        if response.result.isSuccess {
          seal.fulfill(response.result.value!)
        } else {
          
          if let responseError = response.result.value {
            seal.reject(BuckoError(apiError: responseError))
          } else {
            seal.reject(response.result.error!)
          }
        }
      }
    }
  }
}

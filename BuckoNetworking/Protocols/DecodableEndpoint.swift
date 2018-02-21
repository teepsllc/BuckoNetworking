//
//  JSONDecodableEndpoint.swift
//  Networking
//
//  Created by Chayel Heinsen on 2/7/17.
//  Copyright © 2017 Teeps. All rights reserved.
//

import Alamofire

public protocol DecodableEndpoint: Endpoint {
  associatedtype ResponseType: Decodable
}

public extension DecodableEndpoint {
  @discardableResult
  public func request(completion: @escaping ((ResponseType?, DataResponse<Data>) -> Void)) -> Request {
    let request = Bucko.shared.requestData(endpoint: self) { response in
      
      if response.result.isSuccess {
        guard let value = response.result.value else { return }
        
        do {
          let result = try JSONDecoder().decode(ResponseType.self, from: value)
          completion(result, response)
        } catch {
          debugPrint(error)
          completion(nil, response)
        }
      } else {
        completion(nil, response)
      }
    }
    
    return request
  }
}

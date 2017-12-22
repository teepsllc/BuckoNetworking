//
//  JSONDecodableEndpoint.swift
//  Networking
//
//  Created by Chayel Heinsen on 2/7/17.
//  Copyright © 2017 Teeps. All rights reserved.
//

import Alamofire

public protocol DecodableEndpoint: Endpoint {
  associatedtype Response: Decodable
}

public extension DecodableEndpoint {
  @discardableResult
  public func request(completion: @escaping ((Response?, Error?) -> Void)) -> Request {
    let request = Bucko.shared.requestData(endpoint: self) { response in
      
      if response.result.isSuccess {
        guard let value = response.result.value else { return }
        
        do {
          let result = try JSONDecoder().decode(Response.self, from: value)
          completion(result, nil)
        } catch {
          debugPrint(error)
          completion(nil, error)
        }
      } else {
        completion(nil, response.result.error)
      }
    }
    
    return request
  }
}

struct User: Decodable {
  var name: String
  var phoneNumber: String
  
  enum CodingKeys: String, CodingKey {
    case name
    case phoneNumber = "phone_number"
  }
}

struct UserService: DecodableEndpoint {
  typealias Response = User
  var baseURL: String { return "https://example.com" }
  var path: String { return "/users" }
  var method: HTTPMethod { return .get }
  var body: Parameters { return Parameters() }
  var headers: HTTPHeaders { return HTTPHeaders() }
}

//UserService().request { (user, error) in
//  guard let user = user else {
//    // Do Error
//    return
//  }
//
//  // Do something with user
//}

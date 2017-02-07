//
//  JSONDecodableEndpoint.swift
//  Networking
//
//  Created by Chayel Heinsen on 2/7/17.
//  Copyright © 2017 Teeps. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol JSONDecodableEndpoint: Endpoint {
    associatedtype Response
    associatedtype JSONType
    /**
     parseJSON(_:) should call an object that conforms to JSONDecodable
     */
    func parseJSON(_ json: JSONType) throws -> Response
}

extension JSONDecodableEndpoint {
    func request(completion: @escaping ((Response?, Error?) -> Void)) -> Request {
        let request = Bucko.shared.request(endpoint: self) { response in
            
            if response.result.isSuccess {
                guard let json = JSON(response.result.value!) as? JSONType else {
                    completion(nil, BuckoError.invalidAPIResponse())
                    return
                }
                
                do {
                    let result = try self.parseJSON(json)
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

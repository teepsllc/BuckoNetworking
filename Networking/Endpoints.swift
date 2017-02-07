//
//  Endpoints.swift
//  Networking
//
//  Created by Chayel Heinsen on 2/6/17.
//  Copyright © 2017 Teeps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// Same user class
class User: CustomStringConvertible, CustomDebugStringConvertible {
    var firstName: String = "Chayel"
    var lastName: String = "Heinsen"
    var id: String = "1"
    var description: String {
        return "\(id) : \(firstName) \(lastName)"
    }
    
    var debugDescription: String {
        return description
    }
}

// Because Endpoint is a protocol, it can be used with a struct or class if you don't
// want to use an enum
enum UserEndpoint: Endpoint {
    case getUsers
    case getUser(id: String)
    case createUser(user: User)
    case updateUser(id: String)
  
    var path: String {
        switch self {
        case .getUsers: return "users/"
        case .getUser(let id): return "users/\(id)/"
        case .createUser: return "users/"
        case .updateUser(let id): return "users/\(id)/"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getUsers: return .get
        case .getUser: return .get
        case .createUser: return .post
        case .updateUser: return .patch
        }
    }
    
    var headers: HTTPHeaders {
        return ["Authorization" : "SOME_TOKEN"]
    }
    
    var body: Parameters {
        var body: Parameters = Parameters()
        
        switch self {
        case .createUser(let user):
            body["first_name"] = user.firstName
            body["last_name"] = user.lastName
        default:
            break
        }
        
        return body
    }
}

// You can also use JSONDecodableEndpoint to have request(completion:) automatically attempt to
// parse the response using your mapper. You should call an object that conforms to JSONDecodable
// in parseJSON(_:). See UserMapper.
//
// You can map the JSON to your object anyway you see fit, that is you don't
// absolutely need to conform to JSONDecodable.

// This will result in:
/*
 _ = UserDecodableEndpoint().request { (user, error) in
    // Viola!
    if let user = user {
        // user is the parse User
        print(user)
    }
 }
 */
struct UserDecodableEndpoint: JSONDecodableEndpoint {
    typealias Response = User
    typealias JSONType = JSON
    
    // MARK: - Endpoint
    var path: String = "users"
    var method: HTTPMethod = .get
    var headers: HTTPHeaders = ["Authorization" : "SOME_TOKEN"]
    
    func parseJSON(_ json: JSON) throws -> User {
        return try UserMapper().map(from: json)
    }
}

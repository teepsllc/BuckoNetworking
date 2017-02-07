//
//  BuckoTests.swift
//  Networking
//
//  Created by Chayel Heinsen on 2/7/17.
//  Copyright © 2017 Teeps. All rights reserved.
//

import XCTest
import Alamofire
import SwiftyJSON
@testable import Networking

class BuckoTests: XCTestCase {
    
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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testGetEndpoint() {
        let endpoint: UserEndpoint = .getUsers
        XCTAssertTrue(endpoint.method == .get, "Just ensuring this is a get request.")
        XCTAssertTrue(endpoint.body.keys.count == 0, "Parameters aren't required")
        XCTAssertTrue(endpoint.encoding is URLEncoding, "Encoding for get request should be set to URLEncoding")
        XCTAssertTrue(endpoint.fullURL == endpoint.baseURL + endpoint.path, "The fullURL shouldn't be changed.")
    }
    
    func testPostEndpoint() {
        let endpoint: UserEndpoint = .createUser(user: User())
        XCTAssertTrue(endpoint.method == .post, "Just ensuring this is a post request.")
        XCTAssertTrue(endpoint.encoding is JSONEncoding, "Encoding for post request should be set to JSONEncoding")
        XCTAssertTrue(endpoint.fullURL == endpoint.baseURL + endpoint.path, "The fullURL shouldn't be changed.")
    }
    
    func testJSONDecodableEndpointProtocol() {
        let endpoint = UserDecodableEndpoint()
        XCTAssertTrue(endpoint is Endpoint, "The fullURL shouldn't be changed.")
    }
    
}

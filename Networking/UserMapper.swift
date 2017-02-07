//
//  UserMapper.swift
//  Networking
//
//  Created by Chayel Heinsen on 2/7/17.
//  Copyright © 2017 Teeps. All rights reserved.
//
import SwiftyJSON

struct UserMapper: JSONDecodable {
    typealias Model = User
    
    func map(from json: JSON) throws -> Model {
        let user = User()
        user.id = json["id"].stringValue
        user.firstName = json["first_name"].stringValue
        user.lastName = json["last_name"].stringValue

        return user
    }
}

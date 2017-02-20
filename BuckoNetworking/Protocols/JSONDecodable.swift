//
//  JSONDecodable.swift
//  Networking
//
//  Created by Chayel Heinsen on 2/7/17.
//  Copyright © 2017 Teeps. All rights reserved.
//

public protocol JSONDecodable {
    associatedtype Model
    static func map(from json: Json) throws -> Model
}

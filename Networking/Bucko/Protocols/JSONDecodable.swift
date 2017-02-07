//
//  JSONDecodable.swift
//  Networking
//
//  Created by Chayel Heinsen on 2/7/17.
//  Copyright © 2017 Teeps. All rights reserved.
//

import SwiftyJSON

protocol JSONDecodable {
    associatedtype Model
    func map(from json: JSON) throws -> Model
}

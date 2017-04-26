//
//  Endpoint.swift
//  Networking
//
//  Created by Chayel Heinsen on 2/6/17.
//  Copyright © 2017 Teeps. All rights reserved.
//

/**
 Conform to Endpoint to create new endpoints to use with Bucko.
 You can create an extension to create default values. This is recommended for the baseURL.
 */
public protocol Endpoint {
  var baseURL: String { get } // https://example.com
  var path: String { get } // /users/
  
  /**
   This should **NOT** be set by the conforming type.
   This will automatically be set by the baseURL and the path.
   */
  var fullURL: String { get }
  var method: HttpMethod { get }
  
  /**
   By default, encoding will be set to URLEncoding for GET requests
   and JSONEncoding for everything else.
   You should override encoding if you need to customize this.
   
   JSONEncoding.default
   URLEncoding.default
   PropertyListEncoding.default
   You can also create your own.
   */
  var encoding: Encoding { get }
  
  /**
   By default this will be set to empty - Parameters()
   */
  var body: Body { get }
  
  /**
   Authorization is usually set in the headers. You can set this to `[:]` if you don't have any
   headers to set. You can also create an extention on Endpoint to also have
   this default to a value.
   */
  var headers: HttpHeaders { get }
}

public extension Endpoint {
  var encoding: Encoding {
    return method == .get ? UrlEncoding.default : JsonEncoding.default
  }
  
  var fullURL: String {
    return baseURL + path
  }
  
  var body: Body {
    return Body()
  }
}

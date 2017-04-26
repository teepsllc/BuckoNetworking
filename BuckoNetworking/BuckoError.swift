//
//  BuckoError.swift
//  Networking
//
//  Created by Chayel Heinsen on 2/7/17.
//  Copyright © 2017 Teeps. All rights reserved.
//

import Foundation.NSError

public final class BuckoError: NSError {
  
  fileprivate enum Code: Int {
    case api = 1
    case validation
    case service // an error caused by a third party service
    case jsonMapping // an error caused by inability to map json responses
    case auth
    case unknown
  }
  
  fileprivate static var domain: String {
    return Bundle.main.bundleIdentifier!
  }
  
  // MARK: - Convenience error initializers
  convenience init(apiError reason: String, description: String? = nil) {
    self.init(code: .api, reason: reason, description: description)
  }
  
  convenience init(validationError reason: String, description: String? = nil) {
    self.init(code: .validation, reason: reason, description: description)
  }
  
  convenience init(serviceError reason: String) {
    self.init(code: .service, reason: reason)
  }
  
  convenience init(mappingErrorKey key: String) {
    self.init(
      code: .jsonMapping,
      reason: "An unknown error occurred",
      description: "Could not parse value for key \(key)"
    )
  }
  
  convenience init(authError reason: String, description: String) {
    self.init(code: .auth, reason: reason, description: description)
  }
  
  fileprivate convenience init(code: Code, reason: String, description: String? = nil) {
    self.init(domain: BuckoError.domain, code: code.rawValue, userInfo: [
      NSLocalizedFailureReasonErrorKey: reason,
      NSLocalizedDescriptionKey: description ?? reason
      ])
  }
  
  // MARK: - Common errors
  static func invalidAPIResponse() -> BuckoError {
    return BuckoError(apiError: "An unknown error occurred", description: "Invalid Response")
  }
  
  static func unknown() -> BuckoError {
    return BuckoError(code: .unknown, reason: "An unknown error occurred")
  }
  
}

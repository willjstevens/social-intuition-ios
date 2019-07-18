//
//  Response.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation
import EVReflection

//
// Generic type modeled after: 
//      https://github.com/evermeer/EVReflection/blob/master/UnitTests/EVReflectionTests/EVReflectionWorkaroundSwiftGenericsTests.swift
//
class Response<T>: SiObject, EVGenericsKVC where T: NSObject {
    var success: Bool = false
    var message: String?
    var code: Int? = -1
    var error: String?
    var targetUrl: String?
    var lastUpdateTimestamp: String?
    var data: T? = T()
    
    required public init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getGenericType() -> NSObject {
        return T()
    }

    public func setGenericValue(_ value: AnyObject!, forUndefinedKey key: String) {
        switch key {
        case "data":
            data = value as? T ?? T()
        default:
            print("---> setValue '\(String(describing: value))' for key '\(key)' should be handled.")
        }
    }
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "success":
            success = value as! Bool
        case "message":
            message = value as? String
        case "code":
            code = value as? Int
        case "error":
            error = value as? String
        case "targetUrl":
            targetUrl = value as? String
        case "lastUpdateTimestamp":
            lastUpdateTimestamp = value as? String
         case "data":
            data = value as? T
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}

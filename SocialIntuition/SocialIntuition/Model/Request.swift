//
//  Request.swift
//  SocialIntuition
//
//  Created by Will Stevens on 3/27/17.
//  Copyright © 2017 Will Stevens. All rights reserved.
//

import Foundation
import EVReflection

class Request<T>: SiObject, EVGenericsKVC where T:NSObject {
    
    var data: T? = T()
    var intuitionId: String?
    var commentId: String?
    var guest: Bool? = false
    
    required public init() {
        super.init()
    }
    
    convenience init(_ intuitionId: String?) {
        self.init()
        self.intuitionId = intuitionId
    }
    
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getGenericType() -> NSObject {
        return T()
    }
    
    public func setGenericValue(_ value: AnyObject!) {
        self.setGenericValue(value, forUndefinedKey: "data")
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
        case "intuitionId":
            intuitionId = value as? String
        case "commentId":
            commentId = value as? String
        case "guest":
            guest = value as? Bool
        case "data":
            data = value as? T
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}

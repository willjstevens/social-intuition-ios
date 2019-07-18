//
//  RequestWithString.swift
//  SocialIntuition
//
//  Created by Will Stevens on 6/6/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation

class RequestWithString: SiObject {
    
    var data: String?
    var intuitionId: String?
    var commentId: String?
    var guest: Bool? = false
    
    required public init() {
    }
    
    convenience init(_ intuitionId: String?) {
        self.init()
        self.intuitionId = intuitionId
    }
    
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            data = value as? String
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}

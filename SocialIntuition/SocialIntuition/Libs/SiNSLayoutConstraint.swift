//
//  SiNSLayoutConstraint.swift
//  SocialIntuition
//
//  Created by Will Stevens on 7/1/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation
import UIKit

class SiNSLayoutConstraint: NSLayoutConstraint {
    var originalValue: CGFloat = 0

    func siHide() {
        originalValue = self.constant
        self.constant = 0
    }
    
    func siShow() {
        self.constant = originalValue
        originalValue = 0
    }
}

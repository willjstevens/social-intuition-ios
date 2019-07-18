//
//  SiObject.swift
//  SocialIntuition
//
//  Created by Will Stevens on 10/3/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation
import EVReflection

class SiObject: EVObject {

    
//    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        /*
         * Needed for EVReflection JSON de/serialization
         *
         * See:
         *
         * 1. https://github.com/evermeer/EVReflection#known-issues
         * 2. https://github.com/evermeer/EVReflection/issues/115
         * 3. https://github.com/evermeer/EVReflection/blob/ddb5bc7c754a388745457610a5b087b9ba4d4fec/EVReflection/EVReflectionTests/EVReflectionConversionOptionsTest.swift
         *
         *
         This empty method is needed to avoid this type of error:
         
         WARNING: The class 'DeviceLoginDto' is not key value coding-compliant for the key 'user'
         There is no support for optional type, array of optionals or enum properties.
         As a workaround you can implement the function 'setValue forUndefinedKey' for this. See the unit tests for more information
         
         ---> setValue 'Optional(1)' for key 'success' should be handled.

         */
//    }

}

//
//  Settings.swift
//  Social Intuition
//
//  Created by Will Stevens on 1/1/17.
//  Copyright © 2017 Will Stevens. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// taken from https://learnappdevelopment.com/uncategorized/how-to-use-core-data-in-ios-10-swift-3/
// and https://code.tutsplus.com/tutorials/core-data-and-swift-managed-objects-and-fetch-requests--cms-25068


class Settings {
    private let UNINITIALIZED = "UNINITIALIZED"
    static let settings = Settings()
    
    private func getAppDelegate () -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private func getContext () -> NSManagedObjectContext {
        return getAppDelegate().persistentContainer.viewContext
    }
    
    func getUserId () -> String {
        var userId: String = UNINITIALIZED
        if let setting = getSiSettings()?.userId {
            userId = setting
        }
        return userId
    }
    
    func getDeviceId () -> String {
        var deviceId: String = UNINITIALIZED
        if let setting = getSiSettings()?.deviceId {
            deviceId = setting
        }
        return deviceId
    }
    
    func isUserIdInitialized () -> Bool {
        return getUserId() != UNINITIALIZED
    }
    
    func isDeviceIdInitialized () -> Bool {
        return getDeviceId() != UNINITIALIZED
    }
    
    func saveUserId(value: String) {
        saveStringValue(key: "userId", value: value)
    }
    
    func saveDeviceId(value: String) {
        saveStringValue(key: "deviceId", value: value)
    }
    
    func removeUserId() {
        saveUserId(value: UNINITIALIZED)
        getSiSettings()?.userId = nil
    }
    
    func removeDeviceId() {
        saveDeviceId(value: UNINITIALIZED)
        getSiSettings()?.deviceId = nil
    }
    
    private func saveStringValue (key: String, value: String) {
        let context = getContext()
        let siSettings = getSiSettings()!
        siSettings.setValue(value, forKey: key)
        
        do {
            try context.save()
//            print("Saved key \"\(key)\" with value \"\(value)\".")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    private func getSiSettings () -> SiSettings? {
        var retval: SiSettings?
        let fetchRequest: NSFetchRequest<SiSettings> = SiSettings.fetchRequest()
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            if (searchResults.count == 0) {
                // if no results then we need to create it
                let context = getContext()
                let entity =  NSEntityDescription.entity(forEntityName: "SiSettings", in: context)
                let sis = NSManagedObject(entity: entity!, insertInto: context)
                print("Entity created for \(String(describing: sis.entity.name))")
                
                // now try to fetch newly created class
                let searchResultsNew = try getContext().fetch(fetchRequest)
                retval = searchResultsNew.first
            } else if (searchResults.count == 1) {
                // if one result then get it; there should only be one
                retval = searchResults.first
            }
            
            // print out info
//            print ("num of results = \(searchResults.count)")
//            for setting in searchResults as [NSManagedObject] {
//                print("userId: \(setting.value(forKey: "userId"))")
//                print("deviceId: \(setting.value(forKey: "deviceId"))")
//            }
        } catch {
            print("Error with getting SiSettings object: \(error)")
        }
        
        return retval
    }


//    func deleteStringValue (key: String) {
//        let context = getContext()
//        let siSettings = getSiSettings()!
//        
//        //set the entity values to NIL
//        siSettings.setValue(nil, forKey: key)
//        
//        do {
//            try context.save()
//            print("Deleted key \(key) and value.")
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//    }

    
    
}




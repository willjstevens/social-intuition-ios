//
//  Enums.swift
//  SocialIntuition
//
//  Created by Will Stevens on 4/22/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation

protocol KeyBasedEnum {
    var key: String { get }
    static func toIndex(_ keyString: String) -> Int
    static func toKey(_ index: Int) -> String
    static func toLabel(_ keyString: String) -> String
}

enum Visibility: Int, KeyBasedEnum {
    
    case Public = 0
    case Cohort = 1
    case Private = 2
    
    var key: String {
        switch self {
        case .Public:
            return "public"
        case .Cohort:
            return "cohort"
        case .Private:
            return "private"
        }
    }
    
    static func toIndex(_ keyString: String) -> Int {
        switch keyString {
        case Visibility.Public.key:
            return Visibility.Public.rawValue
        case Visibility.Cohort.key:
            return Visibility.Cohort.rawValue
        case Visibility.Private.key:
            return Visibility.Private.rawValue
        default:
            return -1
        }
    }
    
    static func toLabel(_ keyString: String) -> String {
        switch keyString {
        case Visibility.Public.key:
            return "Public"
        case Visibility.Cohort.key:
            return "Cohort"
        case Visibility.Private.key:
            return "Private"
        default:
            return "unknown"
        }
    }
    
    static func toKey(_ index: Int) -> String {
        switch index {
        case Visibility.Public.rawValue:
            return "public"
        case Visibility.Cohort.rawValue:
            return "cohort"
        case Visibility.Private.rawValue:
            return "private"
        default:
            return "unknown"
        }
    }
}

enum PredictionType: Int, KeyBasedEnum {
    
    case TrueFalse = 0
    case YesNo = 1
    case MultipleChoice = 2
    
    var key: String {
        switch self {
        case .TrueFalse:
            return "true-false"
        case .YesNo:
            return "yes-no"
        case .MultipleChoice:
            return "multiple-choice"
        }
    }
    
    static func toIndex(_ keyString: String) -> Int {
        switch keyString {
        case PredictionType.TrueFalse.key:
            return PredictionType.TrueFalse.rawValue
        case PredictionType.YesNo.key:
            return PredictionType.YesNo.rawValue
        case PredictionType.MultipleChoice.key:
            return PredictionType.MultipleChoice.rawValue
        default:
            return -1
        }
    }
    
    static func toLabel(_ keyString: String) -> String {
        switch keyString {
        case PredictionType.TrueFalse.key:
            return "True / False"
        case PredictionType.YesNo.key:
            return "Yes / No"
        case PredictionType.MultipleChoice.key:
            return "Multiple Choice"
        default:
            return "unknown"
        }
    }
    
    static func toKey(_ index: Int) -> String {
        switch index {
        case PredictionType.TrueFalse.rawValue:
            return "true-false"
        case PredictionType.YesNo.rawValue:
            return "yes-no"
        case PredictionType.MultipleChoice.rawValue:
            return "multiple-choice"
        default:
            return "unknown"
        }
    }
}

enum TabBarTab: Int {
    case ActivityFeedTab = 0
    case CohortsTab = 1
    case AddIntuitionTab = 2
    case NotificationsTab = 3
    case ProfileTab = 4
}

enum TransferAction: Int {
    case ScrollToForIntuition = 0
    case ScrollToForOutcome = 1
}

enum TransferFrom: Int {
    case AddIntuition = 0
}

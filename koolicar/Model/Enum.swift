//
//  Enum.swift
//  koolicar
//
//  Created by frederick sauvage on 17-10-05.
//  Copyright © 2017 frederick sauvage. All rights reserved.
//

import Foundation

enum CarCategory {
    case city
    case hatchback
    case van
    case fun
    case electric
    case utility
    case delivery
    case unknown
    
    var readable: String {
        switch self {
        case .city: return "city car"
        case .hatchback: return "hatchback"
        case .van: return "family van"
        case .fun: return "fun/luxury"
        case .electric: return "electric"
        case .utility: return "utility van"
        case .delivery: return "delivery van"
        default: return ""
        }
    }
}

enum FuelTypeCd {
    case gasoline
    case diesel
    case hybrid
    case electric
    case unknown
    
    var readable: String {
        switch self {
        case .gasoline: return "gasoline"
        case .diesel: return "diesel"
        case .electric: return "electric"
        case .hybrid: return "hybrid"
        default: return ""
        }
    }
}

enum GearsType {
    case manual
    case automatic
    case unknown
    
    var readable: String {
        switch self {
        case .manual: return "manual"
        case .automatic: return "automatic"
        default: return ""
        }
    }
}

//
//  VehicleManager.swift
//  koolicar
//
//  Created by frederick sauvage on 17-10-03.
//  Copyright © 2017 frederick sauvage. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import CoreLocation

let parisLocation = CLLocation(latitude: 48.857262, longitude: 2.351796)
let vehicleJsonUrl = "https://firebasestorage.googleapis.com/v0/b/koolicar-ba37b.appspot.com/o/TestTechniqueKoolicariOS.json?alt=media&token=ecaca5f9-813c-4eb2-9ae4-ca384b7ca14f"

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

class VehiclesResponse: Mappable {
    var vehicles: [Vehicle]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        vehicles <- map["vehicles"]
    }
}

class Vehicle: NSObject, Mappable {
    var address_id: Int = 0
    var id: Int = 0
    var year: Int = 0
    var doors_count: Int = 0
    var places_count: Int = 0
    var fuel_type_cd: FuelTypeCd = .unknown
    var gears_type_cd: GearsType = .unknown
    var vehicle_model: String = ""
    var brand: String = ""
    var category: CarCategory = .unknown
    var thumbnail_url: URL?
    var distance_string: String = ""
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        var latitude: Double?
        var longitude: Double?
        var thumbnail_string: String?
        var category: String?
        var fuel_type_cd: Int?
        var gears_type_cd: Int?
        
        address_id <- map["address_id"]
        id <- map["id"]
        year <- map["year"]
        doors_count <- map["doors_count"]
        places_count <- map["places_count"]
        fuel_type_cd <- map["fuel_type_cd"]
        gears_type_cd <- map["gears_type_cd"]
        vehicle_model <- map["vehicle_model"]
        brand <- map["brand"]
        category <- map["category"]
        thumbnail_string <- map["thumbnail_url"]
        distance_string <- map["distance_string"]
        latitude <- map["fake_latitude"]
        longitude <- map["fake_longitude"]
        if let latitude = latitude, let longitude = longitude {
            self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        if let thumbnail_string = thumbnail_string {
            self.thumbnail_url =  URL(string: thumbnail_string)
        }
        if let category = category {
            switch category {
            case "CITADINE": self.category = .city
            case "COMPACTE": self.category = .hatchback
            case "FAMILIALE": self.category = .van
            case "CONFORT_ET_FUN": self.category = .fun
            case "ELECTRIQUE": self.category = .electric
            case "UTILITAIRE_LEGER": self.category = .utility
            case "UTILITAIRE_LOURD": self.category = .delivery
            default: self.category = .unknown
            }
        }
        if let fuel_type_cd = fuel_type_cd {
            switch fuel_type_cd {
            case 0: self.fuel_type_cd = .gasoline
            case 1: self.fuel_type_cd = .diesel
            case 2: self.fuel_type_cd = .electric
            case 4: self.fuel_type_cd = .hybrid
            default: self.fuel_type_cd = .unknown
            }
        }
        if let gears_type_cd = gears_type_cd {
            switch gears_type_cd {
            case 0: self.gears_type_cd = .manual
            case 1: self.gears_type_cd = .automatic
            default: self.gears_type_cd = .unknown
            }
        }
    }
    
    func fitWithSelection(selection: Selection?) -> Bool {
        guard let selection = selection else { return true }
        switch category {
        case .city: if selection.city { return true }
        case .hatchback: if selection.hatchback { return true }
        case .van: if selection.van { return true }
        case .fun: if selection.fun { return true }
        case .electric:if selection.electric { return true }
        case .utility:if selection.utility { return true }
        case .delivery:if selection.delivery { return true }
        default: break
        }
        if gears_type_cd == .automatic && selection.gearAuto { return true }
        if places_count >= 6 && selection.seat6 { return true }
        if places_count >= 5 && selection.seat5 { return true }
        return false
    }
}

class VehicleManager {
    static public let sharedInstance = VehicleManager()
    private var vehicles: [Vehicle]?
    var currentLocation = parisLocation
    var request: Alamofire.Request?

    // to force to use singleton
    private init(){}
    
    func updateVehiclesList(onSuccessCompletion: ((_ vehicles: [Vehicle]?)->())? = nil, onErrorCompletion: ((_ error: Error)->())? = nil) {
        request?.cancel()
        request = Alamofire.request(vehicleJsonUrl).responseObject { [weak self] (response: DataResponse<VehiclesResponse>) in
            switch response.result {
            case .failure(let error):
                onErrorCompletion?(error)
            case .success(let vehiclesResponse):
                if let vehiclesList = vehiclesResponse.vehicles {
                    self?.vehicles = vehiclesList
                }
                onSuccessCompletion?(self?.vehicles)
            }
        }
    }
}


//
//  City.swift
//  TaxikTest
//
//  Created by Артем on 30/09/16.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation

struct City {
    let cityId: Int
    let cityName: String
    let cityApiUrl: String
    let cityDomain: String
    let cityMobileServer: String
    let cityDocUrl: String
    let cityCoordinates: (latitude: Double, longitude: Double)
    let citySpnCoordinates: (latitude: Double, longitude: Double)
    let lastAppAndroidVersion: Int
    let androidDriverApkLink: String
    let inappPayMethods: [String]?
    let transfers: Bool
    let experimentalEconomPlus: Int?
    let experimentalEconomPlusTime: Int?
    let registrationPromocode: Bool?
    
    init(json: [String: AnyObject]) throws {
        
        guard let cityId = json["city_id"] as? Int else {
            throw SerializationError.missing("city_id")
        }
        guard let cityName = json["city_name"] as? String else {
            throw SerializationError.missing("city_name")
        }
        guard let cityApiUrl = json["city_api_url"] as? String else {
            throw SerializationError.missing("city_api_url")
        }
        guard let cityDomain = json["city_domain"] as? String else {
            throw SerializationError.missing("city_domain")
        }
        guard let cityMobileServer = json["city_mobile_server"] as? String else {
            throw SerializationError.missing("city_mobile_server")
        }
        guard let cityDocUrl = json["city_doc_url"] as? String else {
            throw SerializationError.missing("city_doc_url")
        }
        guard let lastAppAndroidVersion = json["last_app_android_version"] as? Int else {
            throw SerializationError.missing("last_app_android_version")
        }
        guard let androidDriverApkLink = json["android_driver_apk_link"] as? String else {
            throw SerializationError.missing("android_driver_apk_link")
        }
        guard let transfers = json["transfers"] as? Bool else {
            throw SerializationError.missing("transfers")
        }
        
        // if can be nill, for exmaple:
        let experimentalEconomPlus = json["experimental_econom_plus"] as! Int?
        let experimentalEconomPlusTime = json["experimental_econom_plus_time"] as! Int?
        let registrationPromocode = json["registration_promocode"] as! Bool?
        let inappPayMethods = json["inapp_pay_methods"] as! [String]?
        
        // Extract City Coordinate
        guard let cityLatitude = json["city_latitude"] as? Double,
            let cityLongitude = json["city_longitude"] as? Double else {
            throw SerializationError.missing("cityLocation")
        }
        let cityCoordinates = (cityLatitude, cityLongitude)
        guard case (-90...90, -180...180) = cityCoordinates else {
            throw SerializationError.invalid("coordinates", cityCoordinates)
        }
        // Extract City Spn Coordinate
        guard let citySpnLatitude = json["city_spn_latitude"] as? Double,
            let citySpnLongitude = json["city_spn_longitude"] as? Double else {
                throw SerializationError.missing("cityLocation")
        }
        let citySpnCoordinates = (citySpnLatitude, citySpnLongitude)
        guard case (-90...90, -180...180) = cityCoordinates else {
            throw SerializationError.invalid("spnCoordinates", cityCoordinates)
        }
        
        // Initialize properties
        self.cityId = cityId
        self.cityName = cityName
        self.cityApiUrl = cityApiUrl
        self.cityDomain = cityDomain
        self.cityMobileServer = cityMobileServer
        self.cityDocUrl = cityDocUrl
        self.lastAppAndroidVersion = lastAppAndroidVersion
        self.androidDriverApkLink = androidDriverApkLink
        self.transfers = transfers
        self.experimentalEconomPlus = experimentalEconomPlus
        self.experimentalEconomPlusTime = experimentalEconomPlusTime
        self.registrationPromocode = registrationPromocode
        self.inappPayMethods = inappPayMethods
        self.cityCoordinates = cityCoordinates
        self.citySpnCoordinates = citySpnCoordinates
    }
}

enum SerializationError: ErrorType {
    case missing(String)
    case invalid(String, Any)
}
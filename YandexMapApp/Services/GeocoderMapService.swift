//
//  GeocoderMapService.swift
//  YandexMapApp
//
//  Created by Zhassulan Aimukhambetov on 24.02.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation
import MapKit

class GeocoderMapService {
    
    class func mapOpen(latitude: Double, longitude: Double, completion: @escaping (String?, String?) -> ()) {
        let centerLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(centerLocation) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare
            let buildName = placemark?.subThoroughfare
            DispatchQueue.main.async {
                completion(streetName, buildName)
            }
        }
    }
}

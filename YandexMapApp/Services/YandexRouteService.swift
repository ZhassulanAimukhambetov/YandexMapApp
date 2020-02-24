//
//  YandexRouteService.swift
//  YandexMapApp
//
//  Created by Zhassulan Aimukhambetov on 24.02.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation
import YandexMapKit
import YandexMapKitDirections

class YandexRouteService {
    
    static var drivingSession: YMKDrivingSession?
    
    class func buildRoute(map: YMKMap, firstPoint: YMKPoint?, secondPoint: YMKPoint?, completion: @escaping (String?) -> ()) {
        guard let firstPoint = firstPoint, let secondPoint = secondPoint else { return }
        let requestPoints = [YMKRequestPoint(point: firstPoint, type: .waypoint, pointContext: nil),
                             YMKRequestPoint(point: secondPoint, type: .waypoint, pointContext: nil)]
        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        
        drivingSession = drivingRouter.requestRoutes(with: requestPoints, drivingOptions: YMKDrivingDrivingOptions(), routeHandler: { (routesResponce, error) in
            if let routes = routesResponce, routes.count > 0 {
                self.onRoutesReceived(routes, map: map)
            } else if let error = error {
                self.onRoutesError(error, completion: completion)
            } else {
                completion("Build a route from this geolocation is not possible")
            }
        })
    }
    
    private static func onRoutesReceived(_ routes: [YMKDrivingRoute], map: YMKMap) {
        let mapObjects = map.mapObjects
        for route in routes {
            mapObjects.addPolyline(with: route.geometry)
        }
    }
    
    private static func onRoutesError(_ error: Error, completion: (String?) -> ()) {
        let routingError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if routingError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if routingError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
        completion(errorMessage)
    }
}

//
//  YandexMapService.swift
//  YandexMapApp
//
//  Created by Zhassulan Aimukhambetov on 24.02.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation
import YandexMapKit
import YandexMapKitDirections

class YandexMapService {
    
    static var drivingSession: YMKDrivingSession?
    
    class func buildRoute(map: YMKMap, firstPoint: YMKPoint, secondPoint: YMKPoint, viewController: UIViewController) {
        let requestPoints = [YMKRequestPoint(point: firstPoint, type: .waypoint, pointContext: nil),
                             YMKRequestPoint(point: secondPoint, type: .waypoint, pointContext: nil)]
        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        
        drivingSession = drivingRouter.requestRoutes(with: requestPoints, drivingOptions: YMKDrivingDrivingOptions(), routeHandler: { (routesResponce, error) in
            if let routes = routesResponce {
                self.onRoutesReceived(routes, map: map)
            } else if let error = error {
                self.onRoutesError(error, viewController: viewController)
            }
        })
        
        moveCameraOnRoute(map: map, firstPoint: firstPoint, secondPoint: secondPoint)
        setPlaceMark(points: [firstPoint, secondPoint], map: map)
    }
    
    private static func onRoutesReceived(_ routes: [YMKDrivingRoute], map: YMKMap) {
        let mapObjects = map.mapObjects
        for route in routes {
            mapObjects.addPolyline(with: route.geometry)
        }
    }
    
    private static func onRoutesError(_ error: Error, viewController: UIViewController) {
        let routingError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if routingError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if routingError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func moveCameraOnRoute(map: YMKMap, firstPoint: YMKPoint, secondPoint: YMKPoint? = nil) {
        if let secondPoint = secondPoint {
            let box = YMKBoundingBox(southWest: firstPoint, northEast: secondPoint)
            let cameraPosition = map.cameraPosition(with: box)
            let editedCameraPosition = YMKCameraPosition(target: cameraPosition.target, zoom: cameraPosition.zoom - 0.5, azimuth: 0, tilt: 0)
            map.move(with: editedCameraPosition, animationType: YMKAnimation(type: .smooth, duration: 4.0), cameraCallback: nil)
            
        } else {
            let cameraPosition = YMKCameraPosition(target: firstPoint, zoom: 12, azimuth: 0, tilt: 0)
            map.move(with: cameraPosition, animationType: YMKAnimation(type: .smooth, duration: 4.0), cameraCallback: nil)
        }
    }
    
    private static func setPlaceMark(points: [YMKPoint], map: YMKMap) {
        for point in points {
            let placeMark = map.mapObjects.addPlacemark(with: point)
            placeMark.setIconWith(UIImage(named: "Mark")!)
        }
    }
}

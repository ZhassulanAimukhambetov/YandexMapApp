//
//  YandexCameraService.swift
//  YandexMapApp
//
//  Created by Zhassulan Aimukhambetov on 24.02.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation
import YandexMapKit

class YandexCameraService {
    static let animation = YMKAnimation(type: .smooth, duration: 1.2)
    
    class func moveCamera(points: [YMKPoint], map: YMKMap) {
        switch points.count {
        case 2: moveCameraOnRoute(points: (points[0], points[1]), map: map)
        case 1: moveCameraOnPoint(point: points[0], map: map)
        default: return
        }
    }
    
    private class func moveCameraOnPoint(point: YMKPoint, map: YMKMap) {
        let cameraPosition = YMKCameraPosition(target: point, zoom: 10, azimuth: 0, tilt: 0)
        map.move(with: cameraPosition,
                 animationType: animation,
                 cameraCallback: nil)
    }
    
    private class func moveCameraOnRoute(points: (southWest: YMKPoint, northEast: YMKPoint), map: YMKMap) {
        let boundingBox = YMKBoundingBox(southWest: points.southWest, northEast: points.northEast)
        let cameraPosition = map.cameraPosition(with: boundingBox)
        let editedCameraPosition = YMKCameraPosition(target: cameraPosition.target,
                                                     zoom: cameraPosition.zoom - 0.5,
                                                     azimuth: 0,
                                                     tilt: 0)
        map.move(with: editedCameraPosition,
                 animationType: animation,
                 cameraCallback: nil)
    }
}

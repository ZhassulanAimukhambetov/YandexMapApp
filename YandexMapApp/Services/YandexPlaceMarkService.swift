//
//  YandexPlaceMarkService.swift
//  YandexMapApp
//
//  Created by Zhassulan Aimukhambetov on 24.02.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation
import YandexMapKit

class YandexPlaceMarkService {
    class func setPlaceMark(points: [YMKPoint], map: YMKMap) {
        map.mapObjects.clear()
        for point in points {
            let placeMark = map.mapObjects.addPlacemark(with: point)
            placeMark.setIconWith(UIImage(named: "Mark")!)
        }
    }
}

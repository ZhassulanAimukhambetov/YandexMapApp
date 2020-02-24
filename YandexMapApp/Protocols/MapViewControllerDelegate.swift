//
//  MapViewControllerDelegate.swift
//  YandexMapApp
//
//  Created by Zhassulan Aimukhambetov on 24.02.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation
import YandexMapKit

protocol MapViewControllerDelegate {
    func getPoint(point: YMKPoint, title: String?)
}

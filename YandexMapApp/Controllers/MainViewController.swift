//
//  MainViewController.swift
//  YandexMapApp
//
//  Created by Zhassulan Aimukhambetov on 24.02.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit
import YandexMapKit
import YandexMapKitDirections

class MainViewController: UIViewController {
    
    var firstPoint: YMKPoint?
    var secondPoint: YMKPoint?
    var segueIdentifire = ""
    
    @IBOutlet weak var mapView: YMKMapView!
    @IBOutlet weak var firstPointButton: UIButton!
    @IBOutlet weak var secondPointButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        let map = mapView.mapWindow.map
        if let firstPoint = firstPoint, let secondPoint = secondPoint {
            YandexMapService.buildRoute(map: map, firstPoint: firstPoint, secondPoint: secondPoint, viewController: self)
        } else if let firstPoint = firstPoint {
            YandexMapService.moveCameraOnRoute(map: map, firstPoint: firstPoint)
        }
    }
        
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let mapVC = segue.destination as? MapViewController else { return }
        segueIdentifire = identifire
        mapVC.mapViewControllerDelegate = self
    }
    
}

extension MainViewController: MapViewControllerDelegate {
    func getPoint(point: YMKPoint, title: String?) {
        if segueIdentifire == "fromFirstPoint" {
            firstPoint = point
            firstPointButton.setTitle(title, for: .normal)
        } else {
            secondPoint = point
            secondPointButton.setTitle(title, for: .normal)
        }
    }
}

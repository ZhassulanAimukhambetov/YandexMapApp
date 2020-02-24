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
        setCamera(map: map)
        buldRoute(map: map)
    }
    
    private func buldRoute(map: YMKMap) {
        YandexRouteService.buildRoute(map: map, firstPoint: firstPoint, secondPoint: secondPoint) { (errorMessage) in
            if let errorMessage = errorMessage {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func setCamera(map: YMKMap) {
        if let firstPoint = firstPoint, let secondPoint = secondPoint {
            YandexPlaceMarkService.setPlaceMark(points: [firstPoint, secondPoint], map: map)
            YandexCameraService.moveCamera(points: [firstPoint, secondPoint], map: map)
        } else if let firstPoint = firstPoint {
            YandexPlaceMarkService.setPlaceMark(points: [firstPoint], map: map)
            YandexCameraService.moveCamera(points: [firstPoint], map: map)
        } else {
            mapView.mapWindow.map.move(with: YMKCameraPosition(target: YMKPoint(latitude: 51.53285689487582, longitude: 71.50056675590363), zoom: 5.8, azimuth: 0, tilt: 0), animationType: YMKAnimation(type: .smooth, duration: 1.5), cameraCallback: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let mapVC = segue.destination as? MapViewController else { return }
        segueIdentifire = identifire
        mapVC.mapViewControllerDelegate = self
    }
}

// MARK: - MapViewControllerDelegate
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

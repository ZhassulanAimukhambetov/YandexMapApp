//
//  MapViewController.swift
//  YandexMapApp
//
//  Created by Zhassulan Aimukhambetov on 24.02.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit
import YandexMapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var mapView: YMKMapView!
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var titleString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCamera()
        mapView.mapWindow.map.addCameraListener(with: self)
    }
    
    private func setCamera() {
        mapView.mapWindow.map.move(with: YMKCameraPosition(target: YMKPoint(latitude: 51.53285689487582, longitude: 71.50056675590363), zoom: 5.8, azimuth: 0, tilt: 0), animationType: YMKAnimation(type: .smooth, duration: 1.5), cameraCallback: nil)
    }
    
    @IBAction func addPointButton(_ sender: UIButton) {
        let target = mapView.mapWindow.map.cameraPosition.target
        mapViewControllerDelegate?.getPoint(point: YMKPoint(latitude: target.latitude, longitude: target.longitude), title: pointLabel.text)
        dismiss(animated: true, completion: nil)
    }
}

extension MapViewController: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateSource: YMKCameraUpdateSource, finished: Bool) {
        if  finished {
            YandexGeocoderService.search(point: cameraPosition.target) { (title) in
                self.pointLabel.text = title
            }
        }
    }
}

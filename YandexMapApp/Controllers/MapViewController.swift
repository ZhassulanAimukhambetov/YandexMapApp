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
        mapView.mapWindow.map.addCameraListener(with: self)
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
            let latitude = cameraPosition.target.latitude
            let longitude = cameraPosition.target.longitude
            GeocoderMapService.mapOpen(latitude: latitude, longitude: longitude) { (streetName, buildName) in
                if streetName != nil && buildName != nil {
                    self.pointLabel.text = "\(streetName!) \(buildName!)"
                } else if streetName != nil {
                    self.pointLabel.text = streetName!
                } else {
                    self.pointLabel.text = "unknown"
                }
            }
        }
    }
}

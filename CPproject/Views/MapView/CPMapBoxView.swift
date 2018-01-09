//
//  CPMapView.swift
//  CPproject
//
//  Created by Edmond on 06/01/2018.
//  Copyright © 2018 Edmond. All rights reserved.
//

import UIKit
import Mapbox

///
/// Map view
/// Implementation with mapBox
class CPMapBoxView: UIView {
    
    // MARK: -
    // MARK: Properties
    
    // Mapbox view
    var mapView: MGLMapView?
    
    
    // MARK: -
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add MapBox view
        let mapView = MGLMapView(frame: self.bounds, styleURL: MGLStyle.streetsStyleURL())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isRotateEnabled = false
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 14, animated: false)
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
        self.addSubview(mapView)
        
        self.mapView = mapView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: -
// MARK: CPMapViewProtocol implementation

extension CPMapBoxView : CPMapViewProtocol {
    
    func setCenter(_ centerCoordinate: CLLocationCoordinate2D, animated: Bool) {
        self.mapView?.setCenter(centerCoordinate, animated: animated)
    }
    
    func setPin(_ annotation: CPViewAnnotation) {
        let pin = MGLPointAnnotation()
        pin.coordinate = annotation.coordinate
        pin.title = annotation.title
        pin.subtitle = annotation.subTitle
        
        self.mapView?.addAnnotation(pin)
    }
}

// MARK: -
// MARK: MGLMapViewDelegate implementation

extension CPMapBoxView: MGLMapViewDelegate {
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }
}

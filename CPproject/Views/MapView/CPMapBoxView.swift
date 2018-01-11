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
    fileprivate var mapView: MGLMapView!
    
    weak var delegate: CPMapViewDelegateProtocol?
    var panRecognizer: UIPanGestureRecognizer!
    var pinchRecognizer: UIPinchGestureRecognizer!
    
    
    // MARK: -
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add MapBox view
        let mapView = MGLMapView(frame: self.bounds, styleURL: MGLStyle.streetsStyleURL())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isRotateEnabled = false
        mapView.zoomLevel = 15
        mapView.delegate = self
        self.addSubview(mapView)
        
        // Add gestures
        let panRecognizer = UIPanGestureRecognizer(target: self,
                                                action: #selector(self.draggedView(_:)))
        panRecognizer.delegate = self
        mapView.addGestureRecognizer(panRecognizer)
        self.panRecognizer = panRecognizer
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self,
                                                   action: #selector(self.pinchedView(_:)))
        pinchRecognizer.delegate = self
        mapView.addGestureRecognizer(pinchRecognizer)
        self.pinchRecognizer = pinchRecognizer
        
        self.mapView = mapView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: -
    // MARK: Func
    
    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
        self.delegate?.cpMapViewDraggedView(sender)
    }
    
    @objc func pinchedView(_ sender: UIPanGestureRecognizer) {}
}

// MARK: -
// MARK: CPMapViewProtocol implementation

extension CPMapBoxView : CPMapViewProtocol {
    
    func setCenter(_ centerCoordinate: CLLocationCoordinate2D, animated: Bool) {
        self.mapView.setCenter(centerCoordinate, animated: animated)
    }
    
    func setPin(_ annotation: CPViewAnnotation) {
        let pin = MGLPointAnnotation()
        pin.coordinate = annotation.coordinate
        pin.title = annotation.title
        pin.subtitle = annotation.subTitle
        
        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }
        
        self.mapView.addAnnotation(pin)
    }
    
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        return self.mapView!.centerCoordinate
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
    
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        self.delegate?.cpMapViewRegionIsChanging(self)
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        self.delegate?.cpMapViewRegionDidChange(self)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        self.delegate?.cpMapViewDidFinishLoadingMap(self)
    }
}

// MARK: -
// MARK: UIGestureRecognizerDelegate implementation

extension CPMapBoxView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Not to move the pine during a zoom / dézoom
        if (gestureRecognizer == self.pinchRecognizer) {
            return otherGestureRecognizer != self.panRecognizer
        } else if (gestureRecognizer == self.panRecognizer) {
            return otherGestureRecognizer != self.pinchRecognizer
        } else {
            return true
        }
    }
}

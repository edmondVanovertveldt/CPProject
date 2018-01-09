//
//  HomeViewModel.swift
//  CPproject
//
//  Created by Edmond on 07/01/2018.
//  Copyright © 2018 Edmond. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

///
/// HomeViewController viewmodel
class HomeViewModel: NSObject {
    
    // MARK: -
    // MARK: Variables & Drivers for ViewController
    
    let pinLocation: Variable<CLLocationCoordinate2D?>
    let locationAuthorization: Variable<CLAuthorizationStatus?>
    let address: Variable<String?>

    // MARK: -
    // MARK: Privates properties
    
    // Location manager
    fileprivate var locationManager: CLLocationManager!
    
    
    // MARK: -
    // MARK: Init
    
    override init() {
        self.pinLocation = Variable(nil)
        self.locationAuthorization = Variable(nil)
        self.address = Variable(nil)
        
        
        // Check localisation authorization status
        
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager = locationManager
        
        let locationStatus = CLLocationManager.authorizationStatus()
        
        switch locationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            // Authorization accepted
            
            // Request user position
            self.locationManager.startUpdatingLocation()
            break
            
        case .denied:
            // Re-Request location authorization (-> Redirect to the Settings)
            self.locationAuthorization.value = .denied
            
        case .notDetermined, .restricted:
            // Request localisation authorization
            locationManager.requestWhenInUseAuthorization()
        }
        
        super.init()
        
        self.locationManager.delegate = self
    }
}


// MARK: -
// MARK: CLLocationManagerDelegate implementation

extension HomeViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Authorization status change
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Authorization accepted, start updating location
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // New location
        
        if self.pinLocation.value == nil {
            self.pinLocation.value = locations.first?.coordinate
            self.locationManager.stopUpdatingLocation()
        }
    }
}

// MARK: -
// MARK: SearchAddressDelegate implementation

extension HomeViewModel: SearchAddressDelegate {
    
    func searchAddress(address: AddressData) {
        self.pinLocation.value = address.coordinate
        self.address.value = "\(address.postalAddress?.street ?? "") \(address.postalAddress?.postalCode ?? ""), \(address.postalAddress?.city ?? "")"
    }
}


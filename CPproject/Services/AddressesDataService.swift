//
//  AddressesDataService.swift
//  CPproject
//
//  Created by Edmond on 09/01/2018.
//  Copyright © 2018 Edmond. All rights reserved.
//

import Foundation
import RxSwift
import MapboxGeocoder

open class AddressesDataService {
    
    func fetchAutocomplete(address: String) -> Observable<[AddressData]> {

        let geocoder = Geocoder.shared
        let options = ForwardGeocodeOptions(query: address)
        options.allowedScopes = [.address, .pointOfInterest]
        options.allowedISOCountryCodes = ["FR"]

        let observable = Observable<[AddressData]>.create { observer in
            let _ = geocoder.geocode(options) { (placemarks, attribution, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    let addressesResults = placemarks?.map({ (placemark) -> AddressData in
                        return AddressData(
                            coordinate: placemark.location.coordinate,
                            fullDescription: placemark.qualifiedName,
                            postalAddress: placemark.postalAddress
                        )
                    }) ?? []
                    
                    observer.onNext(addressesResults)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
        
        return observable
    }
}

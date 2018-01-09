//
//  AddressData.swift
//  CPproject
//
//  Created by Edmond on 07/01/2018.
//  Copyright © 2018 Edmond. All rights reserved.
//

import Foundation
import CoreLocation
import Contacts

///
/// Address model
struct AddressData {
    var coordinate: CLLocationCoordinate2D
    var fullDescription: String
    var postalAddress: CNPostalAddress?
}

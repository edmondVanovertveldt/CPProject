//
//  CPMapViewProtocol.swift
//  CPproject
//
//  Created by Edmond on 06/01/2018.
//  Copyright © 2018 Edmond. All rights reserved.
//

import Foundation
import CoreLocation

///
/// Map view protocol
protocol CPMapViewProtocol {
    func setCenter(_ centerCoordinate: CLLocationCoordinate2D, animated: Bool)
    func setPin(_ annotation: CPViewAnnotation)
}

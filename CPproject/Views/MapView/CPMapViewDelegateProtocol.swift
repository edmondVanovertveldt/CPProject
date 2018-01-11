//
//  CPMapViewDelegateProtocol.swift
//  CPproject
//
//  Created by Edmond on 10/01/2018.
//  Copyright © 2018 Edmond. All rights reserved.
//

import Foundation
import UIKit

///
/// Map view delegate protocol
protocol CPMapViewDelegateProtocol: class {
    func cpMapViewRegionIsChanging(_ mapView: CPMapBoxView)
    func cpMapViewRegionDidChange(_ mapView: CPMapBoxView)
    func cpMapViewDidFinishLoadingMap(_ mapView: CPMapBoxView)
    func cpMapViewDraggedView(_ sender:UIPanGestureRecognizer)
}

// Optionals
extension CPMapViewDelegateProtocol {
    func cpMapViewRegionIsChanging(_ mapView: CPMapBoxView) {}
    func cpMapViewRegionDidChange(_ mapView: CPMapBoxView) {}
    func cpMapViewDidFinishLoadingMap(_ mapView: CPMapBoxView) {}
    func cpMapViewDraggedView(_ sender:UIPanGestureRecognizer) {}
}

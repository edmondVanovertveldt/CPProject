//
//  ViewController.swift
//  CPproject
//
//  Created by Edmond on 05/01/2018.
//  Copyright © 2018 Edmond. All rights reserved.
//

import UIKit
import CoreLocation
import Reusable
import RxSwift
import RxCocoa

///
/// Home view controller
/// Present Map view with user location or address location
class HomeViewController: UIViewController, StoryboardBased {
    
    // MARK: -
    // MARK: Properties
    
    // MapView
    private var mapView: (UIView & CPMapViewProtocol)!
    
    // View model
    private var viewModel: HomeViewModel!
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: -
    // MARK: View controller LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add map view
        
        let mapView = CPMapBoxView(frame: self.view.frame)
        self.view.addSubview(mapView)
        self.mapView = mapView
        
        // Configure viewModel & bindings
        self.configureViewModel()
        self.configureBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.locationAuthorization.asDriver()
            .drive(
                onNext: { (status) in
                    if let status = status, status == .denied {
                        // Present alert setting view
                        
                        let alertController = UIAlertController(
                            title: L10n.locationServiceDisable,
                            message: L10n.requestLocationServiceSubtitle,
                            preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        
                        let openAction = UIAlertAction(title: L10n.openSettings, style: .default) { (action) in
                            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                        alertController.addAction(openAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                },
                onCompleted: nil,
                onDisposed: nil
            )
            .disposed(by: self.disposeBag)
    }
    
    
    // MARK: -
    // MARK: Private Func
    
    private func configureViewModel() {
        self.viewModel = HomeViewModel()
    }
    
    private func configureBindings() {
        self.viewModel.pinLocation.asDriver()
            .drive(
                onNext: { (pinCoordinate) in
                    // Show user location with a pin
                    if let pinCoordinate = pinCoordinate {
                        self.mapView.setPin(CPViewAnnotation(coordinate: pinCoordinate, title: "", subTitle: ""))
                        self.mapView.setCenter(pinCoordinate, animated: true)
                    }
                },
                onCompleted: nil,
                onDisposed: nil
            )
            .disposed(by: self.disposeBag)
    }
}


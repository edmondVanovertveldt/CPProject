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
class HomeViewController: BaseViewController, StoryboardBased {
    
    // MARK: -
    // MARK: IBOutlets
    
    @IBOutlet var mapContainerView: UIView!
    @IBOutlet var addressSearchView: UIView! {
        didSet {
            addressSearchView.layer.shadowColor = UIColor.black.cgColor
            addressSearchView.layer.shadowOpacity = 1
            addressSearchView.layer.shadowOffset = CGSize.init(width: -1, height: 1)
            addressSearchView.layer.shadowRadius = 3
            addressSearchView.layer.shadowPath = UIBezierPath(rect: self.addressSearchView.bounds).cgPath
        }
    }
    @IBOutlet var addressSearchTextField: UITextField! {
        didSet {
            addressSearchTextField.attributedPlaceholder =
                NSAttributedString(string: L10n.searchAddress, attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
            addressSearchTextField.delegate = self
        }
    }
    
    
    // MARK: -
    // MARK: Properties
    
    // MapView
    fileprivate var mapView: (UIView & CPMapViewProtocol)!
    
    // View model
    var viewModel: HomeViewModel!
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: -
    // MARK: View controller LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add map view
        
        let mapView = CPMapBoxView(frame: self.view.frame)
        mapView.delegate = self
        self.mapContainerView.embedView(mapView)
        self.mapView = mapView
        
        // Configure viewModel & bindings
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
    
    private func configureBindings() {
        
        // Pin location
        self.viewModel.pinLocation.asDriver()
//            .throttle(0.05, latest: true)
            .drive(
                onNext: { (pinCoordinate) in
                    // Show location with a pin
                    if let pinCoordinate = pinCoordinate {
                        self.mapView.setPin(CPViewAnnotation(coordinate: pinCoordinate, title: "", subTitle: ""))
                    }
                },
                onCompleted: nil,
                onDisposed: nil
            )
            .disposed(by: self.disposeBag)
        
        // Address
        self.viewModel.address.asDriver()
            .drive(self.addressSearchTextField.rx.text)
            .disposed(by: self.disposeBag)
        
        // Map center
        self.viewModel.mapCenter.asDriver()
            .drive(onNext: { [weak self] (centerCoordinate) in
                if let centerCoordinate = centerCoordinate {
                    self?.mapView.setCenter(centerCoordinate, animated: true)
                }
            }, onCompleted: nil,
               onDisposed: nil)
            .disposed(by: self.disposeBag)
    }
}


// MARK: -
// MARK: UITextFieldDelegate implementation

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let searchVC = SearchAddressViewController.instantiate()
        searchVC.modalPresentationStyle = .overCurrentContext
        searchVC.viewModel = SearchAddressViewModel(addressesDataService: AddressesDataService(), searchAddress: self.addressSearchTextField.text ?? "", delegate: self.viewModel)
        
        self.present(searchVC, animated: false, completion: nil)
        return false
    }
}

// MARK: -
// MARK: CPMapViewDelegateProtocol implementation

extension HomeViewController: CPMapViewDelegateProtocol {
    
    func cpMapViewRegionDidChange(_ mapView: CPMapBoxView) {}
    
    func cpMapViewDraggedView(_ sender:UIPanGestureRecognizer) {
        self.viewModel.pinLocation.value = mapView.getCenterCoordinate()
    }
}


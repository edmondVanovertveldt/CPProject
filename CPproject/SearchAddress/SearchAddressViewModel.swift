//
//  SearchAddressViewModel.swift
//  CPproject
//
//  Created by Edmond on 08/01/2018.
//  Copyright © 2018 Edmond. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// Delegate protocol
protocol SearchAddressDelegate: class {
    /// User valided address
    func searchAddress(address: AddressData)
}

class SearchAddressViewModel {
    
    // MARK: -
    // MARK: Variables & Drivers for ViewController
    
    let searchAddress: Variable<String?>
    let autocompleteResults: Variable<Array<AddressTableViewCell.ViewModel>>
    
    
    // MARK: -
    // MARK: Properties
    
    weak var delegate: SearchAddressDelegate?
    
    private var autocompleteDatasModel: Variable<[AddressData]>
    private let disposeBag = DisposeBag()
    
    
    // MARK: -
    // MARK: Init
    
    init(addressesDataService: AddressesDataService, searchAddress: String, delegate: SearchAddressDelegate?) {
        self.searchAddress = Variable(searchAddress)
        self.autocompleteResults = Variable([])
        self.autocompleteDatasModel = Variable([])
        self.delegate = delegate
        
        self.autocompleteDatasModel.asDriver()
            .map({ (adressesDatas) -> [AddressTableViewCell.ViewModel] in
                return adressesDatas.map({ (addressData) -> AddressTableViewCell.ViewModel in
                    return AddressTableViewCell.ViewModel(
                        street: addressData.postalAddress?.street ?? "",
                        city: "\(addressData.postalAddress?.postalCode ?? ""), \(addressData.postalAddress?.city ?? "")")
                })
            })
            .drive(self.autocompleteResults)
            .disposed(by: self.disposeBag)
        
        
        self.searchAddress.asDriver()
            .throttle(0.5)
            .filter({ (searchAddress) -> Bool in
                return searchAddress != nil
            })
            .flatMap { (searchAddress) -> Driver<[AddressData]> in
                // Call WS
                return addressesDataService.fetchAutocomplete(address: searchAddress ?? "")
                    // Model -> ViewModel
                    .asDriver(onErrorJustReturn: [])
                
            }
            .drive(self.autocompleteDatasModel)
            .disposed(by: self.disposeBag)
    }
    
    func addressItemSelected(atIndexPath indexPath: IndexPath) {
        self.delegate?.searchAddress(address: self.autocompleteDatasModel.value[indexPath.row])
    }
}


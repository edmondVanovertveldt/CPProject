//
//  AddressTableViewCell.swift
//  CPproject
//
//  Created by Edmond on 08/01/2018.
//  Copyright © 2018 Edmond. All rights reserved.
//

import UIKit
import Reusable

class AddressTableViewCell: UITableViewCell, NibReusable {
    
    /// Holds the data and logic needed to populate a 'AddressTableViewCell'.
    struct ViewModel {
        var street: String
        var city: String
    }

    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    
    
    /// The view’s view model.
    var viewModel: ViewModel? {
        didSet {
            self.addressLabel.text = viewModel?.street ?? ""
            self.cityLabel.text = viewModel?.city ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}


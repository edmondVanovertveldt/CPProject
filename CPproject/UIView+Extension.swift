//
//  UIView+Extension.swift
//  CPproject
//
//  Created by Edmond on 11/01/2018.
//  Copyright © 2018 Edmond. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func embedView(_ subview: UIView) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        let views = ["view": subview]
        ["H:|[view]|", "V:|[view]|"].forEach { vfl in
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: vfl, options: [], metrics: nil, views: views)
            constraints.forEach { $0.isActive = true }
        }
    }
}

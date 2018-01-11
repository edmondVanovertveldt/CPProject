//
//  BaseViewController.swift
//  CPproject
//
//  Created by Edmond on 11/01/2018.
//  Copyright © 2018 Edmond. All rights reserved.
//

import UIKit
import DeallocationChecker

/// BaseViewController
/// To check RetainCycle
class BaseViewController: UIViewController {

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        dch_checkDeallocation()
    }
}

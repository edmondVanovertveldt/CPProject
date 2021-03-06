//
//  SearchAddressViewController.swift
//  CPproject
//
//  Created by Edmond on 08/01/2018.
//  Copyright © 2018 Edmond. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

///
/// SearchAddressViewController
/// Present seach address text and autocomplete.
class SearchAddressViewController: BaseViewController, StoryboardBased {

    // MARK: -
    // MARK: IBOutlets
    
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
            self.addressSearchTextField.becomeFirstResponder()
        }
    }
    @IBOutlet var backButton: UIButton!
    @IBOutlet var searchAutocompleteTableView: UITableView! {
        didSet {
            self.tableViewInitHeight = searchAutocompleteTableView.frame.height
            self.tableViewMaxHeight = searchAutocompleteTableView.frame.height
        }
    }
    
    // Constraints
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: -
    // MARK: Properties
    
    private var tableViewMaxHeight: CGFloat!
    private var tableViewInitHeight: CGFloat!
    
    // View model
    var viewModel: SearchAddressViewModel!
    
    let disposeBag = DisposeBag()
    
    
    // MARK: -
    // MARK: View controller LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add blur effect
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.alpha = 0.6
        blurEffectView.frame = self.view.frame
        
        self.view.insertSubview(blurEffectView, at: 0)
        
        // Configure tableview
        self.configureTableView()

        // Configure viewModel & bindings
        self.configureBindings()
        
        // Init keyboard observer to adapt tableviewHeight
        self.initKeyboardObservers()
    }

    
    // MARK: -
    // MARK: Private Func
    
    private func configureBindings() {
        // Search text
        self.viewModel.searchAddress.asDriver().drive(self.addressSearchTextField.rx.text).disposed(by: self.disposeBag)
        self.addressSearchTextField.rx.text.asDriver().drive(self.viewModel.searchAddress).disposed(by: self.disposeBag)
        
        // Tableview
        
        // DataSource
        self.viewModel.autocompleteResults.asDriver()
            .drive(self.searchAutocompleteTableView.rx.items(cellIdentifier: AddressTableViewCell.reuseIdentifier, cellType: AddressTableViewCell.self)) { row, viewModel, cell in
                cell.viewModel = AddressTableViewCell.ViewModel(street: viewModel.street, city: viewModel.city)
            }
            .disposed(by: self.disposeBag)
        
        // Hidden ?
        self.viewModel.autocompleteResults.asDriver()
            .map({ (results) -> Bool in
                return results.count == 0
            })
            .drive(self.searchAutocompleteTableView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        // TableView Size
        self.searchAutocompleteTableView.rx.observe(CGSize.self, "contentSize")
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] (contentSize) in
                if let contentSize = contentSize {
                    UIView.animate(withDuration: 0.25, animations: {
                        let maxHeight = self?.tableViewMaxHeight ?? 0
                        self?.tableViewHeightConstraint.constant = contentSize.height > maxHeight ? maxHeight : contentSize.height
                        self?.view.setNeedsUpdateConstraints()
                    })
                }
            }, onCompleted: nil,
               onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        // Item selected
        self.searchAutocompleteTableView.rx.itemSelected.asDriver()
            .drive(onNext: { [weak self] (indexPath) in
                self?.viewModel.addressItemSelected(atIndexPath: indexPath)
                self?.dismiss(animated: false, completion: nil)
            }, onCompleted: nil, onDisposed: nil)
        .disposed(by: self.disposeBag)
        
        // Back button
        self.backButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] (_) in
                self?.dismiss(animated: false, completion: nil)
            }, onCompleted: nil,
               onDisposed: nil)
            .disposed(by: self.disposeBag)
    }
    
    private func configureTableView() {
        // Prevent empty rows
        self.searchAutocompleteTableView.tableFooterView = UIView()
        
        // Autolayout
        self.searchAutocompleteTableView.estimatedRowHeight = 50
        self.searchAutocompleteTableView.rowHeight = UITableViewAutomaticDimension
        
        // Register cells
        self.searchAutocompleteTableView.register(cellType: AddressTableViewCell.self)
    }
    
    private func initKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.tableViewMaxHeight = keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.tableViewMaxHeight = self.tableViewInitHeight
        
        UIView.animate(withDuration: 0.25, animations: {
            self.tableViewHeightConstraint.constant = self.tableViewInitHeight
            self.view.setNeedsUpdateConstraints()
        })
    }
}


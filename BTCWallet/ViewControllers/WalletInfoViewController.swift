//
//  WalletInfoViewController.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 19.03.2022.
//

import UIKit

class WalletInfoViewController: UIViewController {
    // MARK: - Private properties
    // Head image block
    private let navigationTitleLabel = UILabel()
    private let iconImage = UIImageView()
    
    // Add Date block
    private let addDateTitle = UILabel()
    private let addDateField = UILabel()
    
    // Update Date block
    private let updateDateTitle = UILabel()
    private let updateDateField = UILabel()
    
    // Address block
    private let addressTitle = UILabel()
    private let addressField = UILabel()
    
    // Balance block
    private let balanceTitle = UILabel()
    private let balanceField = UILabel()
    
    //Button block
    private let removeButton = UIButton()
    
    // MARK: - Public properties
    public var wallet: Wallet?
    public var deleteViewController: (() -> Void)?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        setNavigationBar()
        setStyle()
        setLayout()
        fetchData()
    }
}

// MARK: - Private Methods
extension WalletInfoViewController {
    private func setNavigationBar() {
        navigationTitleLabel.text = "Wallet info"
        navigationTitleLabel.font = .systemFont(ofSize: 20, weight: .light)
        navigationItem.titleView = navigationTitleLabel
    }
    
    private func setStyle() {
        view.backgroundColor = .white
        
        // Head image block
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.image = UIImage(named: "Bitcoin")
        
        // Add Date block
        addDateTitle.translatesAutoresizingMaskIntoConstraints = false
        addDateTitle.text = "Add date"
        addDateTitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        addDateField.translatesAutoresizingMaskIntoConstraints = false
        addDateField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        // Update Date block
        updateDateTitle.translatesAutoresizingMaskIntoConstraints = false
        updateDateTitle.text = "Update date"
        updateDateTitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        updateDateField.translatesAutoresizingMaskIntoConstraints = false
        updateDateField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        // Address block
        addressTitle.translatesAutoresizingMaskIntoConstraints = false
        addressTitle.text = "Address"
        addressTitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        addressField.translatesAutoresizingMaskIntoConstraints = false
        addressField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        addressField.textAlignment = .center
        addressField.numberOfLines = 0
        
        // Balance block
        balanceTitle.translatesAutoresizingMaskIntoConstraints = false
        balanceTitle.text = "Balance"
        balanceTitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        balanceField.translatesAutoresizingMaskIntoConstraints = false
        balanceField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        balanceField.numberOfLines = 0
        balanceField.textAlignment = .center
        
        //Button block
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.setTitle("Remove Wallet", for: .normal)
        removeButton.backgroundColor = .systemRed
        removeButton.layer.cornerRadius = 18
        removeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        removeButton.addTarget(self, action: #selector(removeButtonPressed), for: .touchUpInside)
    }
    
    private func setLayout() {
        view.addSubview(iconImage)
        view.addSubview(addDateTitle)
        view.addSubview(addDateField)
        view.addSubview(updateDateTitle)
        view.addSubview(updateDateField)
        view.addSubview(addressTitle)
        view.addSubview(addressField)
        view.addSubview(balanceTitle)
        view.addSubview(balanceField)
        view.addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            iconImage.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 3),
            iconImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.5/8),
            iconImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/13),
            
            addDateTitle.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 20),
            addDateTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addDateField.topAnchor.constraint(equalTo: addDateTitle.bottomAnchor, constant: 10),
            addDateField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            updateDateTitle.topAnchor.constraint(equalTo: addDateField.bottomAnchor, constant: 30),
            updateDateTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            updateDateField.topAnchor.constraint(equalTo: updateDateTitle.bottomAnchor, constant: 10),
            updateDateField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addressTitle.topAnchor.constraint(equalTo: updateDateField.bottomAnchor, constant: 30),
            addressTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addressField.topAnchor.constraint(equalTo: addressTitle.bottomAnchor, constant: 10),
            addressField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.5),
            
            balanceTitle.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 30),
            balanceTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            balanceField.topAnchor.constraint(equalTo: balanceTitle.bottomAnchor, constant: 10),
            balanceField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            balanceField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.5),
            
            removeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            removeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3.5 / 4),
            removeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/20),
            removeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    private func fetchData() {
        addressField.text = wallet?.addrStr
        balanceField.text = wallet?.balance
    }
    
}

// MARK: - Navigation Method
extension WalletInfoViewController {
    @objc func removeButtonPressed() {
        
        let alertController = UIAlertController(title: "Are you sure?", message: "This wallet will be deleted", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Delete", style: .default) { action in
            RealmService.shared.delete(model: self.wallet!)
            self.navigationController?.popViewController(animated: true)
            self.deleteViewController?()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

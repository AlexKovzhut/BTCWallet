//
//  WalletInfoViewController.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 19.03.2022.
//

import UIKit
import SnapKit

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
    
    init(wallet: Wallet) {
        self.wallet = wallet
        super.init(nibName: nil, bundle: nil)
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // SnapKit
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view)
            make.size.equalTo(80)
        }
        
        addDateTitle.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(25)
            make.centerX.equalTo(view)
        }
        
        addDateField.snp.makeConstraints { make in
            make.top.equalTo(addDateTitle.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
        
        updateDateTitle.snp.makeConstraints { make in
            make.top.equalTo(addDateField.snp.bottom).offset(25)
            make.centerX.equalTo(view)
        }
        
        updateDateField.snp.makeConstraints { make in
            make.top.equalTo(updateDateTitle.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
        
        addressTitle.snp.makeConstraints { make in
            make.top.equalTo(updateDateField.snp.bottom).offset(25)
            make.centerX.equalTo(view)
        }
        
        addressField.snp.makeConstraints { make in
            make.top.equalTo(addressTitle.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(view.snp.width).offset(-120)
        }
        
        balanceTitle.snp.makeConstraints { make in
            make.top.equalTo(addressField.snp.bottom).offset(25)
            make.centerX.equalTo(view)
        }
        
        balanceField.snp.makeConstraints { make in
            make.top.equalTo(balanceTitle.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
        
        removeButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 320, height: 40))
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    //Fetch to detail view wallet
    private func fetchData() {
        guard let wallet = wallet else { return }
        
        addressField.text = wallet.address
        balanceField.text = wallet.balance
        addDateField.text = wallet.addedDate
        updateDateField.text = wallet.updatedDate
    }
}

// MARK: - Navigation Method
extension WalletInfoViewController {
    // Remove wallet method
    @objc func removeButtonPressed() {
        let alertController = UIAlertController(title: "Are you sure?", message: "This wallet will be deleted", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Delete", style: .default) { [weak self] action in
            guard let self = self else { return }
            guard let wallet = self.wallet else { return }
            
            RealmService.shared.delete(model: wallet)
            
            self.navigationController?.popViewController(animated: true)
            self.deleteViewController?()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

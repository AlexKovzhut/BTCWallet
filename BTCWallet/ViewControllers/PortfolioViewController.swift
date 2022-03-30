//
//  PortfolioViewController.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 19.03.2022.
//

import UIKit
import RealmSwift
import SnapKit

class PortfolioViewController: UIViewController {
    // MARK: - Private properties
    private let navigationTitleLabel = UILabel()
    private let contentView = UIView()
    private let tableView = UITableView()
    private let addButton = UIButton()
    
    // MARK: - Public properties
    lazy var wallets = RealmService.shared.realm.objects(Wallet.self)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        RealmService.shared.locationOfRealmConfig()
        setup()
        setNavigationBar()
        setStyle()
        setLayout()
     
    }
}

    // MARK: - Private Methods
extension PortfolioViewController {
    private func setup() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setNavigationBar() {
        navigationTitleLabel.text = "Portfolio"
        navigationTitleLabel.font = .systemFont(ofSize: 20, weight: .light)
        navigationItem.titleView = navigationTitleLabel
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""
    }
    
    private func setStyle() {
        view.backgroundColor = .white
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WalletTableViewCell.self, forCellReuseIdentifier: WalletTableViewCell.identifier)
        tableView.rowHeight = 95
        tableView.separatorStyle = .none
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("Add Wallet", for: .normal)
        addButton.backgroundColor = .systemGreen
        addButton.layer.cornerRadius = 18
        addButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    private func setLayout() {
        view.addSubview(contentView)
        contentView.addSubview(tableView)
        view.addSubview(addButton)
        
        // SnapKit
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.bottom.equalTo(addButton.snp.top)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 320, height: 40))
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
}

    // MARK: - TableView Data Source
extension PortfolioViewController: UITableViewDataSource {
    // Configure row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }

    // Configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wallet = wallets[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.identifier, for: indexPath) as! WalletTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: wallet)

        return cell
    }
}

    // MARK: - TableView Delegate
extension PortfolioViewController: UITableViewDelegate {
    // Configure select cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wallet = wallets[indexPath.row]
        let destinationController = WalletInfoViewController(wallet: wallet)
        
        destinationController.wallet = wallet
        navigationController?.pushViewController(destinationController, animated: true)
        
        // Delete cell method
        destinationController.deleteViewController = {
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Navigation and UIAlertController Methods
extension PortfolioViewController {
    // RefreshControll function
    @objc func refreshTableView() {
        updateWallet()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // Add wallet button function
    @objc func addButtonPressed() {
        showAddWalletAlert()
    }
    
    // UIAlertController method to add wallet
    func showAddWalletAlert() {
        let alertController = UIAlertController(title: "Wallet Address", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            guard let textField = alertController.textFields?.first, let walletAddress = textField.text else { return }
            self?.createWallet(address: walletAddress)
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
            
        self.present(alertController, animated: true)
    }
    
    // Alert if address is not found
    func showErrorAlert() {
        let title = "Error"
        let message = "The address is not recognized or does not exist. Please try again"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Create wallet method
    func createWallet(address: String) {
        WalletService.shared.createWallet(address: address) { [weak self] result in
                switch result {
                case .success(let wallet):
                    let currentDate = Date()
                    wallet.addedDate = currentDate.setFormatToDate()
                    wallet.updatedDate = currentDate.setFormatToDate()
                    
                    RealmService.shared.create(model: wallet)
                    let rowIndex = IndexPath(row: self!.wallets.count - 1, section: 0)
                    self?.tableView.insertRows(at: [rowIndex], with: .automatic)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    // Update wallet method
    func updateWallet() {
        for wallet in wallets {
            var array = [String]()
            array.append(wallet.address)
            guard let walletAddress = array.last else { return }
                    
            WalletService.shared.updateWallet(address: walletAddress) { result in
                switch result {
                case .success(let receivedWallet):
                    print("This is OLD wallet -> \(wallet)")
                    if wallet.address == receivedWallet.address {
                        let newBalance = receivedWallet.balance

                        DispatchQueue.main.async {
                            RealmService.shared.update(model: wallet, balance: newBalance)
                            print("This is NEW wallet -> \(receivedWallet)")
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

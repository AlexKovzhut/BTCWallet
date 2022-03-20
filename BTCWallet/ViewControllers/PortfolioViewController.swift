//
//  PortfolioViewController.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 19.03.2022.
//

import UIKit

class PortfolioViewController: UIViewController {
    // MARK: - Private properties
    private let navigationTitleLabel = UILabel()
    private let contentView = UIView()
    private let tableView = UITableView()
    private let addButton = UIButton()
    
    // MARK: - Public properties
    public var wallets = [Wallet]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
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
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -24),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3.5 / 4),
            addButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
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
        let destinationController = WalletInfoViewController()
        destinationController.wallet = wallet
        navigationController?.pushViewController(destinationController, animated: true)
    }
}

// MARK: - Navigation Method
extension PortfolioViewController {
    @objc func addButtonPressed() {
        let alertController = UIAlertController(title: "Wallet Address", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            guard let textField = alertController.textFields?.first, let walletAddress = textField.text else { return }

            self.wallets.append(contentsOf: [
                Wallet(
                    addrStr: walletAddress,
                    balance: self.wallets.first?.balance ?? "Error",
                    transactions: [])
            ])
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

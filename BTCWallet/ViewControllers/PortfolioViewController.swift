//
//  PortfolioViewController.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 19.03.2022.
//

import UIKit
import Moya
import RealmSwift

class PortfolioViewController: UIViewController {
    // MARK: - Private properties
    private let navigationTitleLabel = UILabel()
    private let contentView = UIView()
    private let tableView = UITableView()
    private let addButton = UIButton()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Public properties
    //public var wallets = [Wallet]()
    public var walletProvider = MoyaProvider<WalletService>()
    public let realm = try! Realm()
    public var wallets: Results<Wallet>!
    
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
        wallets = realm.objects(Wallet.self)
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
        
        refreshControl.addTarget(self, action: #selector(refreshTableView(sender:)), for: .valueChanged)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WalletTableViewCell.self, forCellReuseIdentifier: WalletTableViewCell.identifier)
        tableView.rowHeight = 95
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        
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
        destinationController.deleteViewController = {
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        destinationController.wallet = wallet
        navigationController?.pushViewController(destinationController, animated: true)
    }
}

// MARK: - Navigation Method
extension PortfolioViewController {
    @objc func refreshTableView(sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    @objc func addButtonPressed() {
        showAddAlert()
    }
    
    func showAddAlert() {
        let alertController = UIAlertController(title: "Wallet Address", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            guard let textField = alertController.textFields?.first, let walletAddress = textField.text else { return }
            
            self.walletProvider.request(.addWallet(walletAddress)) { [self] result in
                switch result {
                case .success(let responce):
                    let wallet = try? JSONDecoder().decode(Wallet.self, from: responce.data)
                    
                    if wallet?.balance == nil {
                        self.showErrorAlert()
                    } else {
                        RealmService.shared.add(model: wallet!)
                        let rowIndex = IndexPath(row: self.wallets.count - 1, section: 0)
                        self.tableView.insertRows(at: [rowIndex], with: .automatic)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
            
        self.present(alertController, animated: true)
    }
    
    func showErrorAlert() {
        let title = "Error"
        let message = "Address is not recognized or does not exist. Please, try again"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

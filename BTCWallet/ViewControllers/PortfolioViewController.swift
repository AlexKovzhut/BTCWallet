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
    
    // MARK: - Public properties
    public var walletProvider = MoyaProvider<WalletService>()
    public var wallets: Results<Wallet>!
    
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
        wallets = RealmService.shared.realm.objects(Wallet.self)
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
        updateData()
        let deadline = DispatchTime.now() + .milliseconds(500)
        
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // Add wallet button function
    @objc func addButtonPressed() {
        showAddWalletAlert()
    }
    
    // Main Alert method to add new wallet
    func showAddWalletAlert() {
        let alertController = UIAlertController(title: "Wallet Address", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            guard let textField = alertController.textFields?.first, let walletAddress = textField.text else { return }
 
            self.walletProvider.request(.addWallet(walletAddress)) { [self] result in
                switch result {
                case .success(let responce):
                    guard let wallet = try? JSONDecoder().decode(Wallet.self, from: responce.data) else { return showErrorAlert() }
                    let date = Date()
                    wallet.addedDate = setFormatToDate(date: date)
                    wallet.updatedDate = setFormatToDate(date: date)
                        
                    RealmService.shared.create(model: wallet)
                    let rowIndex = IndexPath(row: self.wallets.count - 1, section: 0)
                    self.tableView.insertRows(at: [rowIndex], with: .automatic)
                        
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
    
    // Refresh Control Method
    func updateData() {
        for wallet in wallets {
            var array = [String]()
            array.append(wallet.address)
            let walletAddress = array.last!
            
            walletProvider.request(.addWallet(walletAddress)) { [self] result in
                switch result {
                case .success(let responce):
                    let updatedWallet = try? JSONDecoder().decode(Wallet.self, from: responce.data)
                    if wallet.balance != updatedWallet!.balance {
                        let newBalance = updatedWallet!.balance
                        let date = Date()
                        let newDate = setFormatToDate(date: date)

                        DispatchQueue.main.async {
                            RealmService.shared.update(model: wallet, balance: newBalance, updatedDate: newDate)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // Alert if address is not found
    func showErrorAlert() {
        let title = "Error"
        let message = "The address is not recognized or does not exist. Please try again"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // To format create time wallet and update time
    func setFormatToDate(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.timeZone = .autoupdatingCurrent
        
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
}

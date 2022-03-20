//
//  WalletInfoViewController.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 19.03.2022.
//

import UIKit

class WalletInfoViewController: UIViewController {
    
    public var wallet: Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        view.backgroundColor = .green
        navigationItem.title = wallet?.walletAddress
    }
    
}

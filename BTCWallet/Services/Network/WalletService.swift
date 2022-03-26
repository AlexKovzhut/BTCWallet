//
//  WalletService.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 20.03.2022.
//

import Foundation
import Moya

class WalletService {
    static let shared = WalletService()
    
    var walletProvider = MoyaProvider<WalletTarget>()
    
    func addNewWallet(with address: String, completion: Wallet) -> Void {
        walletProvider.request(.createWallet(address)) { [weak self] result in
       
        }
    }
}



//
//  Wallet.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 19.03.2022.
//

struct Wallet: Codable {
    let addrStr: String
    let balance: String
    let transactions: [String]
}

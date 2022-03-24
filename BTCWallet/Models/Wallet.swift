//
//  Wallet.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 19.03.2022.
//

import Foundation
import RealmSwift

class Wallet: Object, Codable {
    @Persisted var address: String
    @Persisted var balance: String
    @Persisted var addedDate: String
    @Persisted var updatedDate: String
    
    convenience init(address: String, balance: String, addedDate: String, updatedDate: String) {
        self.init()
        self.address = address
        self.balance = balance
        self.addedDate = addedDate
        self.updatedDate = updatedDate
    }
    
    enum CodingKeys: String, CodingKey {
           case address = "addrStr"
           case balance = "balance"
       }
}


// Example Wallet
//3QKCocNhzAgtgFLsD5qUZcG6e4TkfRf421
//bc1q4n3ugl5fjahzjwlg9rj2vwg8pdrseuf4au2hgd
//373GifzHRGRBALbtxHNhhQpZ9DqGuet4Dh
//16EFGkAsqgH8nbU8TJKNV8gSNSrgBSe5Nw

//
//  Wallet.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 19.03.2022.
//

import Foundation
import RealmSwift

class Wallet: Object, Codable {
    @Persisted  var addrStr: String = ""
    @Persisted  var balance: String = ""
    
    convenience init(addrStr: String, balance: String) {
        self.init()
        self.addrStr = addrStr
        self.balance = balance
    }
}

class WalletList: Object {
    @Persisted  var addrStr: String = ""
    @Persisted  var balance: String = ""
    
    let wallets = List<Wallet>()
}



// Example
//3QKCocNhzAgtgFLsD5qUZcG6e4TkfRf421
//bc1q4n3ugl5fjahzjwlg9rj2vwg8pdrseuf4au2hgd
//373GifzHRGRBALbtxHNhhQpZ9DqGuet4Dh
//16EFGkAsqgH8nbU8TJKNV8gSNSrgBSe5Nw

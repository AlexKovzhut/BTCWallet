//
//  Wallet.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 19.03.2022.
//

import Foundation
import RealmSwift

class Wallet: Object, Codable {
    @objc dynamic  var addrStr: String
    @objc dynamic  var balance: String
    
    convenience init(addrStr: String, balance: String) {
        self.init()
        self.addrStr = addrStr
        self.balance = balance
    }
}

// Example
//3QKCocNhzAgtgFLsD5qUZcG6e4TkfRf421
//bc1q4n3ugl5fjahzjwlg9rj2vwg8pdrseuf4au2hgd
//373GifzHRGRBALbtxHNhhQpZ9DqGuet4Dh
//16EFGkAsqgH8nbU8TJKNV8gSNSrgBSe5Nw

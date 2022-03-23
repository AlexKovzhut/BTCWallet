//
//  RealmService.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 21.03.2022.
//

import Foundation
import RealmSwift

class RealmService {
    
    static let shared = RealmService()
    
    private init() {}

    let realm = try! Realm()
    
    func add(model: Wallet) {
        try! realm.write {
            realm.add(model)
        }
    }
    
    func delete(model: Wallet) {
        try! realm.write {
            realm.delete(model)
        }
    }
    
    func update(wallet: Wallet, wallets: Results<Wallet>, balance: String, date: String) {
        try! realm.write {
            wallet.balance = balance
            wallets.setValue(date, forKey: "updatedDate")
        }
    }
}

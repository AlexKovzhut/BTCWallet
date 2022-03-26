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
    
    func create(model: Wallet) {
        try! realm.write {
            realm.add(model)
        }
    }
    
    func delete(model: Wallet) {
        try! realm.write {
            realm.delete(model)
        }
    }
    
    func update(model: Wallet, balance: String) {
        let date = Date()
        
        try! realm.write {
            model.balance = balance
            model.updatedDate = date.setFormatToDate()
        }
    }
    
    // Print location of local realm config
    func locationOfRealmConfig() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }
}

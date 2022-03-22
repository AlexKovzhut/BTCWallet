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
    
    func addWallet(model: Wallet) {
        try! realm.write {
            realm.add(model)
        }
    }
}

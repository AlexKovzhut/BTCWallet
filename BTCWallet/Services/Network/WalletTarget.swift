//
//  WalletTarget.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 27.03.2022.
//

import Foundation
import Moya

enum WalletTarget {
    case createWallet(address: String)
    case updateWallet(address: String)
}

extension WalletTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://btcbook.guarda.co/api")!
    }
    
    var path: String {
        switch self {
        case .createWallet(let address):
            return "/address/\(address)"
        case .updateWallet(let address):
            return "/address/\(address)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

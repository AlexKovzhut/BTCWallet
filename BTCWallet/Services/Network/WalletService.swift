//
//  WalletService.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 20.03.2022.
//

import Foundation
import Moya

enum WalletService {
    case addWallet(String)
}

extension WalletService: TargetType {
    var baseURL: URL {
        return URL(string: "https://btcbook.guarda.co/api")!
    }
    
    var path: String {
        switch self {
        case .addWallet(let address):
            return "/address/\(address)"
        }
    }
    
    var sampleData: Data {
        switch self {
        case .addWallet:
            return Data()
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



//
//  WalletService.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 20.03.2022.
//

import UIKit
import Moya

//https://btcbook.guarda.co/api/address/bc1qdty3ms6psftl63nyk5wvnz7yz8vmuy87fcpn3kw7ecuuwe83j76sl0f9x4
//https://btcbook.guarda.co/api/address/bc1qyn24dhlad6v63q4kuna0ke25x8q82ct8shrvh7rqytym47f5mhxsg38s3e
//https://btcbook.guarda.co/api/address/bc1qs6whg0lwrfe52r39x3ue4f4d6rqmd7jh3f792g


enum WalletService {
    case addWallet(String)
}

extension WalletService: TargetType {
    var baseURL: URL {
        return URL(string: "https://btcbook.guarda.co/api")!
    }
    
    var path: String {
        switch self {
        case .addWallet(let addrStr):
            return "/address/\(addrStr)"
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



//
//  WalletService.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 20.03.2022.
//

import Foundation
import Moya


// WalletService должен быть классом в котором инкапсулированна вся работа с сетью. Услово он должен иметь функцию которая принимает адрес и отадет в комплишене илбо модельку wallet либо ошибку. Экраны не должны знать откуда именно walletService берет информацию

//а эта штука должна называться WalletTarget
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
    
    //можно убрать так как это не обязательный параметр
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



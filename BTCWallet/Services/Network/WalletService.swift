//
//  WalletService.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 20.03.2022.
//

import Foundation
import Moya

class WalletService {
    static let shared = WalletService()
    var provider = MoyaProvider<WalletTarget>()
    
    func createWallet(address: String, completion: @escaping (Result<Wallet, Error>) -> Void) {
        request(target: .createWallet(address: address), completion: completion)
    }
    
    func updateWallet(address: String, completion: @escaping (Result<Wallet, Error>) -> Void) {
        request(target: .createWallet(address: address), completion: completion)
    }
}

private extension WalletService {
    private func request<T: Decodable>(target: WalletTarget, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

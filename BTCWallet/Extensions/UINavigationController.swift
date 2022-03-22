//
//  UINavigationController.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 22.03.2022.
//

import UIKit

extension UINavigationController {
    
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}

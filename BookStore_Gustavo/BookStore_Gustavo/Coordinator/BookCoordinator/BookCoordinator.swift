//
//  BookCoordinator.swift
//  BookStore_Gustavo
//
//  Created by Gustavo Oliveira on 01/06/22.
//

import Foundation
import UIKit

class BookCoordinator: Coodinator {
    var childCoordinator: [Coodinator]
    
    var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinator = []
    }
    
    func startCoordinator() {
        let nameVC = String(describing: BookListViewController.self)
        let bundleVC = Bundle(for: BookListViewController.self)
        let viewController = BookListViewController.init(nibName: nameVC, bundle: bundleVC)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func startBookDetail() {
        let nameVC = String(describing: BookDetailViewController.self)
        let bundleVC = Bundle(for: BookDetailViewController.self)
        let viewController = BookDetailViewController.init(nibName: nameVC, bundle: bundleVC)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

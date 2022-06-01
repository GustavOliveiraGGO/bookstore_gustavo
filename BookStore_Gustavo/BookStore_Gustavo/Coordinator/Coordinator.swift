//
//  Coordinator.swift
//  BookStore_Gustavo
//
//  Created by Gustavo Oliveira on 01/06/22.
//

import Foundation
import UIKit

protocol Coodinator: AnyObject {
    var childCoordinator: [Coodinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func startCoordinator()
}

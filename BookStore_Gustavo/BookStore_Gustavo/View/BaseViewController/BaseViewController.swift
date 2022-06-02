//
//  BaseViewController.swift
//  BookStore_Gustavo
//
//  Created by Gustavo Oliveira on 02/06/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    func setupNavBar(title: String, navBar: UINavigationBar, navBarItem: UIBarButtonItem?) {
        let navItem = UINavigationItem(title: title)
        navItem.rightBarButtonItem = navBarItem
        navBar.setItems([navItem], animated: false)
    }
}

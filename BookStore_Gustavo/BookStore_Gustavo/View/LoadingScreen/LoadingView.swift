//
//  LoadingView.swift
//  BookStore_Gustavo
//
//  Created by Gustavo Oliveira on 01/06/22.
//

import UIKit
import NVActivityIndicatorView

class LoadingView: UIView {
    
    private var activityIndicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .darkText, padding: 0)
    
    func setup() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            activityIndicator.heightAnchor.constraint(equalToConstant: 40),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func onStartAnimating() {
        self.backgroundColor = .black.withAlphaComponent(0.5)
        activityIndicator.startAnimating()
    }
    
    func onStopAnimating() {
        activityIndicator.stopAnimating()
        self.backgroundColor = .clear
    }
}

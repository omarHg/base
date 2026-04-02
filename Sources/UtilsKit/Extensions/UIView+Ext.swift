//
//  UIView+Ext.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 28/02/26.
//

import UIKit

public extension UIView {
    func pinEdges(to other: UIView, insets: UIEdgeInsets = .zero) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: insets.left).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -insets.right).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor, constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -insets.bottom).isActive = true
    }
    
    func pinEdges(to other: UILayoutGuide, insets: UIEdgeInsets = .zero) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: insets.left).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -insets.right).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor, constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -insets.bottom).isActive = true
    }
    
    func borderSubviews() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        for subview in subviews {
            subview.borderSubviews()
        }
    }
    
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func asImage() -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size,
                                                   self.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            guard let currentContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: currentContext)
            return UIGraphicsGetImageFromCurrentImageContext()
    }
}

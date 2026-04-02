//
//  SwiftUIWrapperView.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 28/02/26.
//

import SwiftUI
import UIKit

open class SwiftUIWrapperView<Content: View>: UIView {
    public let hostingController: UIHostingController<Content>
    
    public init(rootView: Content) {
        self.hostingController = UIHostingController(rootView: rootView)
        super.init(frame: .zero)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        hostingController.sizingOptions = .intrinsicContentSize
        hostingController.view.backgroundColor = .clear
        addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

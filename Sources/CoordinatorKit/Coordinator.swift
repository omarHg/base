//
//  Coordinator.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 27/02/26.
//

import UIKit

public protocol Coordinator: AnyObject {
    func start()
}

public protocol ComponentCordinator: AnyObject {
    var viewController: UIViewController { get }
}

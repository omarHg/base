//
//  BaseViewController+Configuration.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 01/03/26.
//

import UIKit

// MARK: - BaseViewController Configuration Extension

extension BaseViewController {
    
    // MARK: - Quick Setup Methods
    
    /// Configura el view controller de forma rápida con opciones comunes
    func quickSetup(
        title: String? = nil,
        backgroundColor: UIColor = .systemBackground,
        prefersLargeTitle: Bool = false,
        hideKeyboardOnTap: Bool = true
    ) {
        view.backgroundColor = backgroundColor
        setupNavigationBar(title: title, prefersLargeTitle: prefersLargeTitle)
        if hideKeyboardOnTap {
            setupKeyboardHandling()
        }
    }
    
    // MARK: - Safe Area Configuration
    
    /// Obtiene el top inset del safe area
    var safeAreaTop: CGFloat {
        return view.safeAreaInsets.top
    }
    
    /// Obtiene el bottom inset del safe area
    var safeAreaBottom: CGFloat {
        return view.safeAreaInsets.bottom
    }
    
    /// Obtiene el left inset del safe area
    var safeAreaLeft: CGFloat {
        return view.safeAreaInsets.left
    }
    
    /// Obtiene el right inset del safe area
    var safeAreaRight: CGFloat {
        return view.safeAreaInsets.right
    }
    
    // MARK: - Gesture Recognizer Management
    
    /// Agrega un gesture recognizer swipe hacia atrás
    func addSwipeBackGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeBackTriggered))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func swipeBackTriggered() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Safe Unwrapping Helpers
    
    /// Ejecuta un bloque de código de forma segura en el hilo principal
    func executeOnMainThread(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    /// Ejecuta un bloque de código después de un delay en el hilo principal
    func executeOnMainThread(after delay: TimeInterval, _ block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            block()
        }
    }
    
    // MARK: - Transition Animation
    
    /// Anima la transición de un view controller
    func animateTransition(duration: TimeInterval = 0.3, animations: @escaping () -> Void) {
        UIView.animate(withDuration: duration, animations: animations)
    }
    
    /// Realiza una transición con spring animation
    func animateSpringTransition(
        duration: TimeInterval = 0.6,
        delay: TimeInterval = 0,
        damping: CGFloat = 0.7,
        velocity: CGFloat = 0.5,
        animations: @escaping () -> Void
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: damping,
            initialSpringVelocity: velocity,
            options: .curveEaseOut,
            animations: animations
        )
    }
    
    // MARK: - View Debugging
    
    /// Debugea la jerarquía de vistas (solo en DEBUG)
    func debugViewHierarchy(_ view: UIView = UIApplication.shared.windows.first?.rootViewController?.view ?? UIView(), indent: String = "") {
        #if DEBUG
        print("\(indent)\(type(of: view))")
        for subview in view.subviews {
            debugViewHierarchy(subview, indent: indent + "  ")
        }
        #endif
    }
    
    // MARK: - Memory Management
    
    /// Libera recursos cuando el view controller se deinicializa
    func releaseResources() {
        // Sobrescribir en subclases si es necesario
    }
}

//
//  UIViewController+Ext.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 01/03/26.
//


import UIKit

// MARK: - UIViewController Extension for Common Configuration

extension UIViewController {
    
    // MARK: - Navigation Bar Configuration
    
    /// Configura la barra de navegación con un título y opciones de estilo
    func configureNavigationBar(
        title: String? = nil,
        prefersLargeTitle: Bool = false,
        backgroundColor: UIColor = .systemBackground,
        tintColor: UIColor = .label
    ) {
        navigationItem.title = title
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitle
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.tintColor = tintColor
    }
    
    /// Agrega un botón personalizado a la navegación
    func addNavigationBarButton(
        _ button: UIBarButtonItem,
        position: NavBarPosition = .right
    ) {
        switch position {
        case .left:
            navigationItem.leftBarButtonItem = button
        case .right:
            navigationItem.rightBarButtonItem = button
        }
    }
    
    /// Enum para especificar la posición del botón en la barra de navegación
    enum NavBarPosition {
        case left
        case right
    }
    
    // MARK: - View Configuration
    
    /// Configura el color de fondo del view
    func setBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }
    
    /// Configura propiedades básicas de apariencia
    func configureAppearance(
        backgroundColor: UIColor = .systemBackground,
        safeAreaInsets: UIEdgeInsets = .zero
    ) {
        view.backgroundColor = backgroundColor
        if safeAreaInsets != .zero {
            view.layoutMargins = safeAreaInsets
        }
    }
    
    // MARK: - Status Bar Configuration
    
    /// Configura el estilo de la barra de estado
    func configureStatusBar(style: UIStatusBarStyle = .default) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - View Hierarchy
    
    /// Agrega una subview y la ancla a los bordes del view controller
    func addFullScreenSubview(_ view: UIView) {
        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    /// Agrega una subview y la ancla al safe area
    func addSafeAreaSubview(_ view: UIView) {
        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - AlertController Helper
    
    /// Muestra una alerta simple
    func showAlert(
        title: String,
        message: String,
        buttonTitle: String = "OK",
        buttonAction: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            buttonAction?()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    /// Muestra una alerta de confirmación con dos botones
    func showConfirmationAlert(
        title: String,
        message: String,
        confirmTitle: String = "Confirmar",
        cancelTitle: String = "Cancelar",
        confirmAction: (() -> Void)? = nil,
        cancelAction: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmBtn = UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmAction?()
        }
        let cancelBtn = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelAction?()
        }
        
        alertController.addAction(confirmBtn)
        alertController.addAction(cancelBtn)
        present(alertController, animated: true)
    }
    
    // MARK: - Loading Indicator
    
    /// Muestra un indicador de carga
    func showLoadingIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        return indicator
    }
    
    /// Oculta el indicador de carga
    func hideLoadingIndicator(_ indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
    
    // MARK: - Keyboard Handling
    
    /// Cierra el teclado cuando el usuario toca fuera de un campo de texto
    func hideKeyboardOnTapOutside() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Child View Controller Management
    
    /// Agrega un view controller hijo y lo ancla al view del padre
    func addChildViewController(_ child: UIViewController, to containerView: UIView? = nil) {
        let container = containerView ?? view
        addChild(child)
        container?.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: container?.topAnchor ?? view.topAnchor),
            child.view.leadingAnchor.constraint(equalTo: container?.leadingAnchor ?? view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: container?.trailingAnchor ?? view.trailingAnchor),
            child.view.bottomAnchor.constraint(equalTo: container?.bottomAnchor ?? view.bottomAnchor)
        ])
        child.didMove(toParent: self)
    }
    
    /// Remueve un view controller hijo
    func removeChildViewController(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}

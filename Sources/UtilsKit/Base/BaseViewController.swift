//
//  BaseViewController.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 01/03/26.
//

import UIKit

// MARK: - BaseViewController

/// Clase base para todos los UIViewControllers del proyecto.
/// Proporciona configuración común y métodos reutilizables.
open class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Indicador de carga reutilizable
    private var loadingIndicator: UIActivityIndicatorView?
    
    /// Estado de carga actual
    open var isLoading: Bool = false {
        didSet {
            updateLoadingUI()
        }
    }
    
    // MARK: - Lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupInitialConfiguration()
    }
    
    // MARK: - Setup Methods
    
    /// Configuración inicial del view controller.
    /// Sobrescribe este método en subclases para configuración específica.
    open func setupInitialConfiguration() {
        setupAppearance()
        setupSubviews()
        setupConstraints()
        bindViewModel()
    }
    
    /// Configura la apariencia inicial del view controller
    open func setupAppearance() {
        view.backgroundColor = .systemBackground
    }
    
    /// Configura las subviews iniciales
    open func setupSubviews() {
        // Sobrescribir en subclases
    }
    
    /// Configura las restricciones de layout
    open func setupConstraints() {
        // Sobrescribir en subclases
    }
    
    /// Vincula el view model con la vista
    open func bindViewModel() {
        // Sobrescribir en subclases
    }
    
    // MARK: - Loading State Management
    
    /// Actualiza la interfaz de usuario según el estado de carga
    private func updateLoadingUI() {
        if isLoading {
            displayLoadingIndicator()
        } else {
            dismissLoadingIndicator()
        }
    }
    
    /// Muestra el indicador de carga (versión mejorada de BaseViewController)
    private func displayLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.loadingIndicator == nil {
                self.loadingIndicator = UIActivityIndicatorView(style: .medium)
                self.loadingIndicator?.center = self.view.center
                self.loadingIndicator?.hidesWhenStopped = true
                if let indicator = self.loadingIndicator {
                    self.view.addSubview(indicator)
                }
            }
            self.loadingIndicator?.startAnimating()
        }
    }
    
    /// Oculta el indicador de carga (versión mejorada de BaseViewController)
    private func dismissLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator?.stopAnimating()
        }
    }
    
    // MARK: - Error Handling
    
    /// Muestra un mensaje de error en una alerta
    func showErrorAlert(title: String = "Error", message: String) {
        showAlert(title: title, message: message, buttonTitle: "OK")
    }
    
    /// Muestra un mensaje de éxito
    func showSuccessAlert(title: String = "Éxito", message: String) {
        showAlert(title: title, message: message, buttonTitle: "OK")
    }
    
    // MARK: - Navigation Helpers
    
    /// Configura la barra de navegación con un título personalizado
    func setupNavigationBar(title: String?, prefersLargeTitle: Bool = false) {
        configureNavigationBar(
            title: title,
            prefersLargeTitle: prefersLargeTitle,
            backgroundColor: .systemBackground,
            tintColor: .label
        )
    }
    
    /// Agrega un botón de cerrar (atrás) en la barra de navegación
    func addBackButton() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        addNavigationBarButton(backButton, position: .left)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Common UI Patterns
    
    /// Habilita o deshabilita la interacción del usuario
    func setUserInteractionEnabled(_ enabled: Bool) {
        view.isUserInteractionEnabled = enabled
    }
    
    /// Muestra o oculta el view controller con animación
    func setHidden(_ hidden: Bool, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.view.alpha = hidden ? 0 : 1
            }
        } else {
            view.alpha = hidden ? 0 : 1
        }
    }
    
    // MARK: - Keyboard Management
    
    /// Configura el manejo automático del teclado
    func setupKeyboardHandling() {
        hideKeyboardOnTapOutside()
    }
}

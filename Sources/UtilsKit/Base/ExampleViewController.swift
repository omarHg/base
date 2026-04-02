//
//  ExampleViewController.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 01/03/26.
//
//  Este archivo es un ejemplo de cómo usar BaseViewController en tu aplicación.
//  Puedes copiarlo como referencia para crear otros view controllers.

import UIKit
import SwiftUI

// MARK: - Example View Controller
/*
class ExampleViewController: BaseViewController {
    
    // MARK: - Properties
    
    /// El presenter que maneja la lógica de la escena
    private let presenter: ExamplePresenter
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Example Screen"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "This is an example of how to use BaseViewController"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load Data", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    
    init(presenter: ExamplePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setupAppearance() {
        super.setupAppearance()
        view.backgroundColor = .systemBackground
        setupNavigationBar(title: "Example", prefersLargeTitle: true)
        addBackButton()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        // Agregar subviews
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(loadButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Load Button
            loadButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            loadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loadButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        // Configurar el presenter
        presenter.view = self
        
        // Agregar target al botón
        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
        
        // Habilitar manejo del teclado
        setupKeyboardHandling()
    }
    
    // MARK: - Actions
    
    @objc private func loadButtonTapped() {
        isLoading = true
        
        // Simular carga de datos
        executeOnMainThread(after: 2) {
            self.isLoading = false
            self.showSuccessAlert(message: "Data loaded successfully!")
        }
    }
    
    // MARK: - Cleanup
    
    override func releaseResources() {
        super.releaseResources()
        // Limpiar recursos aquí si es necesario
    }
}

// MARK: - ExampleView Protocol Conformance

extension ExampleViewController: ExampleView {
    func showError(message: String) {
        showErrorAlert(message: message)
    }
    
    func showSuccess(message: String) {
        showSuccessAlert(message: message)
    }
    
    func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
}

// MARK: - Placeholder Protocols and Classes

protocol ExamplePresenter {
    var view: ExampleView? { get set }
}

protocol ExampleView: AnyObject {
    func showError(message: String)
    func showSuccess(message: String)
    func setLoading(_ isLoading: Bool)
}

class ExamplePresenterImplementation: ExamplePresenter {
    weak var view: ExampleView?
}
*/

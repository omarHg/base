# UIViewController Configuration Guide

Esta guía explica cómo utilizar la extensión `UIViewController+Ext.swift` y la clase base `BaseViewController` para configurar todas las propiedades necesarias en los view controllers del proyecto.

## 📚 Estructura

### 1. **UIViewController+Ext.swift** (Extensión)
Una extensión de `UIViewController` que proporciona métodos reutilizables para configurar:
- Barra de navegación
- Apariencia y fondos
- Manejo de subviews con constraints
- Alertas y confirmaciones
- Indicadores de carga
- Manejo de teclado
- Vista de jerarquía

### 2. **BaseViewController.swift** (Clase Base)
Una clase base que extiende `UIViewController` y proporciona:
- Métodos de configuración con ciclo de vida claro
- Gestión de estado de carga
- Manejo de errores
- Helpers de navegación
- Manejo de teclado automático

### 3. **BaseViewController+Configuration.swift** (Extensión de Configuración)
Extensión adicional de `BaseViewController` con:
- Setup rápido
- Safe area helpers
- Gestión de gestures
- Ejecución en hilo principal
- Animaciones
- Debugging
- Gestión de memoria

---

## 🚀 Uso

### Opción 1: Usar UIViewController + Extensión

Si prefieres una solución ligera sin herencia, puedes usar directamente la extensión:

```swift
class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar barra de navegación
        configureNavigationBar(title: "Home", prefersLargeTitle: true)
        
        // Configurar apariencia
        setBackgroundColor(.systemBackground)
        
        // Agregar un botón personalizado
        let button = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(menuTapped))
        addNavigationBarButton(button, position: .right)
    }
    
    @objc func menuTapped() {
        showAlert(title: "Menu", message: "Menu tapped!")
    }
}
```

### Opción 2: Usar BaseViewController (Recomendado)

Para una estructura más organizada y reutilizable, hereda de `BaseViewController`:

```swift
class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    private let presenter: HomePresenter
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupAppearance() {
        super.setupAppearance()
        view.backgroundColor = .systemBackground
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        // Agregar subviews aquí
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        // Configurar constraints aquí
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        // Vincular el view model aquí
        setupKeyboardHandling()
    }
}

extension HomeViewController: HomeView {
    func show(viewModel: HomeViewModel) {
        // Mostrar los datos del view model
    }
    
    func show(error: Error) {
        showErrorAlert(message: error.localizedDescription)
    }
    
    func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
}
```

---

## 📋 Métodos Disponibles

### UIViewController+Ext.swift

#### Barra de Navegación
```swift
configureNavigationBar(title: String?, prefersLargeTitle: Bool, backgroundColor: UIColor, tintColor: UIColor)
addNavigationBarButton(_ button: UIBarButtonItem, position: NavBarPosition)
```

#### Apariencia
```swift
setBackgroundColor(_ color: UIColor)
configureAppearance(backgroundColor: UIColor, safeAreaInsets: UIEdgeInsets)
configureStatusBar(style: UIStatusBarStyle)
```

#### Jerarquía de Vistas
```swift
addFullScreenSubview(_ view: UIView)
addSafeAreaSubview(_ view: UIView)
```

#### Alertas
```swift
showAlert(title: String, message: String, buttonTitle: String, buttonAction: (() -> Void)?)
showConfirmationAlert(title: String, message: String, confirmTitle: String, cancelTitle: String, confirmAction: (() -> Void)?, cancelAction: (() -> Void)?)
```

#### Indicadores de Carga
```swift
showLoadingIndicator() -> UIActivityIndicatorView
hideLoadingIndicator(_ indicator: UIActivityIndicatorView)
```

#### Teclado
```swift
hideKeyboardOnTapOutside()
```

#### View Controllers Hijo
```swift
addChildViewController(_ child: UIViewController, to containerView: UIView?)
removeChildViewController(_ child: UIViewController)
```

### BaseViewController.swift

#### Configuración
```swift
setupInitialConfiguration() // Llamado automáticamente
setupAppearance() // Sobrescribir en subclases
setupSubviews() // Sobrescribir en subclases
setupConstraints() // Sobrescribir en subclases
bindViewModel() // Sobrescribir en subclases
```

#### Carga
```swift
isLoading: Bool { didSet } // Propiedad observable
showLoadingIndicator()
hideLoadingIndicator()
```

#### Errores
```swift
showErrorAlert(title: String?, message: String)
showSuccessAlert(title: String?, message: String)
```

#### Navegación
```swift
setupNavigationBar(title: String?, prefersLargeTitle: Bool)
addBackButton()
```

### BaseViewController+Configuration.swift

#### Quick Setup
```swift
quickSetup(title: String?, backgroundColor: UIColor, prefersLargeTitle: Bool, hideKeyboardOnTap: Bool)
```

#### Safe Area
```swift
var safeAreaTop: CGFloat
var safeAreaBottom: CGFloat
var safeAreaLeft: CGFloat
var safeAreaRight: CGFloat
```

#### Gestures
```swift
addSwipeBackGesture()
```

#### Ejecución en Hilo Principal
```swift
executeOnMainThread(_ block: @escaping () -> Void)
executeOnMainThread(after delay: TimeInterval, _ block: @escaping () -> Void)
```

#### Animaciones
```swift
animateTransition(duration: TimeInterval, animations: @escaping () -> Void)
animateSpringTransition(duration: TimeInterval, delay: TimeInterval, damping: CGFloat, velocity: CGFloat, animations: @escaping () -> Void)
```

#### Debugging
```swift
debugViewHierarchy(_ view: UIView, indent: String)
```

#### Gestión de Memoria
```swift
releaseResources() // Sobrescribir en subclases
```

---

## 💡 Mejores Prácticas

1. **Usa `BaseViewController` para toda la aplicación** — Proporciona consistencia y reutilización de código.

2. **Sobrescribe los métodos de setup en el orden correcto**:
   ```
   setupAppearance() → setupSubviews() → setupConstraints() → bindViewModel()
   ```

3. **Gestión de estado de carga**:
   ```swift
   override func bindViewModel() {
       super.bindViewModel()
       viewModel.isLoadingPublisher
           .receive(on: DispatchQueue.main)
           .assign(to: &$isLoading)
   }
   ```

4. **Siempre llama a `super`** cuando sobrescribas métodos.

5. **Usa `executeOnMainThread`** para actualizaciones de UI desde hilos secundarios.

6. **Limpia recursos en `releaseResources()`** si es necesario.

---

## 🔗 Integración con Arquitectura Modular

En la arquitectura de módulos con Presenters y ViewModels:

```swift
class HomeViewController: BaseViewController {
    private let presenter: HomePresenter
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        setupNavigationBar(title: "Home")
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        // SwiftUIWrapperView para integrar SwiftUI
        let rootView = HomeContentView(viewModel: presenter.viewModel)
        let contentView = SwiftUIWrapperView(rootView: rootView)
        addChild(contentView.hostingController)
        view.addSubview(contentView)
        contentView.hostingController.didMove(toParent: self)
        contentView.pinEdges(to: view)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        presenter.view = self
    }
}

extension HomeViewController: HomeView {
    func show(viewModel: HomeViewModel) {
        // Actualizar la vista
    }
}
```

---

## ✨ Conclusión

Con esta configuración:
- ✅ Consistencia en todos los view controllers
- ✅ Código reutilizable y mantenible
- ✅ Ciclo de vida claro
- ✅ Integración perfecta con arquitectura modular
- ✅ Menos boilerplate code

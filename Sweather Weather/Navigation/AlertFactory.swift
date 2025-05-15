//
//  AlertFactory.swift
//  Sweather Weather
//
//  Created by Dima Zhiltsov on 15.05.2025.
//

import UIKit

// MARK: - Protocols

protocol AlertActionProtocol: CaseIterable {
    var title: String { get }
    var style: UIAlertAction.Style { get }
    
    func alertAction(handler: ((UIAlertAction) -> Void)?) -> UIAlertAction
}
extension AlertActionProtocol {
    func alertAction(handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: self.title, style: self.style, handler: handler)
    }
}

// MARK: Alert Export Map Action

enum AlertAction: String, AlertActionProtocol {
    case rename
    case cancel
    case delete
    case yes
    case no
    
    var title: String {
        return "\(rawValue.capitalized)"
    }
    var style: UIAlertAction.Style {
        switch self {
            
        case .delete, .yes:     return .destructive
        case .cancel, .no:      return .cancel
        default:                return .default
        }
    }
}

struct AlertActionsOptions {
    let title: String?
    let subtitle: String?
    
    let actions: [AlertAction]
    
    init(title: String? = nil, subtitle: String? = nil,
         actions: [AlertAction]) {
        
        self.title = title
        self.subtitle = subtitle
        
        self.actions = actions
    }
}

struct AlertConfirmationOptions {
    let title: String?
    let subtitle: String?
    
    let success: AlertAction
    let cancel: AlertAction
    
    init(title: String? = nil, subtitle: String? = nil,
         success: AlertAction, cancel: AlertAction) {
        
        self.title = title
        self.subtitle = subtitle
        
        self.success = success
        self.cancel = cancel
    }
}

struct AlertTextOptions {
    let title: String?
    let message: String?
    
    let text: String
    let placeholder: String
    
    let success: AlertAction
    let cancel: AlertAction
    
    init(title: String? = nil, message: String? = nil,
         text: String, placeholder: String,
         success: AlertAction, cancel: AlertAction) {
        
        self.title = title
        self.message = message
        
        self.text = text
        self.placeholder = placeholder
        
        self.success = success
        self.cancel = cancel
    }
}

typealias AlertConfirmationHandler = ((_ success: Bool) -> Void)
typealias AlertTextHandler = ((AlertTextHandlerValue) -> Void)

enum AlertTextHandlerValue {
    case success(_ text: String?)
    case cancel
}

//
// MARK: - Protocols

protocol AlertFactoryProtocol {
    
    func createAlertInfo(with title: String?, _ message: String?, _ handler: (() -> Void)?) -> UIAlertController
    func createAlertConfirmation(_ options: AlertConfirmationOptions,
                                 _ handler: AlertConfirmationHandler?) -> UIAlertController
    
    func createAlertInputText(_ options: AlertTextOptions, _ handler: AlertTextHandler?) -> UIAlertController
    
    func createAlert(with options: AlertActionsOptions,
                     _ style: UIAlertController.Style,
                     _ completionHandler: ((AlertAction) -> Void)?) -> UIAlertController
}

// MARK: - Factory

final class AlertFactory: AlertFactoryProtocol {
    
    // MARK: - Alert Info
    
    func createAlertInfo(with title: String?, _ message: String?, _ handler: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.1137254902, green: 0.1254901961, blue: 0.1568627451, alpha: 1)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            handler?()
        }))
        
        return alert
    }
    
    // MARK: - Alert Choose
    
    func createAlertConfirmation(_ options: AlertConfirmationOptions,
                                 _ handler: AlertConfirmationHandler?) -> UIAlertController {
        
        let alert = UIAlertController(title: options.title, message: options.subtitle, preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.1137254902, green: 0.1254901961, blue: 0.1568627451, alpha: 1)
        
        alert.addAction(options.cancel.alertAction(handler: { _ in
            handler?(false)
        }))
        alert.addAction(options.success.alertAction(handler: { _ in
            handler?(true)
        }))
        
        return alert
    }
    
    // MARK: - Alert Text Input
    
    func createAlertInputText(_ options: AlertTextOptions, _ handler: AlertTextHandler?) -> UIAlertController {
        
        let alert = UIAlertController(title: options.title, message: options.message, preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.1137254902, green: 0.1254901961, blue: 0.1568627451, alpha: 1)
        
        alert.addTextField { textField in
            textField.text = options.text
            textField.placeholder = options.placeholder
        }
        
        alert.addAction(options.cancel.alertAction(handler: { _ in
            handler?(.cancel)
        }))
        
        alert.addAction(options.success.alertAction(handler: { _ in
            let text = alert.textFields?.first?.text ?? ""
            handler?(.success(text.isEmpty ? nil : text))
        }))
        
        return alert
    }
    
    func createAlert(with options: AlertActionsOptions,
                     _ style: UIAlertController.Style,
                     _ completionHandler: ((AlertAction) -> Void)?) -> UIAlertController {
        
        let alert = UIAlertController(title: options.title, message: options.subtitle, preferredStyle: style)
        alert.view.tintColor = #colorLiteral(red: 0.1137254902, green: 0.1254901961, blue: 0.1568627451, alpha: 1)
        
        options.actions.forEach { action in
            alert.addAction(action.alertAction(handler: { _ in
                completionHandler?(action)
            }))
        }
        
        return alert
    }
}

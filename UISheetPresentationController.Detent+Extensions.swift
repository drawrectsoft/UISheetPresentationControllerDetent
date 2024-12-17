//
//  UISheetPresentationController.Detent+Extensions.swift
//  UISheetPresentationController.Detent+Extensions
//
//  Created by Artem Strelnik on 11.11.2024.
//

import SwiftUI
import ObjectiveC.runtime

extension UISheetPresentationController.Detent {
    
    // MARK: - Constants
    
    private static let customDetentIdentifierPrefix = "UISheetPresentationController.Detent.Custom"
    
    // MARK: - Public API
    
    /// Создает уникальный идентификатор для кастомного detent по высоте
    /// - Parameter height: Высота для detent
    /// - Returns: Уникальный идентификатор для кастомного detent
    static func customIdentifier(forHeight height: CGFloat) -> UISheetPresentationController.Detent.Identifier {
        return UISheetPresentationController.Detent.Identifier("\(customDetentIdentifierPrefix)\(height)")
    }
    
    /// Создает кастомный detent для iOS 16 и выше
    /// - Parameter height: Высота detent
    /// - Returns: Кастомный detent
    @available(iOS 16.0, *)
    static func custom(_ height: CGFloat) -> UISheetPresentationController.Detent {
        return custom(identifier: customIdentifier(forHeight: height), height: height)
    }
    
    /// Создает кастомный detent с указанным идентификатором и высотой для iOS 16 и выше
    /// - Parameters:
    ///   - identifier: Идентификатор detent
    ///   - height: Высота detent
    /// - Returns: Кастомный detent
    @available(iOS 16.0, *)
    static func custom(identifier: UISheetPresentationController.Detent.Identifier, height: CGFloat) -> UISheetPresentationController.Detent {
        return UISheetPresentationController.Detent.custom(identifier: identifier) { _ in
            return height
        }
    }
    
    /// Создает кастомный detent для iOS 15 с использованием приватного API
    /// - Parameter height: Высота detent
    /// - Returns: Кастомный detent для iOS 15 (используется приватное API)
    static func customDetentBelowiOS16(height: CGFloat) -> UISheetPresentationController.Detent {
        let identifier = customIdentifier(forHeight: height)
        return customDetentBelowiOS16(identifier: identifier, height: height)
    }
    
    /// Создает кастомный detent с указанным идентификатором и высотой для iOS 15
    /// - Parameters:
    ///   - identifier: Идентификатор detent
    ///   - height: Высота detent
    /// - Returns: Кастомный detent (используется приватное API)
    static func customDetentBelowiOS16(identifier: UISheetPresentationController.Detent.Identifier, height: CGFloat) -> UISheetPresentationController.Detent {
        let selector = NSSelectorFromString("_detentWithIdentifier:constant:")
        
        guard let method = class_getClassMethod(UISheetPresentationController.Detent.self, selector) else {
            fatalError("Private API '_detentWithIdentifier:constant:' not available.")
        }
        
        typealias CustomDetentFunction = @convention(c) (AnyObject, Selector, UISheetPresentationController.Detent.Identifier, CGFloat) -> UISheetPresentationController.Detent
        
        let function = unsafeBitCast(method_getImplementation(method), to: CustomDetentFunction.self)
        
        return function(UISheetPresentationController.Detent.self, selector, identifier, height)
    }
}

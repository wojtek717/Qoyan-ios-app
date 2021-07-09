//
//  KeyboardHeightPublisher.swift
//  QoyanUI
//
//  Created by Wojciech Konury on 14/06/2021.
//

import Combine
import UIKit

public extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { _ in CGFloat(0.75) }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(1) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
    
    static var isKeyboardExpanded: AnyPublisher<Bool, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { _ in true }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in false }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

public extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
    
    var isKeyboardExpanded: Bool {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0 >= 0.0
    }
}

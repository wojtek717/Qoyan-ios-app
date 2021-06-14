//
//  UIApplicationExtension.swift
//  QoyanUI
//
//  Created by Wojciech Konury on 14/06/2021.
//

import UIKit

public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

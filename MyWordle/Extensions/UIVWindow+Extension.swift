//
//  UIVWindow+Extension.swift
//  MyWordle
//
//  Created by János Székely on 03/06/2024.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
}

//
//  ColorScemeManager.swift
//  MyWordle
//
//  Created by János Székely on 03/06/2024.
//

import SwiftUI

enum ColorSceme: Int {
    case unspecified, light, dark
}

class ColorScemeManager: ObservableObject {
    @AppStorage("colorScheme") var colorScheme: ColorSceme = .unspecified {
        didSet {
            applyColorScheme()
        }
    }
    
    func applyColorScheme() {
        UIWindow.key?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: colorScheme.rawValue)!
    }
}

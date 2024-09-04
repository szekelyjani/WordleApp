//
//  Color+Extension.swift
//  MyWordle
//
//  Created by János Székely on 29/05/2024.
//

import SwiftUI

extension Color {
    static var wrongColor: Color {
        Color(UIColor(named: "wrong")!)
    }
    static var misplacedColor: Color {
        Color(UIColor(named: "misplaced")!)
    }
    static var correctColor: Color {
        Color(UIColor(named: "correct")!)
    }
    static var unusedColor: Color {
        Color(UIColor(named: "unused")!)
    }
    static var systemBackground: Color {
        Color(.systemBackground)
    }
}

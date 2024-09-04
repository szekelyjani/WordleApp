//
//  Guess.swift
//  MyWordle
//
//  Created by János Székely on 29/05/2024.
//

import SwiftUI

struct Guess {
    let index: Int
    var word = "     "
    var bgColors = [Color](repeating: .wrongColor, count: 5)
    var cardFlipped = [Bool](repeating: false, count: 5)
    var guessLetters: [String] {
        word.map { String($0) }
    }
    
    var results: String {
        let tryColors: [Color: String] = [.misplacedColor: "🟨", .correctColor : "🟩", .wrongColor : "⬛"]
        return bgColors.compactMap { tryColors[$0]}.joined(separator: "")
    }
}

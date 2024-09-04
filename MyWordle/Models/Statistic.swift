//
//  Statistic.swift
//  MyWordle
//
//  Created by János Székely on 31/05/2024.
//

import Foundation

struct Statistic: Codable {
    var frequencies = [Int](repeating: 0, count: 6)
    var games = 0
    var streak = 0
    var maxStreak = 0
    
    var wins: Int {
        frequencies.reduce(0, +)
    }
    
    func saveStat() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "Stat")
        }
    }
    
    static func loadStat() -> Statistic {
        if let savedData = UserDefaults.standard.object(forKey: "Stat") as? Data {
            if let currentStat = try? JSONDecoder().decode(Statistic.self, from: savedData) {
                return currentStat
            } else {
                return Statistic()
            }
        } else {
            return Statistic()
        }
    }
    
    mutating func updateStat(win: Bool, index: Int? = nil) {
        games += 1
        streak = win ? streak + 1 : 0
        if win {
            frequencies[index!] += 1
            maxStreak = max(maxStreak, streak)
        }
        saveStat()
    }
}

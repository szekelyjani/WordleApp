//
//  KeyBoardView.swift
//  MyWordle
//
//  Created by János Székely on 30/05/2024.
//

import SwiftUI

struct KeyBoardView: View {
    @EnvironmentObject var dm: WordleDataModel
    var toRowArray = "QWERTYUIOP".map { String($0) }
    var middleRowArray = "ASDFGHJKL".map { String($0) }
    var buttomRowArray = "ZXCVBNM".map { String($0) }
    
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                ForEach(toRowArray, id: \.self) { letter in
                    LetterButtonView(letter: letter)
                }
                .disabled(dm.disabledKeys)
                .opacity(dm.disabledKeys ? 0.6 : 1)
            }
            HStack(spacing: 2) {
                ForEach(middleRowArray, id: \.self) { letter in
                    LetterButtonView(letter: letter)
                }
                .disabled(dm.disabledKeys)
                .opacity(dm.disabledKeys ? 0.6 : 1)
            }
            HStack(spacing: 2) {
                Button {
                    dm.enterWord()
                } label: {
                    Text("ENTER")
                }
                .font(.system(size: 18))
                .frame(width: 60, height: 50)
                .foregroundColor(.primary)
                .background(Color.unusedColor)
                .disabled(dm.currentWord.count < 5 || !dm.inPlay)
                .opacity((dm.currentWord.count < 5 || !dm.inPlay) ? 0.6 : 1)
                
                ForEach(buttomRowArray, id: \.self) { letter in
                    LetterButtonView(letter: letter)
                }
                .disabled(dm.disabledKeys)
                .opacity(dm.disabledKeys ? 0.6 : 1)
                
                Button {
                    dm.removeLetterFromCurrentWord()
                } label: {
                    Image(systemName: "delete.backward.fill")
                        
                }
                .font(.system(size: 20, weight: .heavy))
                .frame(width: 40, height: 50)
                .foregroundStyle(.primary)
                .background(Color.unusedColor)
                .disabled(dm.currentWord.count == 0 || !dm.inPlay)
                .opacity((dm.currentWord.count == 0 || !dm.inPlay) ? 0.6 : 1)
                
            }
        }
    }
}

#Preview {
    KeyBoardView()
        .environmentObject(WordleDataModel())
        .scaleEffect(Global.keyboardScale)
}

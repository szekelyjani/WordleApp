//
//  HelpView.swift
//  MyWordle
//
//  Created by János Székely on 04/06/2024.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(
                    """
Guess the **WORDLE** in 6. tries

Each guess must be valid 5 letter word. Hit the enter button to submit.

After each guess, the color of the tiles will change to show how cose your guess was to the word.
"""
                )
                Divider()
                Text("**Examples**")
                Image("Weary")
                    .resizable()
                    .scaledToFit()
                Text("The letter **W** is in the word and in the correct spot.")
                Image("Pills")
                    .resizable()
                    .scaledToFit()
                Text("The letter **I** is in the word but in the wrong spot.")
                Image("Vague")
                    .resizable()
                    .scaledToFit()
                Text("The letter **U** is not in the word in any spot.")
                Divider()
                Text("**Tap the NEW Button for a new WORDLE**")
            }
            .frame(width: min(Global.screenWidth - 40, 350))
            .navigationTitle("How To Play")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("**x**")
                    }
                }
            }
        }
    }
}

#Preview {
    HelpView()
}

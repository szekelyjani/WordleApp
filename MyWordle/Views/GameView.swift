//
//  GameView.swift
//  MyWordle
//
//  Created by János Székely on 29/05/2024.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var dm: WordleDataModel
    @State private var showSettings = false
    @State private var showHelp = false
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    Spacer()
                    VStack {
                        ForEach(0...5, id: \.self) { index in
                            GuessView(guess: $dm.guesses[index])
                            .modifier(Shake(animatableData: CGFloat(dm.incorrectAttempts[index])))
                        }
                    }
                    .frame(width: Global.boardWidth, height: 6 * Global.boardWidth / 5)
                    Spacer()
                    KeyBoardView()
                        .scaleEffect(Global.keyboardScale)
                        .padding(.top)
                    Spacer()
                }
                .disabled(dm.showStats)
                .overlay(alignment: .top) {
                    if let toastText = dm.toastText {
                        ToastView(toasText: toastText)
                            .offset(y: 20)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            if !dm.inPlay {
                                Button {
                                    dm.newGame()
                                } label: {
                                    Text("New")
                                }
                                .foregroundStyle(.primary)
                            }
                            Button {
                                showHelp.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("WORDLE")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(dm.hardMode ? Color(.systemRed) : .primary)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Button {
                                withAnimation {
                                    dm.showStats.toggle()
                                }
                            } label: {
                                Image(systemName: "chart.bar")
                            }
                            Button {
                                showSettings.toggle()
                            } label: {
                                Image(systemName: "gearshape.fill")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
                .sheet(isPresented: $showHelp) {
                    HelpView()
                }
            }
            if dm.showStats {
                StatsView()
            }
        }
    }
}

#Preview {
    GameView()
        .environmentObject(WordleDataModel())
}

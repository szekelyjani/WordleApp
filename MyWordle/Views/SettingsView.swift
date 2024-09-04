//
//  SettingsView.swift
//  MyWordle
//
//  Created by János Székely on 03/06/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dm: WordleDataModel
    @EnvironmentObject var csManager: ColorScemeManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Toggle("Hard Mode", isOn: $dm.hardMode)
                Text("Change Theme")
                Picker("Display Mode", selection: $csManager.colorScheme) {
                    Text("Dark").tag(ColorSceme.dark)
                    Text("Light").tag(ColorSceme.light)
                    Text("System").tag(ColorSceme.unspecified)
                }
                .pickerStyle(.segmented)
                Spacer()
            }
            .padding()
            .navigationTitle("Options")
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
    SettingsView()
        .environmentObject(ColorScemeManager())
        .environmentObject(WordleDataModel())
}

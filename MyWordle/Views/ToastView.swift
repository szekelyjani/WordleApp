//
//  ToastView.swift
//  MyWordle
//
//  Created by János Székely on 31/05/2024.
//

import SwiftUI

struct ToastView: View {
    let toasText: String
    var body: some View {
        Text(toasText)
            .foregroundStyle(Color(.systemBackground))
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(.primary))
    }
}

#Preview {
    ToastView(toasText: "Not in word list.")
}

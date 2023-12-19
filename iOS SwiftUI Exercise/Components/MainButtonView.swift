//
//  MainButtonView.swift
//  iOS SwiftUI Exercise
//
//  Created by Bekzod Rakhmatov on 19/12/23.
//

import SwiftUI

struct MainButtonView: View {
    
    @Binding var disabled: Bool
    let title: String
    let handler: () -> ()
    
    var body: some View {
        Button {
            handler()
        } label: {
            Text(title)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(disabled ? 0.5 : 1))
                .foregroundStyle(.white)
                .cornerRadius(18)
                .font(.system(size: 20, weight: .medium))
        }
        .disabled(disabled)
    }
}

#Preview {
    MainButtonView(disabled: .constant(true), title: "Button") {
        
    }
}

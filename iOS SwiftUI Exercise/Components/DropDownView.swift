//
//  DropDownView.swift
//  iOS SwiftUI Exercise
//
//  Created by Bekzod Rakhmatov on 19/12/23.
//

import SwiftUI

struct DropDownView: View {
    
    @Binding var title: String
    @Binding var disabled: Bool
    let placeholder: String
    
    var body: some View {
        HStack {
            ZStack {
                Text(placeholder)
                    .foregroundStyle(disabled ? .black : .dropDownPlaceholder)
                    .opacity(title.isEmpty ? 1 : 0)
                Text(title)
                    .foregroundStyle(.black)
                    .opacity(title.isEmpty ? 0 : 1)
            }
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundStyle(disabled ? .black : .dropDownPlaceholder)
        }
        .padding(.horizontal)
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .background(Color.dropDownBackground)
        .cornerRadius(18)
        .font(.system(size: 16))
        .opacity(disabled ? 0.25 : 1)
    }
}

#Preview {
    DropDownView(title: .constant("Model"), disabled: .constant(false), placeholder: "Model")
}

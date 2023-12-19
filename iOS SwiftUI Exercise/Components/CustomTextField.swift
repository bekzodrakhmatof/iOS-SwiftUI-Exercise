//
//  CustomTextField.swift
//  iOS SwiftUI Exercise
//
//  Created by Bekzod Rakhmatov on 19/12/23.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    @Binding var disabled: Bool
    let placeholder: String
    
    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder))
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
    CustomTextField(text: .constant(""), disabled: .constant(false), placeholder: "hello")
}

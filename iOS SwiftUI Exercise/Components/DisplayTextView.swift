//
//  DisplayTextView.swift
//  iOS SwiftUI Exercise
//
//  Created by Bekzod Rakhmatov on 19/12/23.
//

import SwiftUI

struct DisplayTextView: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .padding(.horizontal)
            .frame(height: 55)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.dropDownBackground)
            .cornerRadius(18)
            .font(.system(size: 16))
    }
}

#Preview {
    DisplayTextView(title: "")
}

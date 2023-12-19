//
//  NavigationTitleView.swift
//  iOS SwiftUI Exercise
//
//  Created by Bekzod Rakhmatov on 19/12/23.
//

import SwiftUI

struct NavigationTitleView: View {
    
    let title: String
    let handler: (() -> ())?
    
    init(title: String, handler: ( () -> Void)? = nil) {
        self.title = title
        self.handler = handler
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 28, weight: .semibold))
            Spacer()
            if let handler = handler {
                Button {
                    handler()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 26, height: 26)
                        .background(Color.closeButtonBackground)
                        .foregroundStyle(Color.closeButtonForeground)
                        .cornerRadius(13)
                }
            }
        }
        .frame(height: 41)
    }
}

#Preview {
    NavigationTitleView(title: "Main") {
        
    }
}

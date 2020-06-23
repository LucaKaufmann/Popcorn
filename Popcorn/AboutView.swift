//
//  AboutView.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 28.5.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    
    @Binding var isPresented: Bool
    var aboutUrl: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isPresented = false
                }) {
                    Text("Dismiss").foregroundColor(Color(hex: previewData.accentColor))
                }
            }.padding()
                .background(Color(hex: previewData.mainColor))
            MarkdownWrapperView(aboutUrl: aboutUrl)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(isPresented: Binding.constant(true), aboutUrl: "TEST")
    }
}

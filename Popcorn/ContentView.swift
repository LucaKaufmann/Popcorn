//
//  ContentView.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    TopicsRow(topicTitle: "Test")
                    TopicsRow(topicTitle: "Topic")
                    TopicsRow(topicTitle: "List")
                }
            }.navigationBarTitle(Text("Topics"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

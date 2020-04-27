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
                List(topicsData) { topic in
                    NavigationLink(destination: TopicDetail(topic: topic)) {
                        TopicsRow(topic: topic)
                    }
                }
            }.navigationBarTitle(Text("Topics"))
        }
    }
    
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

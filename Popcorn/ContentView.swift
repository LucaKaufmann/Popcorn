//
//  ContentView.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.purple.edgesIgnoringSafeArea(.all)
                VStack {
                    List {
                        ForEach(0..<appData.topics.count, id: \.self) { i in
                            NavigationLink(destination: TopicDetail(topic: appData.topics[i])) {
                                TopicsRow(topic: appData.topics[i])
                            }.listRowBackground(self.colorScheme == .light ? Color(hex: appData.backgroundColor) : Color(UIColor.systemBackground))
                        }
                    }
                }.navigationBarTitle(Text(appData.title), displayMode: .inline)
                    .background(NavigationConfigurator { nc in
                            nc.navigationBar.barTintColor = UIColor(hexString: appData.mainColor)
                            nc.navigationBar.titleTextAttributes =  [.foregroundColor : UIColor(hexString: appData.accentColor), .font : UIFont(name: "VALORANT", size: 25) ?? UIFont.systemFont(ofSize: 25)]
                })
                
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color(hex: appData.accentColor))
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           ContentView()
              .environment(\.colorScheme, .light)

           ContentView()
              .environment(\.colorScheme, .dark)
        }
    }
}

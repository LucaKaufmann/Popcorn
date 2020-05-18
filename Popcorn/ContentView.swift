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
    @EnvironmentObject var dataManager: DataManager
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.purple.edgesIgnoringSafeArea(.all)
                VStack {
                    List {
                        ForEach(0..<self.dataManager.appData.topics.count, id: \.self) { i in
                            NavigationLink(destination: TopicDetail(topic: self.dataManager.appData.topics[i])) {
                                TopicsRow(topic: self.dataManager.appData.topics[i])
                            }.listRowBackground(self.colorScheme == .light ? Color(hex: self.dataManager.appData.backgroundColor) : Color(UIColor.systemBackground))
                        }
                    }
                }.navigationBarTitle(Text(self.dataManager.appData.title), displayMode: .inline)
                    .background(NavigationConfigurator { nc in
                        nc.navigationBar.barTintColor = UIColor(hexString: self.dataManager.appData.mainColor)
                        nc.navigationBar.titleTextAttributes =  [.foregroundColor : UIColor(hexString: self.dataManager.appData.accentColor), .font : UIFont(name: self.dataManager.appData.font, size: 25) ?? UIFont.systemFont(ofSize: 25)]
                }).navigationBarItems(trailing:
                Button(action: {
                    self.dataManager.refreshData()
                }) {
                    Image(systemName: "arrow.clockwise")
                })
                
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .accentColor(Color(hex: dataManager.appData.accentColor))
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

//
//  TopicDetail.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI
import PopcornCore

struct TopicDetail: View {
    var topic: Topic
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
         VStack {
            List {
                ForEach(topic.subTopics) { subtopic in
                    NavigationLink(destination: SubtopicDetail(subTopic: subtopic, topic: self.topic)) {
                        Text(subtopic.title)
                    }.listRowBackground(Color(hex: self.dataManager.appData.backgroundColor))
                }
            }
         }.navigationBarTitle(topic.title)
    }
}

struct TopicDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TopicDetail(topic: previewData.topics[0])
        }
    }
}

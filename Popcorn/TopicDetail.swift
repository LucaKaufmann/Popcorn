//
//  TopicDetail.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI

struct TopicDetail: View {
    var topic: Topic
    var body: some View {
         VStack {
            List {
                ForEach(topic.subTopics) { subtopic in
                    NavigationLink(destination: SubtopicDetail(subTopic: subtopic)) {
                        Text(subtopic.title)
                    }.listRowBackground(Color(hex: appData.backgroundColor))
                }
            }
         }.navigationBarTitle(topic.title)
    }
}

struct TopicDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TopicDetail(topic: appData.topics[0])
        }
    }
}

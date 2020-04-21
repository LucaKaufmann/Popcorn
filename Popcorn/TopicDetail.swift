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
            List(topic.subTopics) { subtopic in
                NavigationLink(destination: SubtopicDetail(subTopic: subtopic)) {
                    Text(subtopic.title)
                }
                
            }
         }.navigationBarTitle(topic.title)
    }
}

struct TopicDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TopicDetail(topic: topicsData[0])
        }
    }
}

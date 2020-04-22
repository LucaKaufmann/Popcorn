//
//  SubtopicDetail.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI

struct SubtopicDetail: View {
    
    var subTopic: SubTopic
    var body: some View {
        VStack {
            List(subTopic.videos) { video in
                NavigationLink(destination: VideoDetailView(videoFile: video.url)) {
                    Text(video.title)
                }
                
            }
         }.navigationBarTitle(subTopic.title)
    }
}

struct SubtopicDetail_Previews: PreviewProvider {
    static var previews: some View {
        SubtopicDetail(subTopic: topicsData[0].subTopics[0])
    }
}

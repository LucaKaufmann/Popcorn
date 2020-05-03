//
//  SubtopicDetail.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI

struct SubtopicDetail: View {
    
    @State private var filter1 = true
    @State private var filter2 = true
    @State private var filter3 = true
    
    var subTopic: SubTopic
    var body: some View {
        VStack {
            HStack {
                if subTopic.hasFilter1 {
                    Toggle(isOn: $filter1) {
                        Text(subTopic.filters[0])
                    }.padding()
                }
                if subTopic.hasFilter2 {
                    Toggle(isOn: $filter2) {
                        Text(subTopic.filters[1])
                    }.padding()
                }
            }
            
            List(getVideos()) { video in
                NavigationLink(destination: VideoDetailView(videoFile: video)) {
                    Text(video.title)
                }
                
            }
         }.navigationBarTitle(subTopic.title)
    }
    
    func getVideos() -> [Video] {
        var filters = [String]()
        if subTopic.hasFilter1 && filter1 {
            filters.append(subTopic.filters[0].lowercased())
        }
        if subTopic.hasFilter2 && filter2 {
            filters.append(subTopic.filters[1].lowercased())
        }
        if filters.count == 0 || (filter1 && filter2) {
            return subTopic.videos
        } else {
            return subTopic.videosWith(filters: filters)
        }
        
    }
}

struct SubtopicDetail_Previews: PreviewProvider {
    static var previews: some View {
        SubtopicDetail(subTopic: topicsData[0].subTopics[0])
    }
}

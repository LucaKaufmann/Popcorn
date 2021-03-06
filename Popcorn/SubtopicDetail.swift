//
//  SubtopicDetail.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI
import PopcornCore

struct SubtopicDetail: View {
    
    @State private var filter1 = true
    @State private var filter2 = true
    @State private var filter3 = true
    @State private var filterIndex = 0
    @State private var subfilterIndex = 0
    @EnvironmentObject var dataManager: DataManager
    
    var subTopic: SubTopic
    var topic: Topic
    
    var body: some View {
        VStack {
            VStack {
                if subTopic.hasFilters {
                    Picker("Filters", selection: $filterIndex) {
                        ForEach(0 ..< subTopic.filters!.count) { index in
                            Text(self.subTopic.filters![index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                if subTopic.hasSubFilters {
                    Picker("Subfilters", selection: $subfilterIndex) {
                        ForEach(0 ..< subTopic.subfilters!.count) { index in
                            Text(self.subTopic.subfilters![index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                }

            }.background(Color(hex: dataManager.appData.backgroundColor))
            
            List {
                ForEach(getVideos()) { video in
                    NavigationLink(destination: VideoDetailView(videoFile: video)) {
                        VideoRow(video: video, topic: self.topic, subTopic: self.subTopic)
                    }.listRowBackground(Color(hex: self.dataManager.appData.backgroundColor))
                }
                
            }
         }.navigationBarTitle(subTopic.title)
    }
    
    func getVideos() -> [Video] {
        
        if subTopic.hasFilters && subTopic.hasSubFilters {
            return subTopic.videosWith(filter: subTopic.filters![filterIndex].lowercased(), subfilter: subTopic.subfilters![subfilterIndex].lowercased())
        } else if subTopic.hasFilters {
            return subTopic.videosWith(filter: subTopic.filters![filterIndex].lowercased(), subfilter: "all")
        } else if subTopic.hasSubFilters {
            return subTopic.videosWith(filter: "all", subfilter: subTopic.subfilters![subfilterIndex].lowercased())
        } else {
            return subTopic.videos
        }
        
    }
}

struct SubtopicDetail_Previews: PreviewProvider {
    static var previews: some View {
        SubtopicDetail(subTopic: previewData.topics[0].subTopics[0], topic: previewData.topics[0])
    }
}

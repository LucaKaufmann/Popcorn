//
//  VideoRow.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 11.5.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI

struct VideoRow: View {
    
    var video: Video
    var topic: Topic
    var subTopic: SubTopic
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        HStack {
            VStack {
                Text(video.title)
            }
            Spacer()
            ForEach(video.tags, id: \.self) { tag in
                if subTopic.contains(tag: tag) {
                    Text(tag)
                } else {
                    Text("")
                }
//                    AsyncImage(url:  URL(string: self.topic.getThumbnailUrlFor(tag: tag))!, placeholder: Text(""), cache: self.cache)
//                    .frame(minHeight: 40, maxHeight: 40)
//                    .aspectRatio(1 / 1, contentMode: .fit)
            }
        }
    }
}

struct VideoRow_Previews: PreviewProvider {
    static var previews: some View {
        VideoRow(video: previewData.topics[0].subTopics[0].videos[0], topic: previewData.topics[0], subTopic: previewData.topics[0].subTopics[0])
    }
}

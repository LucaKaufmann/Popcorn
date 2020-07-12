//
//  VideoRow.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 11.5.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI
import PopcornCore

struct VideoRow: View {
    
    var video: Video
    var topic: Topic
    var subTopic: SubTopic
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(video.title)
                Text("Submitted by \(video.author)").font(.system(size: 9)).foregroundColor(Color(hex: previewData.mainColor))
            }
            Spacer()
            ForEach(0 ..< self.video.tags.count) { index in
                if self.subTopic.contains(tag: self.video.tags[index]) {
                    AsyncImage(url:  URL(string: self.topic.getThumbnailUrlFor(tag: self.video.tags[index]))!, placeholder: Text("..."), cache: self.cache)
                        .frame(maxWidth: 22, maxHeight: 25)
                        .aspectRatio(contentMode: .fit)
                } else {
                    Text("")
                }

            }
        }
    }
}

struct VideoRow_Previews: PreviewProvider {
    static var previews: some View {
        VideoRow(video: previewData.topics[0].subTopics[0].videos[0], topic: previewData.topics[0], subTopic: previewData.topics[0].subTopics[0])
    }
}

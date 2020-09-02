//
//  TopicsRow.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI
import PopcornCore

struct TopicsRow: View {
    
    var topic: Topic
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        HStack {
            VStack {
                Text(topic.title)
            }
            Spacer()
//            AsyncImage(url:  URL(string: topic.topicThumbnailUrl)!, placeholder: Text("..."), cache: self.cache)
//            .frame(maxWidth: 22, maxHeight: 25)
//            .aspectRatio(contentMode: .fit)
            }.padding([.horizontal])
        
    }
}

struct TopicsRow_Previews: PreviewProvider {
    static var previews: some View {
        TopicsRow(topic: previewData.topics[0])
    }
}

//
//  TopicsRow.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI

struct TopicsRow: View {
    
    var topic: Topic
    
    var body: some View {
        HStack {
            VStack {
                Text(topic.title)
            }
            Spacer()
            Image(systemName: "book")
            }.padding([.horizontal])
        
    }
}

struct TopicsRow_Previews: PreviewProvider {
    static var previews: some View {
        TopicsRow(topic: previewData.topics[0])
    }
}

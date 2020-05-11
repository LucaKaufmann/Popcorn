//
//  SubtopicsRow.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI

struct SubtopicsRow: View {
    
    var subTopic: SubTopic
    
    var body: some View {
        HStack {
             VStack {
                 Text(subTopic.title)
             }
             Spacer()
             Image(systemName: "book")
         }.padding([.horizontal])
    }
}

struct SubtopicsRow_Previews: PreviewProvider {
    static var previews: some View {
        SubtopicsRow(subTopic: previewData.topics[0].subTopics[0])
    }
}

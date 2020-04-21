//
//  TopicsRow.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI

struct TopicsRow: View {
    
    var topicTitle: String = "Topic title"
    
    var body: some View {
        HStack {
            VStack {
                Text(topicTitle)
            }
            Spacer()
            Image(systemName: "book")
        }.padding([.horizontal])
        
    }
}

struct TopicsRow_Previews: PreviewProvider {
    static var previews: some View {
        TopicsRow()
    }
}

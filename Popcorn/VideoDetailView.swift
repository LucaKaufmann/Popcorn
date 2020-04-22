//
//  VideoDetailView.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 22.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import SwiftUI

struct VideoDetailView: View {
    
    @State var videoFile: String
    
    var body: some View {
        VideoView(videoFile: videoFile)
    }
}

struct VideoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VideoDetailView(videoFile: "Cats")
    }
}

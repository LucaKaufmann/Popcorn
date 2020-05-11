//
//  DataManager.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 11.5.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation

class DataManager: ObservableObject {
    
    @Published var appData: AppData = load("data.json")

    
    func refreshData() {
        print("Downloading new json")
        downloadFile(url: self.appData.url, completion: { success in
            DispatchQueue.main.async {
                self.appData = load("data.json")
            }
        })
    }
}

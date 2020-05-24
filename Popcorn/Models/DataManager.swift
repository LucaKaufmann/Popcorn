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
    
    func refreshData(completion: ((Bool) -> ())? = nil) {
        print("Downloading new json")
        downloadFile(url: self.appData.url, completion: { success in
            DispatchQueue.main.async {
                if success {
                    print("Successfully downloaded data, updating...")
                    self.appData = load("data.json")
                    UserDefaults.standard.set(Date(), forKey: LAST_UPDATE)
                }
                if let c = completion {
                    c(success)
                }
            }
        })
    }
    
    func updateIfNeeded() {
        if let lastUpdate = UserDefaults.standard.object(forKey: LAST_UPDATE) as? Date {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let d = df.string(from: lastUpdate)
            print("Last update \(d)")
            if let diff = Calendar.current.dateComponents([.hour], from: lastUpdate, to: Date()).hour, diff > 1 {
                print("Refreshing app data, last update over 1 hour ago")
                refreshData()
            }
        } else {
            print("No date set")
            refreshData()
        }
    }
    
    
}

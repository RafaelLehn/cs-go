//
//  cs_go_matchApp.swift
//  cs-go-match
//
//  Created by Evolua Tech on 07/03/25.
//

import SwiftUI

@main
struct CSTVApp: App {
    
    let apiService = APIService(apiKey: "v7fBmZOryI15ZcIIb-L_rRiH3riGqsSdNgXxGQkEuZlF6qFF5e0")
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(apiService)
        }
    }
}


//
//  SplashScreen.swift
//  cs-go-match
//
//  Created by Evolua Tech on 07/03/25.
//
import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @EnvironmentObject var apiService: APIService
    
    var body: some View {
        ZStack {
            Color(hex: "161621")
                .ignoresSafeArea()
            
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            MatchesListView()
                .environmentObject(apiService)
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
            .environmentObject(APIService(apiKey: "v7fBmZOryI15ZcIIb-L_rRiH3riGqsSdNgXxGQkEuZlF6qFF5e0"))
    }
}




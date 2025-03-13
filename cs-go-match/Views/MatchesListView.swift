//
//  MatchesListView.swift
//  cs-go-match
//
//  Created by Evolua Tech on 07/03/25.
//

import SwiftUI

struct MatchesListView: View {
    @EnvironmentObject var apiService: APIService
    @StateObject private var viewModel: MatchesViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: MatchesViewModel(apiService: APIService(apiKey: "")))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "161621")
                    .ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.matches.isEmpty {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.matches) { match in
                                NavigationLink(destination: MatchDetailView(matchId: match.id, preloadedMatch: match)) {
                                    MatchCard(match: match)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .refreshable {
                        viewModel.loadMatches()
                    }
                }
                
                if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Erro ao carregar partidas")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Tentar novamente") {
                            viewModel.loadMatches()
                        }
                        .padding()
                        .background(Color(hex: "f4ed42"))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color(hex: "272639"))
                    .cornerRadius(12)
                    .padding()
                }
            }
            .navigationTitle("Partidas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Partidas")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                viewModel.apiService = apiService
                
                if viewModel.matches.isEmpty {
                    viewModel.loadMatches()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MatchTimeIndicator: View {
    let date: Date
    
    var body: some View {
        Text(formattedDate)
            .font(.system(size: 12))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                CustomCornerShape(radius: 16, corners: [.topRight, .bottomLeft])
                    .fill(Color(hex: "505068"))
            )
            .frame(height: 36)
            .alignmentGuide(.top) { _ in 0 }
            .alignmentGuide(.trailing) { _ in 0 }
    }
    
    private var formattedDate: String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return "Hoje, \(formatter.string(from: date))"
        } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, HH:mm"
            formatter.locale = Locale(identifier: "pt_BR")
            return formatter.string(from: date).capitalized
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM HH:mm"
            return formatter.string(from: date)
        }
    }
}

struct MatchCard: View {
    let match: Match
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                if match.isLive {
                    LiveMatchIndicator()
                } else if let beginAt = match.beginAt {
                    MatchTimeIndicator(date: beginAt)
                }
            }
            VStack(alignment: .center) {
                HStack(spacing: 40) {
                    Spacer()
                    TeamView(team: match.opponents?.first?.opponent)
                    
                    Text("VS")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "6c6b7e"))
                    
                    TeamView(team: match.opponents?.count ?? 0 > 1 ? match.opponents?[1].opponent : nil)
                    Spacer()
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
            }
            
            Divider()
                .background(Color(hex: "2f2f47"))
            
            HStack {
                if let imageUrl = match.league?.imageUrl, !imageUrl.isEmpty {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Circle()
                            .fill(Color(hex: "c4c4c4"))
                    }
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color(hex: "c4c4c4"))
                        .frame(width: 20, height: 20)
                }
                
                Text("\(match.leagueName)")
                    .font(.caption)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
        .background(Color(hex: "272639"))
        .cornerRadius(16)
    }
}

struct LiveMatchIndicator: View {
    var body: some View {
        Text("AGORA")
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                CustomCornerShape(radius: 16, corners: [.topRight, .bottomLeft])
                    .fill(Color(hex: "f42a35"))
            )
            .frame(height: 36)
    }
}



struct TeamView: View {
    let team: Team?
    
    var body: some View {
        VStack(spacing: 8) {
            if let imageUrl = team?.imageUrl, !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Circle()
                        .fill(Color(hex: "c4c4c4"))
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color(hex: "c4c4c4"))
                    .frame(width: 60, height: 60)
            }
            
            Text(team?.name ?? "Time")
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }
}

struct CustomCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct MatchesListView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesListView()
            .environmentObject(APIService(apiKey: "preview_key"))
    }
}


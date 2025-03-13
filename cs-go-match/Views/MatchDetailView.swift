import SwiftUI

struct MatchDetailView: View {
    let matchId: Int
    let preloadedMatch: Match?
    @EnvironmentObject var apiService: APIService
    @StateObject private var viewModel: MatchDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(matchId: Int, preloadedMatch: Match? = nil) {
        self.matchId = matchId
        self.preloadedMatch = preloadedMatch
        _viewModel = StateObject(wrappedValue: MatchDetailViewModel(apiService: APIService(apiKey: "v7fBmZOryI15ZcIIb-L_rRiH3riGqsSdNgXxGQkEuZlF6qFF5e0")))
    }
    
    var body: some View {
        ZStack {
            Color(hex: "161621")
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            } else if let match = viewModel.match {
                ScrollView {
                    VStack(spacing: 24) {
                
                        HStack(spacing: 40) {
                            TeamDetailView(team: match.opponents?.first?.opponent)
                            
                            Text("VS")
                                .font(.headline)
                                .foregroundColor(Color(hex: "6c6b7e"))
                            
                            TeamDetailView(team: match.opponents?.count ?? 0 > 1 ? match.opponents?[1].opponent : nil)
                        }
                        .padding(.top, 20)
                        
                        if let beginAt = match.beginAt {
                            Text("Hoje, \(formatTime(beginAt))")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.top, 8)
                                .padding(.bottom, 16)
                        }
                        
                        if let opponents = match.opponents, opponents.count >= 2 {
                            VStack(spacing: 12) {
                                ForEach(0..<max(getPlayers(for: 0).count, getPlayers(for: 1).count, 5)) { index in
                                    PlayerRowContainer(
                                        leftPlayer: index < getPlayers(for: 0).count ? getPlayers(for: 0)[index] : nil,
                                        rightPlayer: index < getPlayers(for: 1).count ? getPlayers(for: 1)[index] : nil
                                    )
                                }
                            }
                        }
                    }
                    
                }
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text("Erro ao carregar detalhes")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Tentar novamente") {
                        viewModel.loadMatchDetails(matchId: matchId, preloadedMatch: preloadedMatch)
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
        .navigationTitle(viewModel.match?.leagueName ?? "Detalhes da Partida")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if let match = viewModel.match {
                    Text("\(match.leagueName) + série")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            viewModel.apiService = apiService
            viewModel.loadMatchDetails(matchId: matchId, preloadedMatch: preloadedMatch)
        }
    }
    
    private func getPlayers(for teamIndex: Int) -> [Player] {
        if teamIndex == 0, let players = viewModel.team1?.players {
            return players
        } else if teamIndex == 1, let players = viewModel.team2?.players {
            return players
        }
        
        guard let opponents = viewModel.match?.opponents,
              opponents.count > teamIndex,
              let team = opponents[teamIndex].opponent,
              let players = team.players else {
            return []
        }
        return players
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct TeamDetailView: View {
    let team: Team?
    
    var body: some View {
        VStack(spacing: 12) {
            if let imageUrl = team?.imageUrl, !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Circle()
                        .fill(Color(hex: "c4c4c4"))
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color(hex: "c4c4c4"))
                    .frame(width: 80, height: 80)
            }
            
            Text(team?.name ?? "Time")
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }
}

struct PlayerRowContainer: View {
    let leftPlayer: Player?
    let rightPlayer: Player?
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .trailing) {
                Color(hex: "272639")
                
                HStack(spacing: 12) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(leftPlayer?.name ?? "Nickname")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(leftPlayer?.fullName ?? "Nome Jogador")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "6c6b7e"))
                    }
                    
                    
                    PlayerImageView(imageUrl: leftPlayer?.imageUrl)
                        .padding(.bottom, 20)
                }
            }.cornerRadius(12)
                .padding(.horizontal, 8)
            
            Spacer().frame(width: 12)
            ZStack(alignment: .leading) {
                Color(hex: "272639")
                
                HStack(spacing: 12) {
                    PlayerImageView(imageUrl: rightPlayer?.imageUrl)
                        .padding(.bottom, 20)
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(rightPlayer?.name ?? "Nickname")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(rightPlayer?.fullName ?? "Nome Jogador")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "6c6b7e"))
                    }
                }
            }.cornerRadius(12)
                .padding(.horizontal, 8)
        }
        .frame(height: 54)
        .padding(.vertical, 1)
    }
}

struct PlayerImageView: View {
    let imageUrl: String?
    
    var body: some View {
        if let imageUrl = imageUrl, !imageUrl.isEmpty {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .fill(Color(hex: "c4c4c4"))
            }
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            Rectangle()
                .fill(Color(hex: "c4c4c4"))
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct MatchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MatchDetailView(matchId: 1)
                .environmentObject(APIService(apiKey: "v7fBmZOryI15ZcIIb-L_rRiH3riGqsSdNgXxGQkEuZlF6qFF5e0"))
        }
    }
}


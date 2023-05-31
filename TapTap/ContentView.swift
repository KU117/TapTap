import SwiftUI

class GameVars: ObservableObject {
    // Player cheat
    @AppStorage("Cheated") public var chtd: Bool = false
    // Main points
    @AppStorage("coinz") public var coins: Int = 0
    // Click Upgrade
    @AppStorage("oneClickUpg") public var oCU: Int = 1
    @AppStorage("oneCUCost") public var OCUCost: Int = 200
    // AutoClick Upgrade
    @AppStorage("autoClickUpg") public var aCU: Int = 0
    @AppStorage("autoCUCost") public var aCUCost: Int = 4000
    // UltraClick Upgrade
    @AppStorage("ultraClickUpg") public var uCU: Int = 0
    @AppStorage("ultraCUCost") public var uCUCost: Int = 10000
    // Shop view
    @Published var showShopView: Bool = false
    // Achievements view
    @Published var showAchievementsView: Bool = false
}

class ViewModel: ObservableObject {
    @StateObject var GameV = GameVars()
    

    init() {
        startTimer()
    }

    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.GameV.coins += self.GameV.aCU
            self.GameV.objectWillChange.send()
        }
    }
}

// Main view
struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    @StateObject private var achs = achievements()
    
    @State var devMode = false
    // Import GameVars vars
    @StateObject var GameV = GameVars()
    // Formating coins value
    var formattedCoins: String {
        if GameV.coins >= 1_000_000_000_000{
            return "\(GameV.coins / 1_000_000_000_000)t"
        } else if GameV.coins >= 1_000_000_000{
            return "\(GameV.coins / 1_000_000_000)b"
        } else if GameV.coins >= 1_000_000 {
            return "\(GameV.coins / 1_000_000)m"
        } else if GameV.coins >= 100_000 {
            return "\(GameV.coins / 1_000)k"
        } else {
            return "\(GameV.coins)"
        }
    }
    // Body
    var body: some View {
        // .../s coins
        let ClickTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//        let UltraClickTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
        Group {
            
            NavigationView {
                
                VStack {
                    
                    Spacer()
                    
                    // Tap Tap text
                    
                    if GameV.chtd {
                        Text("Tap Tap! {DEBUG}")
                            .font(.system(size: 20))
                            .onChange(of: GameV.chtd) { newValue in }
                    } else {Text("Tap Tap!").font(.system(size: 30)).onChange(of: GameV.chtd) { newValue in }}
                    
                    
                    // Coins
                    
                    Text("\(formattedCoins)")
                        .font(.system(size: 80))
                        .onChange(of: GameV.coins) { newValue in }
                        .onReceive(ClickTimer) { _ in
                            GameV.coins += GameV.aCU
                            GameV.coins += GameV.uCU
                        }
//                        .onReceive(UltraClickTimer) { _ in
//                            if GameV.uCU > 0 {
//                                GameV.coins += GameV.uCU
//                            }
//                        }
                    // Main click button
                    
                    Button("- - Kliknij - -") {
                        GameV.coins += GameV.oCU
                        if !achs.aO {
                            achs.aOP += GameV.oCU
                            achs.aTP += GameV.oCU
                        }
                    }
                        .tint(.pink)
                        .buttonStyle(.borderedProminent)
                    
                    Divider()
                    
                    // Upgreade shop
                    
                    Button("SKLEP Z ULEPSZENIAMI") {
                        GameV.showShopView = true
                    }
                    .tint(.pink)
                    .buttonStyle(.borderedProminent)
                    Button("OSIĄGNIĘCIA | BETA") {
                        GameV.showAchievementsView = true
                    }
                    .disabled(false)
                    .tint(.pink)
                    .buttonStyle(.borderedProminent)
                    VStack {
                        
                        Divider()
                        
                        // Debugging
                        
                        Button("Debugging") {
                            if self.devMode == false {
                                self.devMode = true
                            } else {
                                self.devMode = false
                            }
                            
                        }
                            .foregroundColor(.blue)
                            .fontWeight(.heavy)
                        
                        Button("Reset progress") {
                            GameV.coins = 0
                            GameV.oCU = 1
                            GameV.OCUCost = 200
                            GameV.chtd = false
                            GameV.aCU = 0
                            GameV.aCUCost = 4000
                            GameV.uCUCost = 10000
                            GameV.uCU = 0
                            achs.aO = false
                            achs.aOP = 0
                            achs.aT = false
                            achs.aTP = 0
                        }
                            .tint(.blue)
                            
                            .opacity(devMode ? 1 : 0)
                        
                        Button("+10.000") {
                            GameV.coins += 10000
                            GameV.chtd = true
                        }
                            .tint(.blue)
                            
                            .opacity(devMode ? 1 : 0)
                        Button("CompleteAch1") {
                            achs.aOP = 1000
                        }
                            .tint(.blue)
                            
                            .opacity(devMode ? 1 : 0)
                        Button("CompleteAch2") {
                            achs.aTP = 10000
                        }
                            .tint(.blue)
                            
                            .opacity(devMode ? 1 : 0)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .padding()
            .navigationTitle("Gra")
            .sheet(isPresented: $GameV.showShopView) {
                ShopView()
                    .environmentObject(GameV)
            }
            .sheet(isPresented: $GameV.showAchievementsView) {
                AchievementsView()
                    .environmentObject(GameV)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

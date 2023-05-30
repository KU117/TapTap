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
    public var showShopView: Bool = false
    
    // Idle timer
    private var idleTimer: Timer?
    private let idleTimeInterval: TimeInterval = 1 // Change the interval as needed
    
    init() {
        setupIdleTimer()
    }
    
    private func setupIdleTimer() {
        idleTimer = Timer.scheduledTimer(withTimeInterval: idleTimeInterval, repeats: true) { [weak self] _ in
            self?.addIdleCoins()
        }
        idleTimer?.tolerance = 0.1
        idleTimer?.fire()
    }
    
    private func addIdleCoins() {
        coins += Int(0.5 * Double(uCU))
        coins += Int(1 * Double(aCU))
    }

    func resetIdleTimer() {
        idleTimer?.invalidate()
        setupIdleTimer()
    }
}

// Main view
struct ContentView: View {
    
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
        let AutoClickTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        let UltraClickTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
        Group {
            
            NavigationView {
                
                VStack {
                    
                    Spacer()
                    
                    // Tap Tap text
                    
                    if GameV.chtd {
                        Text("Nie ładnie oszukiwać")
                            .font(.system(size: 20))
                            .onChange(of: GameV.chtd) { newValue in }
                    } else {Text("Tap Tap!").font(.system(size: 30)).onChange(of: GameV.chtd) { newValue in }}
                    
                    
                    // Coins
                    
                    Text("\(formattedCoins)")
                        .font(.system(size: 80))
                        .onChange(of: GameV.coins) { newValue in }
                        .onReceive(AutoClickTimer) { _ in
                            // Ta funkcja zostanie wywołana co sekundę
                            GameV.coins += GameV.aCU
                        }
                        .onReceive(UltraClickTimer) { _ in
                            GameV.coins += GameV.uCU
                        }
                        .onAppear {
                            GameV.resetIdleTimer()
                        }
                        .onDisappear {
                            GameV.resetIdleTimer()
                        }
                    
                    // Main click button
                    
                    Button("- - Kliknij - -") { GameV.coins += GameV.oCU }
                        .tint(.pink)
                        .buttonStyle(.borderedProminent)
                    
                    Divider()
                    
                    // Upgreade shop
                    
                    Button("SKLEP Z ULEPSZENIAMI") {
                        // Ustaw wartość flagi `showShopView` na true
                        GameV.showShopView = true
                    }
                    .tint(.pink)
                    .buttonStyle(.borderedProminent)
                    Button("OSIĄGNIĘCIA") {

                    }
                    .disabled(true)
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
                        
                        Button("Reset") {
                            GameV.coins = 0
                            GameV.oCU = 1
                            GameV.OCUCost = 200
                            GameV.chtd = false
                            GameV.aCU = 0
                            GameV.aCUCost = 4000
                            GameV.uCUCost = 10000
                            GameV.uCU = 0
                        } .tint(.blue)
                            .opacity(devMode ? 1 : 0)
                        
                        Button("RuinTheFun") {
                            GameV.coins += 10000
                            GameV.chtd = true
                        } .tint(.blue)
                            .opacity(devMode ? 1 : 0)
                        
                    }
                }
            }
            .padding()
            .navigationTitle("Gra")
            .sheet(isPresented: $GameV.showShopView) {
                ShopView()
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

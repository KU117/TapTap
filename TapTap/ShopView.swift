//
//  ShopView.swift
//  TapTap
//
//  Created by konto on 29/05/2023.
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var ContentView: GameVars
    var body: some View {
        Group {
            VStack {
                Text("Sklep")
                    .font(.system(size:50))
                    .foregroundColor(.pink)
                    .fontWeight(.heavy)
                Divider()
                Button("Kliknięcie +\(ContentView.oCU) - \(ContentView.OCUCost) ") {
                    if ContentView.coins >= ContentView.OCUCost {
                        ContentView.coins -= ContentView.OCUCost
                        if ContentView.OCUCost == 200 {
                            ContentView.OCUCost += 800
                        } else {
                            ContentView.OCUCost += 1000
                        }
                        
                        if ContentView.oCU == 1 {
                            ContentView.oCU += 1
                        } else {
                            ContentView.oCU += 2
                        }
                    }
                }
                .tint(.pink)
                .buttonStyle(.borderedProminent)
                
                Button("AutoClick \(ContentView.aCU)/s - \(ContentView.aCUCost)") {
                    if ContentView.coins >= ContentView.aCUCost {
                        ContentView.coins -= ContentView.aCUCost
                        ContentView.aCUCost += 4000
                        if ContentView.aCU <= 1 {
                            ContentView.aCU += 1
                        } else if ContentView.aCU <= 30 {
                            ContentView.aCU += 4
                        } else if ContentView.aCU <= 40 {
                            ContentView.aCU += 10
                        } else {
                            ContentView.aCU += 50
                        }
                        
                    }
                }
                .tint(.pink)
                .buttonStyle(.borderedProminent)
                Button("UltraClick \(ContentView.uCU)/s - \(ContentView.uCUCost)") {
                    if ContentView.coins >= ContentView.uCUCost {
                        ContentView.coins -= ContentView.uCUCost
                        ContentView.uCUCost += 10000
                        if ContentView.uCU <= 10 {
                            ContentView.uCU += 10
                        } else if ContentView.uCU <= 30 {
                            ContentView.uCU += 50
                        } else if ContentView.uCU >= 610{
                            ContentView.uCU += 100
                        } else {
                            ContentView.uCU += 150
                        }
                        
                    }
                }
                .tint(.pink)
                .buttonStyle(.borderedProminent)
                Divider()
                Text("© Karol Urbański 2023")
                    .foregroundColor(.red)
            }
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}

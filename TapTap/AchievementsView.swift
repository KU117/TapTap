import SwiftUI

struct AchievementsView: View {
    @StateObject var achs = achievements()
    
    public var achSize: CGFloat = 20
    
    init() {
        if achs.aOP >= 1000 {
            achs.aO = true
        } else {
            achs.aO = false
        }
        if achs.aTP >= 10000 {
            achs.aT = true
        } else {
            achs.aT = false
        }
    }
    var body: some View {
        Group {
            VStack {
                Text("Osiągnięcia")
                    .font(.system(size: 50))
                    .foregroundColor(.pink)
                    .fontWeight(.heavy)
                Divider()
                Group {
                    if achs.aO {
                        Text("Kliknij 1000 razy (\(achs.aOP)/1000)")
                            .foregroundColor(.green)
                            .font(.system(size: achSize, design: .rounded))
                            .padding()
                    } else {
                        Text("Kliknij 1000 razy (\(achs.aOP)/1000)")
                            .foregroundColor(.red)
                            .font(.system(size: achSize, design: .rounded))
                            .padding()
                    }
                    if achs.aT {
                        Text("Kliknij 10000 razy (\(achs.aTP)/10000)")
                            .foregroundColor(.green)
                            .font(.system(size: achSize, design: .rounded))
                            .padding()
                    } else {
                        Text("Kliknij 10000 razy (\(achs.aTP)/10000)")
                            .foregroundColor(.red)
                            .font(.system(size: achSize, design: .rounded))
                            .padding()
                    }

                    Divider()
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .padding()
        }
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}

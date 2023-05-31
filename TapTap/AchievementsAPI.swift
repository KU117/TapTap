import Foundation
import SwiftUI

class achievements: ObservableObject {
    @AppStorage("Achv1") public var aO = false
    @AppStorage("Achv1prg") public var aOP = 0
    @AppStorage("Achv2") public var aT = false
    @AppStorage("Achv2prg") public var aTP = 0
}

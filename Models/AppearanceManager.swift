import SwiftUI

class AppearanceManager: ObservableObject {

    @AppStorage("FontKey") var font: String = ""

    
    public let fonts = [
        FontOption(fontName: "", displayName: "System"),
        FontOption(fontName: "CourierPrime-Regular", displayName: "Courier Prime"),
        FontOption(fontName: "JetBrainsMono-Regular", displayName: "JetBrains Mono"),
        FontOption(fontName: "RobotoMono-Regular", displayName: "Roboto"),
        FontOption(fontName: "UbuntuMono-Regular", displayName: "Ubuntu"),
        FontOption(fontName: "VictorMono-Regular", displayName: "Victor"),
        FontOption(fontName: "TimesNewRomanPSMT", displayName: "Times New Roman"),
        FontOption(fontName: "TrebuchetMS", displayName: "Trebuchet"),
    ]
}

struct FontOption: Identifiable, Hashable{
    let fontName: String
    let displayName: String
    
    var id: String { fontName }
}

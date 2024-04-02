import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appearanceManager: AppearanceManager
    
    var body: some View {
        Form {
            FontSelectionView()
        }
    }
}

struct FontSelectionView: View {
    @EnvironmentObject var appearanceManager: AppearanceManager

    var body: some View {
        Section(header: Text("Fonts")) {
            VStack(alignment: .leading) {
                ForEach(appearanceManager.fonts, id: \.self) { font in
                    FontButton(font: font)
                }
                .padding(.vertical, 5)
            }
        }
    }
}

struct FontButton: View {
    @EnvironmentObject var appearanceManager: AppearanceManager

    let font: FontOption
    var isSelected: Bool {
        appearanceManager.font == font.fontName
    }


    var body: some View {
        HStack {
            Text(font.displayName)
                .font(.custom(font.fontName, size: 17, relativeTo: .body))
            Spacer()
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(isSelected ? .secondary : .clear)
                .overlay(
                    Circle()
                        .stroke(Color.primary, lineWidth: 2)
                )
        }
        .foregroundColor(.secondary)
        .onTapGesture {
            withAnimation {
                appearanceManager.font = font.fontName
            }
        }
    }
}




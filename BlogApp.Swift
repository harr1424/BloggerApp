import SwiftUI

@main
struct BlogApp: App {
    @StateObject private var appearanceManager = AppearanceManager()
    @StateObject var viewModel: AppViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .environmentObject(appearanceManager)
        }
    }
}
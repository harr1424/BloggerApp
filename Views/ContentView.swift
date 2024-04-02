import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SavedPosts(viewModel: viewModel)
                .tag(0)
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Saved")
                }
            
            RecentPosts(viewModel: viewModel)
                .tag(1)
                .tabItem {
                    Image(systemName: "tray")
                    Text("Recent")
                }
            
            AllPosts(viewModel: viewModel)
                .tag(2)
                .tabItem {
                    Image(systemName: "book.pages")
                    Text("Archives")

                }
        }
        .padding(.bottom, 8)
        .accentColor(.blue)
        .navigationViewStyle(.stack)
    }
}

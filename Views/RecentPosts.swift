import SwiftUI

struct RecentPosts: View {
    @StateObject var viewModel: AppViewModel
    @EnvironmentObject var appearanceManager: AppearanceManager

    @State private var isInfoPresented = false
    @State private var isSettingsPresented = false


    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    ProgressView("Loading Recent Posts")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List {
                        ForEach(filteredPosts, id: \.title) { post in
                            NavigationLink(destination: PostView(viewModel: viewModel, post: post)) {
                                Text(post.title)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.getRecentPosts()
                        }
                    }
                }
            }
            .padding(.bottom, 10)
            .navigationTitle("Recent Posts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isInfoPresented.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .font(.headline)
                    }
                    .sheet(isPresented: $isInfoPresented) {
                        InfoView()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSettingsPresented.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .font(.headline)
                    }
                    .sheet(isPresented: $isSettingsPresented) {
                        SettingsView()
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }


    
    private var filteredPosts: [Post] {
        return viewModel.recentPosts
    }
}

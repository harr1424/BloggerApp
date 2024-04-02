import SwiftUI

struct SavedPosts: View {
    @ObservedObject var viewModel: AppViewModel

    @State private var searchText = ""
    @State private var searchType: SearchType = .content
    
    @State private var isInfoPresented = false
    @State private var isSettingsPresented = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Search By", selection: $searchType) {
                    Text("Search Title").tag(SearchType.title)
                    Text("Search Post Content").tag(SearchType.content)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                SearchBar(text: $searchText)
                    .padding(.top, 5)
                
                List {
                    ForEach(filteredPosts, id: \.title) { post in
                        NavigationLink(destination: SavedPostView(viewModel: viewModel, post: post)) {
                            Text(post.title)
                        }
                    }
                    .onDelete(perform: removeSavedPost)
                }
                .listStyle(PlainListStyle())
            }
            .padding(.bottom, 10)
            .navigationTitle("Saved Posts")
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
        }
        .navigationViewStyle(StackNavigationViewStyle()) 
    }
    
    private var filteredPosts: [SavedPost] {
        return viewModel.savedPosts.filter { post in
            (searchText.isEmpty ||
            (searchType == .title && post.title.localizedCaseInsensitiveContains(searchText)) ||
            (searchType == .content && (post.content.localizedCaseInsensitiveContains(searchText))))
        }
        .sorted { $0.date > $1.date}
    }
    
    func removeSavedPost(at offsets: IndexSet) {
        for offset in offsets {
            let localPost = filteredPosts[offset]
            viewModel.toggleSavedPostsMembership(post: localPost)
        }
    }
}

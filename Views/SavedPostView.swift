import SwiftUI

struct SavedPostView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var appearanceManager: AppearanceManager
    
    var post: SavedPost
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.toggleSavedPostsMembership(post: post)
                    }) {
                        Image(systemName: viewModel.savedPosts.contains(where: { $0.title == post.title }) ? "bookmark.fill" : "bookmark")
                            .foregroundColor(viewModel.savedPosts.contains(where: { $0.title == post.title }) ? .blue : .gray)
                            .font(.system(size: 30))
                    }
                    .padding()
                    
                }
            
            
            Text(post.title)
                .font(.custom(appearanceManager.font, size: 30, relativeTo: .title))
            
            ForEach(paragraphs(from: post.content), id: \.self) { paragraph in
                Text(paragraph + ".")
                    .font(.custom(appearanceManager.font, size: 17, relativeTo: .body))
                    .padding(.bottom, 8)
            }
        }
            
            Link("View this post online", destination: URL(string: post.url)!)
                .padding()
        }
        .padding()
    }
}

private func paragraphs(from content: String) -> [String] {
    return content.components(separatedBy: ". ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
}


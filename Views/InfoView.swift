import SwiftUI

struct InfoView: View {
    @EnvironmentObject var appearanceManager: AppearanceManager

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                Text("Welcome!")
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .font(.custom(appearanceManager.font, size: 30, relativeTo: .title))
                    .padding()
                
                Text("This app allows you to access the entire catalog of posts since the blog was first created. " +
                     "Posts are stored on your device, and no network connection is required except for fetching new posts. " +
                     "Posts can be quickly searched and saved.")
                .font(.custom(appearanceManager.font, size: 17, relativeTo: .body))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .padding()

                Text("The app has some limitations:")
                    .font(.custom(appearanceManager.font, size: 17, relativeTo: .body))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .padding()
                
                
                Text("Photos in posts will not appear in this app. This allows for the entire blog's history to be stored " +
                     "on your device without taking up too much space.")
                .multilineTextAlignment(.leading)
                .font(.custom(appearanceManager.font, size: 17, relativeTo: .body))
                .foregroundColor(.primary)
                .padding()
                
                Text("Posts are collected from the website every hour, and so may not immediately appear in this app.")
                    .multilineTextAlignment(.leading)
                    .font(.custom(appearanceManager.font, size: 17, relativeTo: .body))
                    .foregroundColor(.primary)
                    .padding()

                Text("Care has been taken to preserve as much of the original formatting as possible, but there is not a solution " +
                     "flexible enough to handle all situations. Lists are particularly problematic. For this reason, a link has been included " +
                     "with every post to view it online.")
                .multilineTextAlignment(.leading)
                .font(.custom(appearanceManager.font, size: 17, relativeTo: .body))
                .foregroundColor(.primary)
                .padding()
                
                Spacer()
                
                Link("Visit the Blog", destination: URL(string: blog_url)!)
                    .foregroundColor(.blue)
                    .underline()
                    .font(.custom(appearanceManager.font, size: 30, relativeTo: .title))
                    .padding()
                
                Spacer()
                
                Link("Privacy Policy", destination: URL(string: privacy_url)!)
                    .foregroundColor(.blue)
                    .underline()
                    .font(.custom(appearanceManager.font, size: 30, relativeTo: .title))
                    .padding()

                Spacer()
            }
            .padding()
        }
    }
}

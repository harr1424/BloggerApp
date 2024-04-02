import SwiftUI

class AppViewModel: ObservableObject {
    @Published var isLoading = true
    
    @Published var allPosts: [Post] = [] {
        didSet {
            objectWillChange.send()
            saveAllPostsToFileAsync(posts: allPosts)
        }
    }
    
    @Published var savedPosts: [SavedPost] = [] {
        didSet {
            objectWillChange.send()
            saveSavedPostsToFileAsync(savedPosts: savedPosts)
        }
    }
    
    @Published var recentPosts: [Post] = [] {
        didSet {
            objectWillChange.send()
        }
    }
    
    init() {
        self.allPosts = parseAllPosts()
        self.savedPosts = parseSavedPosts()
        getRecentPosts()
    }
    
    func parseAllPosts() -> [Post] {
        // Check if data has already been loaded from the bundle
        if !allPosts.isEmpty {
            return allPosts
        }
        
        do {
            // Get the app's documents directory
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            // Append the filename to the documents directory
            let fileURL = documentsDirectory.appendingPathComponent("backup.json")
            
            // Check if data is available in the writable file
            if FileManager.default.fileExists(atPath: fileURL.path) {
                print("allPosts data was found in documentsDir. Reading it now.")
                let jsonData = try Data(contentsOf: fileURL)
                let posts = try JSONDecoder().decode([Post].self, from: jsonData)
                return posts
            } else {
                // Load from the bundle if the writable file doesn't exist
                guard let bundleURL = Bundle.main.url(forResource: "backup", withExtension: "json") else {
                    fatalError("Couldn't find 'backup.json' in the main bundle.")
                }
                print("allPosts data is being read from app bundle.")
                let jsonData = try Data(contentsOf: bundleURL)
                let posts = try JSONDecoder().decode([Post].self, from: jsonData)
                return posts
            }
        } catch let error {
            fatalError("Error loading JSON: \(error)")
        }
    }
    
    func parseSavedPosts() -> [SavedPost] {
        // Check if data has already been loaded from the bundle
        if !savedPosts.isEmpty {
            return savedPosts
        }
        
        do {
            // Get the app's documents directory
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            // Append the filename to the documents directory
            let fileURL = documentsDirectory.appendingPathComponent("savedPosts.json")
            
            // Check if data is available in the writable file
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let jsonData = try Data(contentsOf: fileURL)
                let posts = try JSONDecoder().decode([SavedPost].self, from: jsonData)
                return posts
            }
        } catch let error {
            fatalError("Error loading savedPosts JSON: \(error)")
        }
        
        // If no data found, return an empty array
        return []
    }
    
    func saveAllPostsToFile(posts: [Post]) {
        do {
            // Get the app's documents directory
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            // Append the filename to the documents directory
            let fileURL = documentsDirectory.appendingPathComponent("backup.json")
            
            // Encode and write the data to the file
            let jsonData = try JSONEncoder().encode(posts)
            try jsonData.write(to: fileURL, options: .atomic)
            
            print("Saved allPosts data to documentsDir.")
        } catch let error {
            fatalError("Error encoding/saving JSON: \(error)")
        }
    }
    
    func saveSavedPostsToFile(savedPosts: [SavedPost]) {
        do {
            // Get the app's documents directory
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            // Append the filename to the documents directory
            let fileURL = documentsDirectory.appendingPathComponent("savedPosts.json")
            
            // Encode and write the data to the file
            let jsonData = try JSONEncoder().encode(savedPosts)
            try jsonData.write(to: fileURL, options: .atomic)
        } catch let error {
            fatalError("Error encoding/saving savedPosts JSON: \(error)")
        }
    }
    
    func saveAllPostsToFileAsync(posts: [Post]) {
        DispatchQueue.global(qos: .background).async {
            self.saveAllPostsToFile(posts: posts)
        }
    }
    
    func saveSavedPostsToFileAsync(savedPosts: [SavedPost]) {
        DispatchQueue.global(qos: .background).async {
            self.saveSavedPostsToFile(savedPosts: savedPosts)
        }
    }
    
    func toggleSavedPostsMembership(post: Post) {
        if savedPosts.contains(where: { $0.title == post.title }) {
            savedPosts.removeAll(where:{ $0.title == post.title })
        }
        
        else {
            let newSavedPost = SavedPost(id: post.id, title: post.title, content: post.content, url: post.url)
            savedPosts.append(newSavedPost)
        }
    }
    
    func toggleSavedPostsMembership(post: SavedPost) {
        if savedPosts.contains(where: { $0.title == post.title }) {
            savedPosts.removeAll(where:{ $0.title == post.title })
        }
        
        else {
            let newSavedPost = SavedPost(id: post.id, title: post.title, content: post.content, url: post.url)
            savedPosts.append(newSavedPost)
        }
    }
    
    func getRecentPosts() {
        isLoading = true
        
        guard let url = URL(string: server_url) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                print("Error fetching posts: \(error?.localizedDescription ?? "Unknown error")")
                self?.isLoading = false
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                
                DispatchQueue.main.async {
                    for recentPost in posts {
                        if !self.allPosts.contains(where: { $0.title == recentPost.title }) {
                            self.allPosts.append(recentPost)
                            print("Appended \(recentPost.title) to allPosts")
                        }
                    }
                    self.recentPosts = posts
                    self.isLoading = false
                }
                
            } catch {
                print("Error decoding posts: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
}

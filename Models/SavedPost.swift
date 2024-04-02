import SwiftUI

class SavedPost: ObservableObject, Identifiable, Decodable, Encodable {
    var id: String
    var title: String
    var content: String
    var url: String
    var date: Date
    
    init(id: String, title: String, content: String, url: String, date: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.url = url
        self.date = date
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? AutoIncrementingIdGenerator.nextId()
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        url = try container.decode(String.self, forKey: .URL)
        date = Date()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(url, forKey: .URL)
        try container.encode(date, forKey: .date)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, content, URL, date
    }
}


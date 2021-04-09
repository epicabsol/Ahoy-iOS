//
//  Post.swift
//  Ahoy
//
//  Created by Ben Garcia on 4/8/21.
//

import Foundation

public class Post {
    let id: Int
    let author: String
    let content: String
    
    public init(id: Int, author: String, content: String) {
        self.id = id
        self.author = author
        self.content = content
    }
    
    public init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int, let author = dictionary["author"] as? String, let content = dictionary["content"] as? String else { return nil }
        self.id = id
        self.author = author
        self.content = content
    }
    
    public func toDictionary() -> [String: Any] {
        return [ "id": self.id, "author": self.author, "content": self.content ]
    }
}

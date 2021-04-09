//
//  MessageCell.swift
//  Ahoy
//
//  Created by Ben Garcia on 4/8/21.
//

import Foundation
import UIKit

public class PostCell: UITableViewCell {
    
    public var post: Post? = nil {
        didSet {
            if let post = self.post {
                self.contentLabel.text = post.content.localizedUppercase
                self.authorLabel.text = post.author
            }
        }
    }
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

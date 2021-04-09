//
//  ViewController.swift
//  Ahoy
//
//  Created by Ben Garcia on 4/8/21.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource {
    
    private var loadedPosts = [Post]()

    @IBOutlet weak var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // TEMP: Load some example posts
        self.loadedPosts.append(Post(id: 10, author: "Peter", content: "Have you met Joe?"))
        self.loadedPosts.append(Post(id: 12, author: "Steve Jobs", content: "Who is Joe?"))
        self.loadedPosts.append(Post(id: 15, author: "Peter", content: "He's the new marketing intern, you should go introduce yourself during your lunch break."))
        self.loadedPosts.append(Post(id: 20, author: "Steve Jobs", content: "What a great idea! I think I will."))
        
        // Set up the message table view to query this instance for data
        self.messageTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell else { return UITableViewCell() }
        
        cell.post = self.loadedPosts[indexPath.row]
        return cell
    }
}


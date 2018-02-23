//
//  HomeFeedViewController.swift
//  instagram
//
//  Created by Mario Martinez on 2/21/18.
//  Copyright © 2018 Mario Martinez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeFeedViewController: UIViewController, UITableViewDataSource  {

    var posts: [Post]! = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
        
        let query = Post.query()!
        //let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground(block: { (posts : [PFObject]?, error: Error?) -> Void in
            
            if let posts = posts {
                // do something with the data fetched
                for post in posts {
                    print(post["caption"])
                }
                self.posts = posts as! [Post]
                self.tableView.reloadData()
            } else {
                // handle error
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        
        cell.captionLabel.text = posts[indexPath.row].caption
        
        //cell.photoImageView.image = posts[indexPath.row].media as? P
        //cell.photoImageView.loadInBackground()
        

                cell.photoImageView.file = posts[indexPath.row].media as? PFFile
                cell.photoImageView.loadInBackground()
 
        
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

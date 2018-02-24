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
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeFeedViewController.didPullToRefresh(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self

        fetchPosts()

    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchPosts()
    }
    
    func fetchPosts() {
        let query = Post.query()!
        query.includeKey("author")
        
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground(block: { (posts : [PFObject]?, error: Error?) -> Void in
            
            if let posts = posts {
                self.posts = posts as! [Post]
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
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
        cell.photoImageView.file = posts[indexPath.row].media
        cell.photoImageView.loadInBackground()
        
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let post = posts[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.post = post
            }
        }
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

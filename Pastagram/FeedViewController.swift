//
//  FeedViewController.swift
//  Instagram
//
//  Created by Ruchika Gupta on 10/23/20.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {

    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
       let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
      
        
        delegate.window?.rootViewController = loginViewController

        
        //switch back to login screen
       
    }
    
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    
    @IBOutlet weak var tableView: UITableView!
    
    //Array of posts like for movies
    var posts = [PFObject]()
    
    var selectedPost: PFObject!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        commentBar.inputTextView.placeholder = "Add a comment ....."
        commentBar.sendButton.title = "Post"
        
        
        commentBar.delegate = self
        
        tableView.keyboardDismissMode = .interactive
        
        //NS NOTIFCTAIONS
        let center = NotificationCenter.default
        //Keyboard will hide upon the notfication center
        center.addObserver(self, selector: #selector(keyboardWillbeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //Creeatee thee comment
        //Clear and dismiss thee input
        let comment = PFObject(className: "Comments")
        comment["text"] = "This is a random comment"
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!
        
        //Add comment to the array
        selectedPost.add(comment, forKey: "comments")
        
        selectedPost.saveInBackground { (success, error) in
            if (success){
                print("Comment saved")
            }
            else{
                print("Error")
            }
        }
        
        //Refreshes the page
        tableView.reloadData()
        
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        
        
        
        commentBar.inputTextView.resignFirstResponder()
        
    }
    @objc func keyboardWillbeHidden(note: Notification){
        //Clear text field when hidden
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    
    //Two original functions
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showsCommentBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Refresh so it shows the post you just created
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "post")
        //Pointer with actual object
        //for each comment get the author
        query.includeKeys(["author","comments","comments.author"])
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                //store the posts
                self.posts = posts!
                //reload the table view
                self.tableView.reloadData()
            }
            
        }
    }
    
    //Everytime click on post
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        
        //Comment is object
        let comments = (post["comments"] as? [PFObject]) ?? []
            //PFObject(className: "Comments")
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            
            commentBar.inputTextView.becomeFirstResponder()
            selectedPost = post
            
        }
        
        //comment["text"] = "This is a random comment"
        //comment["post"] = post
        //comment["author"] = PFUser.current()!
        
        //Add comment to the array
        //post.add(comment, forKey: "comments")
        
       // post.saveInBackground { (success, error) in
           // if (success){
            //    print("Comment saved")
            //}
            //else{
             //   print("Error")
            //}
       // }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Number of comments + post row
        let post = posts[section]
        //comment can be nil
        //?? if nil set equal to what ever on it
        let comments = (post["comment"] as? [PFObject]) ?? []
        
        //returns the number of comments associated with each post
        //2 for add comment cell
        return comments.count + 2
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //Many sections as posts
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        
        let comments = (post["comment"] as? [PFObject]) ?? []
        
        //be a post cell
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            
           
            
            let user = post["author"] as! PFUser
            
            cell.usernameLabel.text = user.username
            
            cell.captionLabel.text = post["caption"] as? String
            
            let imageFile = post["image"] as! PFFileObject
            
            let urlString = imageFile.url!
            
            let url = URL(string: urlString)!
            
            cell.photoView.af_setImage(withURL : url)
           
            return cell
            
        }
        else if indexPath.row <= comments.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            //If 0 then it's the post, 1- 1 = 0 first comment
            let comment = comments[indexPath.row - 1]
            
            //Cast from dictionary to string
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
           
            
            return cell
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


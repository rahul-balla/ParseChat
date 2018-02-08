//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Rahul Balla on 2/7/18.
//  Copyright © 2018 Rahul Balla. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatMessageText: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [PFObject] = []
    var user: [String] = []
    var userText: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        }
    }
    
    @IBAction func onSend(_ sender: Any) {
        
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = chatMessageText.text ?? ""
        chatMessage["user"] = PFUser.current()
        
        chatMessage.saveInBackground { (success: Bool, error: Error?) in
            
            if(success){
                print("the message was saved!")
                self.chatMessageText.text = ""
            }
            else{
                print("Saving of message failed")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(userText.count)
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
//        let messageCell = userText[indexPath.row]
        let message = messages[indexPath.row]
        cell.chatText.text = message["text"] as! String
        if let user = message["user"] as? PFUser {
            cell.userName.text = user.username
        }
        
        return cell
    }
    
    @objc func onTimer(){
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if(error == nil){
                print("there was no error\n")
                self.messages = messages!
                self.tableView.reloadData()
                
                
            }
            else{
                print("the error is",error?.localizedDescription)
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

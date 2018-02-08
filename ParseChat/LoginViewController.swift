//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Rahul Balla on 1/31/18.
//  Copyright © 2018 Rahul Balla. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupAction(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = usernameText.text
        newUser.password = passwordText.text
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if(success){
                self.createAlert(alertTitle: "Sign Up Successful", alertMessage: "You have successfully created an account", actionMessage: "OK", performSegue: true)
            }
            
            else{
                self.createAlert(alertTitle: "Sign Up Failed", alertMessage: (error?.localizedDescription)!, actionMessage: "OK", performSegue: false)
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if((usernameText.text?.isEmpty)! || (passwordText.text?.isEmpty)! ){
            createAlert(alertTitle: "Log In Failed", alertMessage: "Please type an appropriate username and password", actionMessage: "OK", performSegue: false)
        }
        else{
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { (user: PFUser?, error: Error?) in
                
                if user != nil {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                    
                else{
                    self.createAlert(alertTitle: "Log In Failed", alertMessage: "Please check username and password", actionMessage: "OK", performSegue: false)
                }
            }
        }
    }
    
    func createAlert(alertTitle: String, alertMessage: String, actionMessage: String, performSegue: Bool){
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let action: UIAlertAction!
        
        if(!performSegue){
            action = UIAlertAction(title: actionMessage, style: .default, handler: nil)
        }
        else{
            action = UIAlertAction(title: actionMessage, style: .default, handler: { (action) -> Void in
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            })
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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

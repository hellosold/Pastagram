//
//  LoginViewController.swift
//  Instagram
//
//  Created by Ruchika Gupta on 10/23/20.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func OnSignIn(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
       
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            //Loogged on
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else{
                print("error: (error?.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func OnSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        user.signUpInBackground {(success,error) in
            if success{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else{
                print("error: \(String(describing: error?.localizedDescription))")
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

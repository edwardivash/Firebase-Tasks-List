//
//  LoginViewController.swift
//  ToDoFIRE
//
//  Created by Эдуард on 12/21/19.
//  Copyright © 2019 Eduard Ivash. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let segueIdentifier = "tasksSegue"
    var ref:DatabaseReference!
    
    @IBOutlet weak var warnLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")

        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)

        warnLabel.alpha = 0
        Auth.auth().addStateDidChangeListener({[weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            }
        })
        
        redactTintColor()
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
    }
    
    @objc func kbDidShow(notification:Notification) {
        guard let userInfo = notification.userInfo else {return} // Получили инфу об пользователе
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue // Получаем размер клавиатуры
        
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }

    @objc func kbDidHide(){

    (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    func displayWarningLabel(withText text:String){
        warnLabel.text = text
        UIView.animate(withDuration: 6, delay: 0, options: .curveEaseInOut, animations: { [weak self ] in
            self?.warnLabel.alpha = 1
        }) {[weak self] complete in
            self?.warnLabel.alpha = 0
            
        }
    }
    
    @IBAction func loginTaped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextfield.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect!")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            }
            self?.displayWarningLabel(withText: "No such user")
        })
    }
    
    @IBAction func registerTaped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextfield.text, email != "", password != "" else {
        displayWarningLabel(withText: "Info is incorrect")
        return
    }
        Auth.auth().createUser(withEmail: email, password: password, completion:{[weak self](user, error) in
            
            guard error == nil, user != nil else {
                
                print(error!.localizedDescription)
                return
            }
            
            let userRef = self?.ref.child(((user?.user.uid)!))
            userRef?.setValue(["email":user?.user.email])
            
    })
    }
    
    func redactTintColor() {
        guard let emailTextField = emailTextField, let passwordTextField = passwordTextfield else {return}
        emailTextField.tintColor = .systemPink
        passwordTextField.tintColor = .systemPink
    }
}



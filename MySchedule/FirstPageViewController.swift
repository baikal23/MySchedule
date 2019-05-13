//
//  FirstPageViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/13/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class FirstPageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isHidden = true
        passwordTextField.isEnabled = false
        userTextField.delegate = self
        passwordTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goButtonPushed(_ sender: Any) {
        if userTextField.text == "ADMIN" {
            performSegue(withIdentifier: "adminSegue", sender: self)
        } else {
            performSegue(withIdentifier: "signUpSegue", sender: self)
        }
    }
    
    
    
    // MARK: - Navigation


}

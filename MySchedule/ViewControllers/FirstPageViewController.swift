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
    @IBOutlet weak var letsGoButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func unwindToFirstPage(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isHidden = true
        passwordTextField.isEnabled = false
        userTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        passwordTextField.isHidden = true
        passwordTextField.isEnabled = false
        userTextField.text = ""
    }
    func setupUI() {
        self.view.backgroundColor = ColorScheme.pageBackgroundColor
        self.letsGoButton.setTitleColor(ColorScheme.buttonTextColor, for: .normal)
        self.letsGoButton.backgroundColor = ColorScheme.buttonColor
        letsGoButton.layer.cornerRadius = cornerRadius
        letsGoButton.layer.borderWidth = borderWidth
        letsGoButton.layer.borderColor = UIColor.clear.cgColor
        letsGoButton.clipsToBounds = true
        
    }
    
    @IBAction func goButtonPushed(_ sender: Any) {
        if userTextField.text == "ADMIN" {
            passwordTextField.isHidden = false
            passwordTextField.isEnabled = true
            // performSegue(withIdentifier: "adminSegue", sender: self)
        } else {
            if (Participants.verifyParticipant(userTextField.text ?? "")) {
              performSegue(withIdentifier: "signUpSegue", sender: self)
            } else {
                let alert = UIAlertController(title: "Alert", message: "You are not a registered user", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            passwordTextField.isHidden = true
            passwordTextField.isEnabled = false
        }
        if ((!passwordTextField.isHidden) && ((passwordTextField.text == "ADMIN") || (passwordTextField.text == "admin"))) {
            performSegue(withIdentifier: "adminSegue", sender: self)
        }
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpSegue" {
            let destinationNv = segue.destination as! UINavigationController
            let destinationVC = destinationNv.viewControllers[0] as! SignUpCollectionViewController
            let participant = Participants.getParticipantWithName(userTextField.text!)
            destinationVC.participant = participant
        }
        
    }

}

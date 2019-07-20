//
//  FirstPageViewController.swift
//  MySchedule
//
//  Created by Susan Kohler on 5/13/19.
//  Copyright © 2019 AppsByGeorge. All rights reserved.
//

import UIKit

class FirstPageViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var weekPickerData:[String] = []
    var mondayDate:Date = Date()
    var currentWeek:Week!
    
    @IBOutlet weak var weekPickerView: UIPickerView!
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
        weekPickerView.delegate = self
        weekPickerView.dataSource = self
        weekPickerData = CalendarDays.getNextMondays()
        self.pickerView(self.weekPickerView, didSelectRow: 0, inComponent: 0)
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        passwordTextField.isHidden = true
        passwordTextField.isEnabled = false
        userTextField.text = ""
    }
    func setupUI() {
        self.navigationController?.navigationBar.tintColor = ColorScheme.backButtonColor
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
            destinationVC.currentWeek = currentWeek
        }
        
    }
    //MARK: PickerView Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return weekPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return weekPickerData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        mondayDate = CalendarDays.dateFromString(weekPickerData[row])
        print ("Date is \(mondayDate)")
        // try this here - it works
        let date = mondayDate
        currentWeek = Week.getWeekOf(date)
    }
    

}

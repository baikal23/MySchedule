//
//  PDFViewController.swift
//  MyLife
//
//  Created by Susan Kohler on 10/9/15.
//  Copyright © 2015 Susan Kohler. All rights reserved.
//

import UIKit
import MessageUI
import WebKit

class PDFViewController : UIViewController, WKUIDelegate, MFMailComposeViewControllerDelegate {
    
    var reportName:String
    var userName:String
    let kInset:CGFloat = 10
    var pdfContents:Data?
    var webView: WKWebView!
    
    init() {
        reportName = ""
        userName = ""
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("")
        reportName = ""
        userName = ""
        super.init(coder: aDecoder)
    }
    
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send Email", style: .plain, target: self, action: #selector(PDFViewController.emailPressed))
        let pdf = Filehelpers.fileInUserDocumentDirectory(reportName)
        print("report name is: \(reportName)")
        let pdfURL = URL(fileURLWithPath: pdf)
        
        if let contents = try? Data(contentsOf: URL(fileURLWithPath: pdf)) {
            pdfContents = contents
            //print("WE HAVE CONTENTS")
           // let webView = UIWebView(frame: CGRect(x: kInset,y: kInset,width: self.view.frame.size.width - 2 * kInset,height: self.view.frame.size.height - 2 * kInset))
            webView.load(pdfContents!, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: pdfURL)
            webView.backgroundColor = UIColor.lightGray
            //self.view.addSubview(webView)
        
        }
        
        self.setupUI()
    }
    
    func setupUI() {
        let leftImage = UIImage(named: "back.png")
        let leftButtonFrame = CGRect(x: 0, y: 0, width: leftImage!.size.width, height: leftImage!.size.height)
        let leftButton = UIButton(frame: leftButtonFrame)
        let leftItem = UIBarButtonItem(customView: leftButton)
        leftButton.setImage(leftImage, for: UIControl.State())
        leftButton.addTarget(self, action: #selector(PDFViewController.backButtonPressed), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightImage = UIImage(named:"emailBW.png")
        let rightButtonFrame = CGRect(x: 0, y: 0, width: rightImage!.size.width, height: rightImage!.size.height)
        let rightButton = UIButton(frame: rightButtonFrame)
        let rightItem = UIBarButtonItem(customView: rightButton)
        rightButton.setImage(rightImage, for: UIControl.State())
        rightButton.addTarget(self, action: #selector(PDFViewController.emailPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func emailPressed() {
        print("Send Email was pressed")
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @objc func backButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }

    
    // email methods - should be separate
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        //mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("MyLife report for \(userName)")
        mailComposerVC.setMessageBody("The report for \(userName) is in the attached PDF file", isHTML: false)
        mailComposerVC.addAttachmentData(pdfContents!, mimeType: "application/pdf", fileName: "Report for \(userName)")
        
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
      let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

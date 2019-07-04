//
//  ReportGenerator.swift
//  MyLife
//
//  Created by Susan Kohler on 10/9/15.
//  Copyright © 2015 Susan Kohler. All rights reserved.
//

import UIKit
import QuartzCore

class ReportGenerator: NSObject {
    
    var pageSize:CGSize?
    var font:UIFont?
    let kMargin:Double = 100.0
    
   /* override init() {
        pageSize = CGSizeMake(10.0,10.0)
        super.init()
    }*/
    
    func setupPDFDocumentNamed(name:String, width:CGFloat, height:CGFloat) {
        pageSize = CGSize(width: width, height: height)
        let pdfPath = Filehelpers.fileInUserDocumentDirectory(name)
        UIGraphicsBeginPDFContextToFile(pdfPath, CGRect.zero, nil)
    }
    
    func beginPDFPage() {
       // pageSize = CGSizeMake(100.0,1000.0)
        let rect = CGRect(x: 0, y: 0, width: pageSize!.width, height: pageSize!.height)
        UIGraphicsBeginPDFPageWithInfo(rect, nil)
    }
    
    func addText(text:String, frame:CGRect, fontSize:CGFloat) -> CGRect {
        font = UIFont.systemFont(ofSize: fontSize)
        let myText = text as NSString
        print("My text is \(myText)")
        // try this
        let width = Double(pageSize!.width) - kMargin
        let stringSize = sizeOfString(string: text, constrainedToWidth: width)
        // end
      // new stuff
        var textWidth = frame.size.width;
        
        if (textWidth < stringSize.width) {
            textWidth = stringSize.width;
        }
        if (textWidth > pageSize!.width) {
            textWidth = pageSize!.width - frame.origin.x;
        }
        // end
        //let renderingRect:CGRect = CGRectMake(frame.origin.x, frame.origin.y, stringSize.width, stringSize.height)
        let renderingRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: textWidth, height: stringSize.height)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let textColor = UIColor.black
        
        let textFontAttributes = [
            NSAttributedString.Key.font: font!,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        
        myText.draw(in: renderingRect, withAttributes: textFontAttributes)
        
        let finalFrame = renderingRect
        return finalFrame
    }
    
    func addLineWithFrame(frame:CGRect, color:UIColor) -> CGRect {
        let currentContext:CGContext = UIGraphicsGetCurrentContext()!
        currentContext.setStrokeColor(color.cgColor)
        currentContext.setLineWidth(frame.size.height) // width is height of frame
        let startPoint = frame.origin
        let endPoint = CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y)
        currentContext.beginPath();
        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        //CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
        //CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
        
        currentContext.closePath();
        //CGContextDrawPath(currentContext, CGPathDrawingMode.fillStroke)
        currentContext.drawPath(using: .fillStroke)
        return frame
    }
    
    func addImageAtPoint(image:UIImage, point:CGPoint) -> CGRect {
        let imageFrame = CGRect(x: point.x, y: point.y, width: image.size.width, height: image.size.height)
        image.draw(in: imageFrame)
        return imageFrame
    }
    
    func finishPDF() {
        UIGraphicsEndPDFContext()
    }
    
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
 
        return string.boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                   attributes: [NSAttributedString.Key.font: font!],
            context: nil).size
    }


}

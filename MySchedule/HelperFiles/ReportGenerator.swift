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

    class func setupPDFDocumentNamed(name:String) {
        let pdfPath = Filehelpers.fileInUserDocumentDirectory(name)
        UIGraphicsBeginPDFContextToFile(pdfPath, CGRect.zero, nil)
    }
    
    class func beginPDFPage() {
       // pageSize = CGSizeMake(100.0,1000.0)
        let rect = CGRect(x: 0, y: 0, width: pdfPageSize.width, height: pdfPageSize.height)
        UIGraphicsBeginPDFPageWithInfo(rect, nil)
    }
    
    class func addText(text:String, frame:CGRect, fontSize:CGFloat) -> CGRect {
       let font = UIFont.systemFont(ofSize: fontSize)
        let myText = text as NSString
        print("My text is \(myText)")
        // try this
        let width = Double(pdfPageSize.width) - pdfMargin
        let stringSize = sizeOfString(string: text, constrainedToWidth: width, ofFont:font)
        // end
      // new stuff
        var textWidth = frame.size.width;
        
        if (textWidth < stringSize.width) {
            textWidth = stringSize.width;
        }
        if (textWidth > pdfPageSize.width) {
            textWidth = pdfPageSize.width - frame.origin.x;
        }
        // end
        //let renderingRect:CGRect = CGRectMake(frame.origin.x, frame.origin.y, stringSize.width, stringSize.height)
        let renderingRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: textWidth, height: stringSize.height)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let textColor = UIColor.black
        
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        
        myText.draw(in: renderingRect, withAttributes: textFontAttributes)
        
        let finalFrame = renderingRect
        return finalFrame
    }
    
    class func addLineWithFrame(frame:CGRect, color:UIColor) -> CGRect {
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
    
    class func addImageAtPoint(image:UIImage, point:CGPoint) -> CGRect {
        let imageFrame = CGRect(x: point.x, y: point.y, width: image.size.width, height: image.size.height)
        image.draw(in: imageFrame)
        return imageFrame
    }
    
    class func finishPDF() {
        UIGraphicsEndPDFContext()
    }
    
    class func sizeOfString (string: String, constrainedToWidth width: Double, ofFont:UIFont) -> CGSize {
 
        return string.boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                   attributes: [NSAttributedString.Key.font: ofFont],
            context: nil).size
    }


}

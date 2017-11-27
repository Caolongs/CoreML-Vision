//
//  JJViewTool.swift
//  CoreMLVision
//
//  Created by cao longjian on 2017/11/16.
//  Copyright © 2017年 cao longjian. All rights reserved.
//

import UIKit
import Vision

class JJViewTool: NSObject {

    class func drawImage(image: UIImage, observation: VNFaceObservation, pointArray:[VNFaceLandmarkRegion2D]) -> UIImage {
        var sourceImage = image
        
        for landmarks2D: VNFaceLandmarkRegion2D in pointArray {
//            var points = [CGPoint]()
            let points = landmarks2D.pointsInImage(imageSize: sourceImage.size)
//            for i in 0..<landmarks2D.pointCount {
//                let point = landmarks2D.normalizedPoints[i]
//                let p = CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))
//                points.append(p)
//            }
            
//            let mappedPoints = points.map { CGPoint(x: observation.boundingBox.origin.x * sourceImage.size.width + $0.x * observation.boundingBox.size.width, y: observation.boundingBox.origin.y * sourceImage.size.height + $0.y * observation.boundingBox.size.height) }
            
            
            UIGraphicsBeginImageContextWithOptions(sourceImage.size, false, 1)
            let context = UIGraphicsGetCurrentContext()!
            UIColor.red.set()
            context.setLineWidth(2.0)
            
            //设置翻转
            context.translateBy(x: 0, y: sourceImage.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            
            //设置线类型
            context.setLineJoin(.round)
            context.setLineCap(.round)
            
            // 设置抗锯齿
            context.setShouldAntialias(true)
            context.setAllowsAntialiasing(true)
            
            
            context.setBlendMode(CGBlendMode.colorBurn)
            context.setStrokeColor(UIColor.red.cgColor)
            
            // 绘制
            let rect = CGRect(x: 0, y:0, width: sourceImage.size.width, height: sourceImage.size.height)
            context.draw(sourceImage.cgImage!, in: rect)
            context.addLines(between: points)
            context.drawPath(using: CGPathDrawingMode.stroke)
           
            sourceImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
        }
        return sourceImage
    }
    
    
    class func getRectViewWithFrame(frame: CGRect) -> UIView {
        let boxView = UIView.init(frame: frame)
        boxView.backgroundColor = UIColor.clear
        
        boxView.layer.borderColor = UIColor.orange.cgColor
        boxView.layer.borderWidth = 2
        return boxView
    }
    
}







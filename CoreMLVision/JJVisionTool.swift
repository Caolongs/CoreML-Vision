//
//  JJVisionTool.swift
//  CoreMLVision
//
//  Created by cao longjian on 2017/11/14.
//  Copyright © 2017年 cao longjian. All rights reserved.
//

import UIKit
import Vision

enum JJDetectionType {
    case Face     // 人脸识别
    case Landmark // 特征识别
    case TextRectangles  // 文字识别
    case FaceHat
    case FaceRectangles
}

typealias detectImageHandler = ((_ data: JJDetectData) -> Void)?


class JJVisionTool: NSObject {

    /// 识别图片
    class func detectImageWithType(type: JJDetectionType, image: UIImage, complete:detectImageHandler) {
    
        // 转换CIImage
        let cgImage = image.cgImage!
        
        // 创建处理requestHandler
        let detectRequestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        // 创建BaseRequest
        var detectRequest = VNImageBasedRequest.init()
        
        let completionHandler: VNRequestCompletionHandler = { (request: VNRequest, error: Error?) in
            
            self.handleImageWithType(type: type, image: image, observations: request.results!, complete: complete)
        }
        
        switch type {
        case .Face:
            detectRequest = VNDetectFaceRectanglesRequest.init(completionHandler: completionHandler)
        case .Landmark:
            detectRequest = VNDetectFaceLandmarksRequest.init(completionHandler: completionHandler)
        case .TextRectangles:
            detectRequest = VNDetectTextRectanglesRequest.init(completionHandler: completionHandler)
            detectRequest.setValue(true, forKey: "reportCharacterBoxes")// 设置识别具体文字
        default:
            break
            
        }
        try? detectRequestHandler.perform([detectRequest])
        
    }
    
    /// 处理识别数据
    class func handleImageWithType(type: JJDetectionType, image: UIImage, observations:[Any], complete:detectImageHandler) -> Void {
        switch type {
        case .Face:
            guard let tmpObversations = observations as? [VNFaceObservation] else {
                fatalError("no face")
            }
            faceRectangles(observations: tmpObversations, image: image, complete: complete)
            
        case .Landmark:
            guard let tmpObversations = observations as? [VNFaceObservation] else {
                fatalError("no face")
            }
            faceLandmarks(observations: tmpObversations, image: image, complete: complete)
            
        case .TextRectangles:
            guard let tmpObversations = observations as? [VNTextObservation] else {
                fatalError("no text")
            }
            textRectangles(observations: tmpObversations, image: image, complete: complete)
        default:
            break
            
        }
    }
    
    // 处理面部轮廓回调
    class func faceRectangles(observations: [VNFaceObservation], image: UIImage, complete: detectImageHandler) -> Void {
        var tempArray = [NSValue]()
        let detectFaceData = JJDetectData.init()
        for faceObversion in observations {
            let rect = self.convertRect(oldRect: faceObversion.boundingBox, imageSize: image.size)
            
            let ractValue = NSValue.init(cgRect: rect)
            tempArray.append(ractValue)
        }
        detectFaceData.faceAllRect = tempArray
        if let tmpComplete = complete {
            tmpComplete(detectFaceData)
        }
        
    }
    
    // 处理人脸特征回调
    class func faceLandmarks(observations: [VNFaceObservation], image: UIImage, complete: detectImageHandler) -> Void {
        let detectData = JJDetectData.init()
        for faceObversion in observations {
            // 创建特征存储对象
            let detectFaceData: JJDetectFaceData = JJDetectFaceData()
            
            // 获取细节特征
            let landmarks: VNFaceLandmarks2D = faceObversion.landmarks!
            
            self.getPropertyList(classObj: VNFaceLandmarks2D.self, key: { (keyName: String) in
                if keyName == "allPoints" {
                    return;
                }
                if let region2D = landmarks.value(forKey: keyName) {
                    //detectFaceData属性需初始化
                    //detectFaceData.setValue(region2D, forKey: keyName)
                    detectFaceData.allPoints.append(region2D as! VNFaceLandmarkRegion2D)
                }
                detectFaceData.observation = faceObversion
                detectData.facePoints.append(detectFaceData)
                
            });
        }
        
        if let tmpComplete = complete {
            tmpComplete(detectData)
        }
    }
    
    // 处理文本回调
    class func textRectangles(observations: [VNTextObservation], image: UIImage, complete: detectImageHandler) -> Void {
        var tempArray = [NSValue]()
        let detectTextData = JJDetectData.init()
        for textObversion in observations {
            for box: VNRectangleObservation in textObversion.characterBoxes! {
                let rect = self.convertRect(oldRect: box.boundingBox, imageSize: image.size)
                let ractValue = NSValue.init(cgRect: rect)
                tempArray.append(ractValue)
            }
        }
        detectTextData.textAllRect = tempArray
        if let tmpComplete = complete {
            tmpComplete(detectTextData)
        }
    }
}


// MARK: - Private
extension JJVisionTool {
    /// 转换Rect
    class func convertRect(oldRect: CGRect, imageSize: CGSize) -> CGRect {
        let w = oldRect.size.width * imageSize.width
        let h = oldRect.size.height * imageSize.height
        let x = oldRect.origin.x * imageSize.width
        let y = imageSize.height - (oldRect.origin.y * imageSize.height) - h
        return CGRect.init(x: x, y: y, width: w, height: h)
    }
    
    
    
    // 获取对象属性keys
    @discardableResult
    class func getPropertyList(classObj: Swift.AnyClass, key:((_ key: String) -> Void)?) -> [String] {
        
        var propertyArr = [String]()
        
        // 接受属性个数
        var count: UInt32 = 0
        // 1. 获取"类"的属性列表,返回属性列表的数组,可选项
        let list = class_copyPropertyList(classObj,&count)
        // 2. 遍历
        for i in 0..<Int(count) {
            // 3. 根据下标获取属性
            let pty = list?[i] // objc_property_t?
            // 4. 获取'属性'的名称 C语言字符串
            // Int8 -> Byte -> Char => C 语言的字符串
            let  cName = property_getName(pty!)
            // 5. 转换成String 的字符串
            guard let name = String(utf8String: cName) else {
                continue
            }
            if let tmpKey = key {
                tmpKey(name)
            }
            propertyArr.append(name)
        }
        // 释放C 语言的对象
        free(list)
        return propertyArr
    }
    
    
}

//
//  JJDetectData.swift
//  CoreMLVision
//
//  Created by cao longjian on 2017/11/16.
//  Copyright © 2017年 cao longjian. All rights reserved.
//

import UIKit
import Vision

class JJDetectData: NSObject {

    override init() {
        super.init()
    }
    
    // 所有识别的人脸轮廓坐标
    var faceAllRect: [NSValue]?
    
    // 所有识别的特征points
    var facePoints = [JJDetectFaceData]()
    
    // 所有识别的文本坐标
    var textAllRect: [NSValue]?
    
}

class JJDetectFaceData: NSObject {
    
    var observation: VNFaceObservation?
    
    var allPoints = [VNFaceLandmarkRegion2D]()
    

    // 脸部轮廊
    var faceContour: VNFaceLandmarkRegion2D?
    
    // 左眼，右眼
    var leftEye: VNFaceLandmarkRegion2D?
    var rightEye: VNFaceLandmarkRegion2D?

    // 鼻子，鼻嵴
    var nose: VNFaceLandmarkRegion2D?
    var noseCrest: VNFaceLandmarkRegion2D?
    var medianLine: VNFaceLandmarkRegion2D?

    // 外唇，内唇
    var outerLips: VNFaceLandmarkRegion2D?
    var innerLips: VNFaceLandmarkRegion2D?
    
    // 左眉毛，右眉毛
    var leftEyebrow: VNFaceLandmarkRegion2D?
    var rightEyebrow: VNFaceLandmarkRegion2D?

    // 左瞳,右瞳
    var leftPupil: VNFaceLandmarkRegion2D?
    var rightPupil: VNFaceLandmarkRegion2D?

}

//
//  FaceViewController.swift
//  CoreMLVision
//
//  Created by cao longjian on 2017/11/11.
//  Copyright © 2017年 cao longjian. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    lazy private var picker: UIImagePickerController = self.makePicker()
    lazy private var showImageView: UIImageView = self.makeShowImageView()
    var detectionType: JJDetectionType = .Face
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.showImageView)
        self.showImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapImg(_:)))
        self.showImageView.addGestureRecognizer(tap)
        
    }

    @objc func tapImg(_ sender: UITapGestureRecognizer) -> Void {
        UIAlertController.jj_actionSheetWithTitle(actionArr: ["相机","相册"], cancle: "取消") { (index) in
            self.imagePicker(type: index)
        }
    }
    
    func imagePicker(type:Int) -> Void {
        if type == 0 {
            self.picker.sourceType = .camera
            self.picker.cameraCaptureMode = .photo
        } else {
            self.picker.sourceType = .photoLibrary
        }
        self.present(self.picker, animated: true, completion: nil)
    }
    
}


// MARK: - UIImagePickerControllerDelegate
extension FaceViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        self.picker.dismiss(animated: true, completion: nil)
        detectFace(image: chosenImage)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate
extension FaceViewController: UINavigationControllerDelegate {
    
}

// MARK: - Private
extension FaceViewController {
    func detectFace(image: UIImage) -> Void {
        guard let scaledImage = image.scaleImage(newSize: CGSize.init(width: self.view.bounds.size.width, height: image.size.height * self.view.bounds.size.width / image.size.width)) else {
            return
        }

        self.showImageView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: self.view.bounds.size.width, height: image.size.height * self.view.bounds.size.width / image.size.width)
        self.showImageView.image = scaledImage;
        
        JJVisionTool.detectImageWithType(type: self.detectionType, image: scaledImage) { (detectData: JJDetectData) in
            switch self.detectionType {
            case .Face:
                if let faceAll = detectData.faceAllRect {
                    for rectValue in faceAll {
                        self.showImageView.addSubview(JJViewTool.getRectViewWithFrame(frame: rectValue.cgRectValue))
                        
                    }
                }
                
            case .Landmark:
                for faceData: JJDetectFaceData in detectData.facePoints {
                    self.showImageView.image = JJViewTool.drawImage(image: self.showImageView.image!, observation: faceData.observation!, pointArray: faceData.allPoints)
                }

            case .TextRectangles:
                if let textAll = detectData.textAllRect {
                    for rectValue in textAll {
                        self.showImageView.addSubview(JJViewTool.getRectViewWithFrame(frame: rectValue.cgRectValue))
                    }
                }
                
            default:
                break
                
            }

        }
        
        
    }
}

// MARK: - Getter
private extension FaceViewController {
    
    func makePicker() -> UIImagePickerController {
        let picker = UIImagePickerController.init()
        picker.delegate = self
        picker.allowsEditing = false
        return picker
    }
    func makeShowImageView() -> UIImageView {
        let imgView = UIImageView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: self.view.bounds.size.width, height: self.view.bounds.size.width))
        imgView.contentMode = .scaleAspectFill
        imgView.backgroundColor = UIColor.orange
        return imgView
    }
}

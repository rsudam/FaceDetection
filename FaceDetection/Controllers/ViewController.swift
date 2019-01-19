//
//  ViewController.swift
//  FaceDetection
//
//  Created by Raghu Sairam on 19/01/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "image1") else { return }
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = .scaleAspectFit
        
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        imageView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        
        view.addSubview(imageView)
        
        let request = VNDetectFaceRectanglesRequest.init { (req, err) in
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
            req.results?.forEach({ (res) in
               
                DispatchQueue.main.async {
                    guard let faceObservation = res as? VNFaceObservation  else { return }
                    
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    let height = scaledHeight * faceObservation.boundingBox.height
                    let y = scaledHeight * (1 - faceObservation.boundingBox.origin.y) - (height)
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    
                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    self.view.addSubview(redView)
                }
                
            })
        }
        
        guard let cgImage = image.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler.init(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch let err {
                print(err)
            }
        }
        
        
        
        
        
    }

}


//
//  ImageCell.swift
//  FaceDetection
//
//  Created by Raghu Sairam on 19/01/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    var imageName: String? {
        didSet{
            if let imageName = imageName {
                guard let image = UIImage(named: imageName) else { return }
                imageView.image = image
                scaledHeight = frame.width / image.size.width * image.size.height
            }
        }
    }

    var scaledHeight: CGFloat = 100 {
        didSet {
            imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: scaledHeight)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: scaledHeight)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

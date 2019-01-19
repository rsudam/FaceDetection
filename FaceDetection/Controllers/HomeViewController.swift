//
//  HomeViewController.swift
//  FaceDetection
//
//  Created by Raghu Sairam on 19/01/19.
//  Copyright © 2019 Raghu Sairam. All rights reserved.
//

import UIKit
import Vision

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let cellId = "cellId"
    fileprivate let images:[String] = ["image1","image2","image3","image4","image5","image6","image7"]
    fileprivate var collectionViewFlowLayout = UICollectionViewFlowLayout()
    fileprivate var redViews = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.imageName = images[indexPath.row]
        return cell
    }

    fileprivate func setupLayout() {
       collectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 10
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        removeRedViews()
    }
    
    fileprivate func removeRedViews() {
        redViews.forEach { (view) in
            view.removeFromSuperview()
        }
        redViews.removeAll()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        removeRedViews()
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        
        let request = VNDetectFaceRectanglesRequest.init { (req, err) in
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }

            req.results?.forEach({ (res) in

                DispatchQueue.main.async {
                    guard let faceObservation = res as? VNFaceObservation  else { return }

                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    let height = cell.scaledHeight * faceObservation.boundingBox.height
                    let y = cell.scaledHeight * (1 - faceObservation.boundingBox.origin.y) - (height)
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x

                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    self.redViews.append(redView)
                    self.redViews.forEach({ (view) in
                        self.view.addSubview(view)
                    })
                }

            })
        }

        guard let cgImage = cell.imageView.image!.cgImage else { return }

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

//
//  CircularCropperViewController.swift
//  Movo
//
//  Created by Ahmad on 06/02/2021.
//

import UIKit

protocol CircularCropperViewControllerDelegate:class {
    func getCroppedSelfie(image:UIImage, originalImage:UIImage)
}


class CircularCropperViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var imageToFilter: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var singleMainViewForImage: UIView!
    @IBOutlet weak var singleMainViewBlurImage: UIImageView!
    @IBOutlet weak var singleImageScrollView: UIScrollView!
    @IBOutlet weak var singleMainImageToFilter: UIImageView!

    weak var delegate:CircularCropperViewControllerDelegate?
    var originalImage:UIImage!
    private var isChecked = true
    
    //MARK:- View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setup()
    }
    
    private func setup() {
        singleMainViewForImage.isHidden = false
        let img = originalImage
        imageToFilter.image = img
        singleMainImageToFilter.image = img
        singleMainViewBlurImage.image = img?.blurImage()
               
        addRoundCornersAndBorders()
    }
    
    //MARK:- IBActions
    @IBAction func cancelButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonWasPressed(_ sender: Any) {
        dismiss()
    }
    
    //MARK:- Helper Methods
    private func dismiss () {
        dismiss(animated: true) {
            self.removeRoundCornersAndBorders()
           
            let viewToTakeSnapshot = self.singleMainViewForImage
            let screenshot = (viewToTakeSnapshot?.snapshot(withBlur: false))!
            self.delegate?.getCroppedSelfie(image: screenshot, originalImage: self.originalImage)
        }
    }
    
    private func addRoundCornersAndBorders() {   
//        singleMainImageToFilter.simpleRound()
        singleImageScrollView.simpleRound()
        singleMainViewBlurImage.simpleRound()
        singleMainViewForImage.simpleRound()
        singleMainViewForImage.addBorder(withBorderColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), borderWidth: 1.0)
        singleImageScrollView.contentSize = CGSize(width: singleMainViewForImage.frame.width, height: singleMainViewForImage.frame.height)
    }
    
    private func removeRoundCornersAndBorders() {
        singleMainImageToFilter.roundedUIView(withRadius: 0.0)
        singleImageScrollView.roundedUIView(withRadius: 0.0)
        singleMainViewBlurImage.roundedUIView(withRadius: 0.0)
        singleMainViewForImage.roundedUIView(withRadius: 0.0)
        singleMainViewForImage.addBorder(withBorderColor: UIColor.clear, borderWidth: 0.0)
    }
    
    //MARK:- UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleMainImageToFilter
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
        
        if scrollView.zoomScale > 1 {
            var testImage: UIImage?
            var testImageView : UIImageView?
            testImage = singleMainImageToFilter.image
            testImageView = singleMainImageToFilter
            
            guard let img = testImage else { return }
            guard let imgView = testImageView else { return }
            
            let ratioW = imgView.frame.width / img.size.width
            let ratioH = imgView.frame.height / img.size.height
            let ratio = ratioW < ratioH ? ratioW:ratioH
            let newWidth = img.size.width*ratio
            let newHeight = img.size.height*ratio
            let left = 0.5 * (newWidth * scrollView.zoomScale > imgView.frame.width ? (newWidth - imgView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
            let top = 0.5 * (newHeight * scrollView.zoomScale > imgView.frame.height ? (newHeight - imgView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))
            scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
}

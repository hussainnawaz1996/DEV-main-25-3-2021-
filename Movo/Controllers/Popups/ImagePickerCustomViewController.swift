//
//  ImagePickerCustomViewController.swift
//  Hooley
//
//  Created by Ahmad on 28/09/2020.
//  Copyright © 2020 MessageMuse. All rights reserved.
//

import UIKit
import PhotosUI

class PhotoCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "photoCell"
    
    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configureCell(asset:PHAsset, size:CGSize) {
        if asset.mediaType == .image {
            timeLabel.isHidden = true
        } else if asset.mediaType == .video {
            let duration = asset.duration
            let string = duration.stringFromTimeInterval()
            timeLabel.isHidden = false
            timeLabel.text = string
        }
        imageView.fetchImageAsset(asset, size: size, completionHandler: nil)
    }
}

protocol ImagePickerCustomViewControllerDelegate: class {
    func getSelectedMedia(assets: [PHAsset])
}

class ImagePickerCustomViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var manageLbl: UILabel!
    
    var mediaType : PHAssetMediaType = .image
    var delegate: ImagePickerCustomViewControllerDelegate?
    let sectionLocalizedTitles = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]
    private var assetFetchResult = PHFetchResult<PHAsset>()
    private var allPhotos = [PHAsset]()
    private var selectedIndex = -1
    fileprivate let kColumnCnt: Int = 3
    fileprivate var targetSize = CGSize.zero
    fileprivate let kCellSpacing: CGFloat = 4

    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        initView()
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        assetFetchResult = PHAsset.fetchAssets(with: mediaType, options: allPhotosOptions)
        getAssetsArray()
        PHPhotoLibrary.shared().register(self)
    }
        
    private func getAssetsArray() {
        allPhotos.removeAll()
        assetFetchResult.enumerateObjects({(object: AnyObject!,
                                            count: Int,
                                            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                self.allPhotos.append(asset)
            }
        })
        collectionView.reloadData()
    }
    
    func initView() {
        let imgWidth = (collectionView.frame.width - (kCellSpacing * (CGFloat(kColumnCnt) - 1))) / CGFloat(kColumnCnt)
        targetSize = CGSize(width: imgWidth, height: imgWidth)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = targetSize
        layout.minimumInteritemSpacing = kCellSpacing
        layout.minimumLineSpacing = kCellSpacing
        collectionView.collectionViewLayout = layout
        
    }
    
    // MARK: Properties
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

extension ImagePickerCustomViewController {
    
    @IBAction func manageButtonWasPressed(_ sender: UIButton) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonWasPressed(_ sender:  UIButton) {
        if selectedIndex == -1 {
            self.alertMessage(title: K.ALERT, alertMessage: "Please select atleast one item", action: nil)
        } else {
            navigationController?.popViewController(animated: true)
            dismiss(animated: true) {
                let selectedPhotos = [self.allPhotos[self.selectedIndex]]
                self.delegate?.getSelectedMedia(assets: selectedPhotos)
            }
        }
    }
        
}

extension ImagePickerCustomViewController :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier,
                for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("Unable to dequeue PhotoCollectionViewCell")
        }
        let asset = allPhotos[indexPath.item]
        
        cell.selectedIcon.isHidden = !(indexPath.row == selectedIndex)
        cell.configureCell(asset: asset, size: targetSize)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth / 3) - 3
        return CGSize(width: width, height: 128)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedIndex != -1 {
            let selectedIndexPaths = IndexPath(item: selectedIndex, section: 0)
            if let cell = collectionView.cellForItem(at: selectedIndexPaths) as? PhotoCollectionViewCell {
                cell.selectedIcon.isHidden = true
            }
        }
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        cell.selectedIcon.isHidden = false
        
        selectedIndex = indexPath.row
    }
}

// MARK: PHPhotoLibraryChangeObserver
extension ImagePickerCustomViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            // Check each of the three top-level fetches for changes.
            
            if let changeDetails = changeInstance.changeDetails(for: self.assetFetchResult) {
                // Update the cached fetch result.
                self.assetFetchResult = changeDetails.fetchResultAfterChanges
                self.getAssetsArray()
            }
            
            self.collectionView.reloadData()
        }
    }
}

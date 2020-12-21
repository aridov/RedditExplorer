//
//  ImageController.swift
//  Reddit Explorer
//
//  Created by Vladimir Aridov on 21.12.2020.
//

import UIKit

class ImageController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    fileprivate var redditEntry: RedditEntry!
    fileprivate var isSaved = false
    
    convenience init(with entry: RedditEntry) {
        self.init()
        redditEntry = entry
    }
    
    private init () {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        initGestures()
    }
    
    fileprivate func initViews() {
        imageView.downloadImage(from: redditEntry.thumbnail)
    }
    
    fileprivate func initGestures() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(saveImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(longPressGesture)
    }

    @objc fileprivate func saveImage() {
        if (isSaved) { return }
        guard let image = imageView.image else { return }
        DispatchQueue.global(qos: .userInitiated).sync {
            isSaved = true
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc fileprivate func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            isSaved = false
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

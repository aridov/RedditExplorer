//
//  ImageViewExtension.swift
//  Reddit Explorer
//
//  Created by Vladimir Aridov on 21.12.2020.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage(from string: String) {
        let imageURL = URL(string: string)
        guard let url = imageURL else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let contentsOfUrl = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let imageData = contentsOfUrl, let image = UIImage(data: imageData) {
                    self.image = image
                }
            }
        }
    }
}

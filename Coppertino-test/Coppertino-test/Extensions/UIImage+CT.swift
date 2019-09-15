//
//  UIImage+CT.swift
//  Coppertino-test
//
//  Created by Dima Dobrovolskyy on 9/15/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImage(from url: String, and save: ((UIImage) -> Void)?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let activityIndicator = UIActivityIndicatorView()
            
            activityIndicator.style = .gray
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            
            self.addSubview(activityIndicator)
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            let horizontalConstraint = activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            let verticalConstraint = activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            
            NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
            
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                
                TrackService.shared.fetchImage(from: url) { respose in
                    switch respose {
                    case .success(let data):
                        if let image = UIImage(data: data) {
                            save?(image)
                            // Added to simulate downloading.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                activityIndicator.stopAnimating()
                                self.image = image
                            }
                        }
                        
                    case .failure(let err):
                        print(err)
                    }
                }
            }
        }
    }
    
}

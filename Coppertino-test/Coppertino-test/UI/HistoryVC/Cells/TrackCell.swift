//
//  TrackCell.swift
//  Coppertino-test
//
//  Created by Dima Dobrovolskyy on 9/15/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import UIKit

/// Table cell for displaying track in History VC.
final class TrackCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var trackImageView: UIImageView!
    
    // MARK: - Configuration
    
    /// Initial configuration
    func configure(with track: CDTrack) {
        if let imageData = track.image, let image = UIImage(data: imageData) {
            trackImageView.image = image
        }
        trackNameLabel.text = track.name
    }

}

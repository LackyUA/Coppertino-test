//
//  SearchVC.swift
//  Coppertino-test
//
//  Created by Dima Dobrovolskyy on 9/14/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import UIKit
import CoreData

final class SearchVC: UIViewController {
    
    // MARK: - Constants
    
    private let separators = ["-", ":", "|", "\\", "/", "~"]
    private let coreDataService = CoreDataService(modelName: "CDTrack")
    
    // MARK: - Properties
    
    private var track: Track?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var searchTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction private func historyButtonTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: HistoryVC.self)) as! HistoryVC
        
        print("hesd")
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func searchButtonTapped(_ sender: Any) {
        guard let url = createUrl() else { return }
        
        TrackService.shared.fetchTrack(from: url) { (response: Result<Track, Error>) in
            switch response {
            case .success(let track):
                self.track = track
                DispatchQueue.main.async {
                    self.track?.name = self.searchTextField.text ?? ""
                }
                self.showImage(from: track)
                
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(with: "No result.", message: "Please check if name of artwork is correct.")
                }
            }
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGestureRecognizer()
    }
    
    // MARK: - Configuration
    
    private func configureGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Helpers
    
    /// Method for displaying networking error.
    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Method for loading, displaying and saving to Core Data image.
    private func showImage(from track: Track) {
        trackImageView.loadImage(from: track.imageUrl, and: saveTrackToCoreData)
    }
    
    /// Method for creating search url and error handling.
    private func createUrl() -> String? {
        guard let text = searchTextField.text, !text.isEmpty else {
            showAlert(with: "Empty search field.", message: "Please enter artwork name.")
            return nil
        }
        
        guard let separator = separator(in: text) else {
            showAlert(with: "Wrong format.", message: "You have to separate artist and album.")
            return nil
        }
        
        let textParts = text.split(separator: Character(separator)).map({ $0.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20") })
        
        if textParts.count > 1 {
            let url = (TrackService.shared.baseUrl + "artist:\"\(textParts[0])\" track:\"\(textParts[1])\"")
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            return url
        }
        
        return nil
    }
    
    /// Method for searching separator in search field
    private func separator(in text: String) -> String? {
        return separators.filter({ text.contains($0) }).first
    }
    
    /// Method for saving track to core data after image loading.
    private func saveTrackToCoreData(with image: UIImage) {
        if let track = track {
            coreDataService.addNewTrack(track: track, image: image)
        }
    }

}

// MARK: - History delegation

extension SearchVC: HistoryDelegate {
    
    func show(track: CDTrack) {
        searchTextField.text = track.name
        if let imageData = track.image, let image = UIImage(data: imageData) {
            trackImageView.image = image
        }
    }
    
}

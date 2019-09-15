//
//  HistoryVC.swift
//  Coppertino-test
//
//  Created by Dima Dobrovolskyy on 9/15/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import UIKit

/// Protocol for display choosed track.
protocol HistoryDelegate: class {
    func show(track: CDTrack)
}

final class HistoryVC: UITableViewController {
    
    // MARK: - Weak properties
    
    weak var delegate: HistoryDelegate?
    
    // MARK: - Constants
    
    private let coreDataService = CoreDataService(modelName: "CDTrack")
    
    // MARK: - Properties
    
    private var tracks = [CDTrack]()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        reload()
    }
    
    /// Method for reloading data in table view.
    private func reload() {
        tracks = coreDataService.getTracksFromCoreData().sorted(by: { $0.addingDate > $1.addingDate })
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TrackCell.self), for: indexPath) as! TrackCell
        
        cell.configure(with: tracks[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.show(track: tracks[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

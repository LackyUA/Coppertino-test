//
//  CoreDataService.swift
//  Coppertino-test
//
//  Created by Dima Dobrovolskyy on 9/15/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import UIKit
import CoreData

/// Service for working with Core Data.
final class CoreDataService {
    
    private let modelName: String!
    
    init(modelName: String) {
        self.modelName = modelName
    }

    private let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let context = appDelegate.persistentContainer.viewContext
        
        return context
    }()
    
    func managedObject() -> NSManagedObject {
        if let entity = NSEntityDescription.entity(forEntityName: modelName, in: context) {
            let newUser = NSManagedObject(entity: entity, insertInto: context)
            return newUser
        }
        
        return NSManagedObject()
    }
    
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        
        return request
    }
    
    /// Method for saving track to Core Data.
    func addNewTrack(track: Track, image: UIImage) {
        let newTrack = managedObject()
        
        newTrack.setValue(track.id, forKey: "id")
        newTrack.setValue(track.addingDate, forKey: "addingDate")
        newTrack.setValue(track.name, forKey: "name")
        
        if let imageData = image.jpegData(compressionQuality: 0.7)! as NSData? {
            newTrack.setValue(imageData, forKey: "image")
        } else {
            print("Cannot upload image to CD")
        }
        
        saveEntity()
    }
    
    /// Method for saving context
    func saveEntity() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    /// Method for fetching tracks from Core Data.
    func getTracksFromCoreData() -> [CDTrack] {
        do {
            let tracksResults = try context.fetch(fetchRequest())
            
            var tracks = [CDTrack]()
            for track in tracksResults as! [CDTrack] {
                tracks.append(track)
            }
            
            return tracks
        } catch let error as NSError {
            print("Could not fetch info. \(error), \(error.userInfo)")
            
            return []
        }
    }
    
}

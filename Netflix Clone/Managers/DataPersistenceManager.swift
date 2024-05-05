//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Nisa Aydin on 25.03.2024.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    enum DatabaseError: Error{
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Title,completion: @escaping(Result<Void,Error>) -> Void ){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let item = TitleItems(context: context)
        
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        
        do{
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
            
        }
        
    }
    func fetchingTitlesFromDataBase(completion: @escaping(Result<[TitleItems],Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let request :NSFetchRequest<TitleItems>
        
        request = TitleItems.fetchRequest()
        
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch{
            completion(.failure(DatabaseError.failedToFetchData))
        }
        
    }
    func deleteTitleWith(model:TitleItems,completion: @escaping (Result <Void,Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedToDeleteData))
            
        }
    }
    
}

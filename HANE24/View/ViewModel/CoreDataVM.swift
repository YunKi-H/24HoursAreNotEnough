//
//  CoreDataVM.swift
//  HANE24
//
//  Created by Yunki on 2023/02/23.
//

import Foundation
import SwiftUI
import CoreData


class MonthlyLogController {
    static let shared: MonthlyLogController = MonthlyLogController()

    let container: NSPersistentContainer
    var totalLogs = [MonthlyLog]()
    
    init() {
        container = NSPersistentContainer(name: "HANE24")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }

    func fetchLogs() {
        let request = NSFetchRequest<MonthlyLog>(entityName: "MonthlyLog")
        do {
            totalLogs = try container.viewContext.fetch(request)
        } catch {
            print("Unresolved error \(error.localizedDescription)")
        }
    }
    
    /// Add Monthly InOutLogs to CoreData
    /// - Parameters:
    ///   - date: format: "yyyy.MM"
    ///   - inOutLogs: just a Month
    func addLogs(date: String, inOutLogs: [InOutLog], needUpdate: Bool = true) {
        let monthlyLog = MonthlyLog(context: container.viewContext)
        let data = InOutLogs(data: inOutLogs)
        
        monthlyLog.needUpdate = needUpdate
        monthlyLog.date = date
        monthlyLog.inOutLogs = data
        saveData()
    }
    
    
    /// Update MonthlyLog's Data in CoreData
    /// - Parameters:
    ///   - entity: MonthlyLog Object
    ///   - needUpdate: need update after this API call?
    ///   - inOutLogs: Data from API
    func updateLogs(entity: MonthlyLog, inOutLogs: [InOutLog], needUpdate: Bool = true) {
        let data = InOutLogs(data: inOutLogs)
        
        entity.needUpdate = needUpdate
        entity.inOutLogs = data
        saveData()
    }
    
    func resetLogs() {
        let storeContainer = container.persistentStoreCoordinator
        
        for store in storeContainer.persistentStores {
            do {
                try storeContainer.destroyPersistentStore(at: store.url!, ofType: store.type, options: nil)
            } catch {
                print(error)
            }
        }
    
    }
    
    func deleteLogs(indexSet: IndexSet) {
        guard let index = indexSet.first else {return}
        let entity = totalLogs[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func saveData() {
        do {
           try container.viewContext.save()
           fetchLogs()
       } catch {
           print("Unresolved error \(error.localizedDescription)")
       }
    }
}

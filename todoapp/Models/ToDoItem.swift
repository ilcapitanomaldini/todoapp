//
//  ToDoItem.swift
//  todoapp
//
//  Created by VM on 10/04/21.
//  Copyright © 2021 VM. All rights reserved.
//

import CoreData

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

@objc(ToDoItem)
class ToDoItem: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case descriptionText = "description"
        case scheduledDate
        case status
    }
    
    enum Status: String {
        case completed = "COMPLETED"
        case pending = "PENDING"
        
        func toggle() -> Status {
            switch self {
            case .completed:
                return .pending
            case .pending:
                return .completed
            }
        }
    }
    
    @NSManaged var descriptionText: String?
    @NSManaged var id: Int64
    @NSManaged var scheduledDate: Date?
    @NSManaged var status: String?
    
    var statusVar: Status? {
        get {
            return Status(rawValue: status ?? "")
        }
        set {
            self.descriptionText = newValue?.rawValue
        }
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.descriptionText = try container.decode(String.self, forKey: .descriptionText)
        if let date = try? container.decode(Date.self, forKey: .scheduledDate) as Date {
            self.scheduledDate = date
        } else if let dateString = try? container.decode(String.self, forKey: .scheduledDate) as String {
            self.scheduledDate = Date.date(for: dateString)
        }
        self.status = try container.decode(String.self, forKey: .status)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(descriptionText, forKey: .descriptionText)
        try container.encode(scheduledDate, forKey: .scheduledDate)
        try container.encode(status, forKey: .status)
    }
}

extension ToDoItem {
    convenience init(id: Int, description: String, scheduledDate: Date, status: String) {
        
        self.init(entity: NSEntityDescription.entity(forEntityName: "ToDoItem", in: CoreDataManager.shared.viewContext)!, insertInto: CoreDataManager.shared.viewContext)
        
        self.id = Int64(id)
        
        self.descriptionText = description
        self.scheduledDate = scheduledDate
        self.status = status
    }
    
    //MARK: - Class functions
    
    class func fetchFromCoreData(withStatus status: Status? = nil) -> [ToDoItem] {
        var fetched: [ToDoItem] = []
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
        if let status = status {
            fetchRequest.predicate = NSPredicate(format: "status == %@", status.rawValue)
        }
        do {
            fetched = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetched
    }
    
    class func deleteAllFromCoreData(){
        let managedContext = CoreDataManager.shared.viewContext
        let fetchRequest = NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
        if let result = try? managedContext.fetch(fetchRequest) {
            for item in result {
                managedContext.delete(item)
            }
        }
    }
    
    
}

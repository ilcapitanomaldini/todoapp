//
//  MainViewModel.swift
//  todoapp
//
//  Created by VM on 11/04/21.
//  Copyright © 2021 VM. All rights reserved.
//

import Foundation

protocol MainVMDelegate: class {
    func dataUpdated()
}

class MainViewModel {
    var toDoItems: [ToDoItem] = []
    weak var delegate: MainVMDelegate?
    init(delegate: MainVMDelegate) {
        toDoItems = ToDoItem.fetchFromCoreData()
        self.delegate = delegate
    }
    
    func refreshData() {
        //TODO: Network manager can be a dependency that follows a protocol and therefore must be injected in?
        NetworkHelper.shared.get("RedactedURL", completion: { [weak self] (data, response, error) in
            guard error == nil else {
                //TODO: For all error types, alert the user!
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            DispatchQueue.main.async {
                ToDoItem.deleteAllFromCoreData()
                do {
                    //TODO: Decoding should be outside main thread. Kept here for now for CoreData.
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.userInfo[CodingUserInfoKey.managedObjectContext] = CoreDataManager.shared.viewContext
                    let toDoItems = try jsonDecoder.decode([ToDoItem].self, from: responseData)
                    self?.toDoItems = toDoItems
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
                self?.delegate?.dataUpdated()
                CoreDataManager.shared.saveContext()
            }
        })
    }
    
    func getTodaysItems() -> [ToDoItem] {
        return toDoItems.filter({$0.scheduledDate?.compareToday() ?? false})
    }
    
    func getLaterItems() -> [ToDoItem] {
        return toDoItems.filter({$0.scheduledDate?.compareLater() ?? false})
    }
}

//
//  TodayViewController.swift
//  todoapp
//
//  Created by VM on 11/04/21.
//  Copyright © 2021 VM. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    
    static var reuseIdentifier: String = "TodayViewController"
    
    @IBOutlet weak var statusView: StatusView!
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewModel: ToDoTableViewModel?
    var toDoItems: [ToDoItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewModel = ToDoTableViewModel(toDoItems: toDoItems, tableView: tableView, delegate: self)
        updateStatus()
    }
    
    func refreshViews(with items: [ToDoItem]?) {
        guard let items = items else {
            return
        }
        toDoItems = items
        tableViewModel?.update(toDoItems: items)
        updateStatus()
        tableView.reloadData()
    }
    
    func updateStatus() {
        let pendingItems = toDoItems.filter({$0.status == ToDoItem.Status.pending.rawValue})
        if pendingItems.count == 0 {
            //FIXME: Add the strings in a more general place
            statusView.setup(image: #imageLiteral(resourceName: "Image-6"), title: "Ain't got nothing To-Do™?", subMessage: "Refresh to sync-up!")
        } else {
            let timeString = pendingItems.sorted(by: {($0.scheduledDate ?? Date())<($1.scheduledDate ?? Date())}).first?.scheduledDate?.timeString() ?? "today"
            statusView.setup(image: #imageLiteral(resourceName: "Image-7"), title: "Rise and shine!", subMessage: "There's a lot going on today. There are \(pendingItems.count) todos scheduled and the first starts \(timeString).")
        }
    }
}

extension TodayViewController: ToDoTableInteractionDelegate {
    func update(item: ToDoItem) {
        guard let itemStatus = item.status else {
            //TODO: Handle error to update
            return
        }
        item.status = ToDoItem.Status(rawValue: itemStatus)?.toggle().rawValue
        DispatchQueue.main.async {
            self.updateStatus()
            CoreDataManager.shared.saveContext()
        }
    }
}

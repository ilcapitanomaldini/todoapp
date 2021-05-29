//
//  ToDoTableViewModel.swift
//  todoapp
//
//  Created by VM on 11/04/21.
//  Copyright © 2021 VM. All rights reserved.
//

import UIKit

protocol ToDoTableInteractionDelegate: class {
    func update(item: ToDoItem)
}

class ToDoTableViewModel: NSObject {
    var pendingToDoItems: [ToDoItem]
    var completedToDoItems: [ToDoItem]
    weak var delegate: ToDoTableInteractionDelegate?
    
    init(toDoItems: [ToDoItem], tableView: UITableView, delegate: ToDoTableInteractionDelegate) {
        pendingToDoItems = toDoItems.filter({$0.statusVar == ToDoItem.Status.pending})
        completedToDoItems = toDoItems.filter({$0.statusVar == ToDoItem.Status.completed})
        super.init()
        self.delegate = delegate
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(ToDoItemCell.nib, forCellReuseIdentifier: ToDoItemCell.reuseIdentifier)
        //to get rid of empty cells.
        tableView.tableFooterView = UIView()
    }
    
    func update(toDoItems: [ToDoItem]) {
        pendingToDoItems = toDoItems.filter({$0.statusVar == ToDoItem.Status.pending})
        completedToDoItems = toDoItems.filter({$0.statusVar == ToDoItem.Status.completed})
    }
}

extension ToDoTableViewModel: UITableViewDelegate {
    enum Section: Int {
        case pending = 0
        case completed = 1
        
        static var count: Int {
            return 2
        }
        
        func title() -> String {
            switch self {
            case .pending:
                return "Pending item"
            case .completed:
                return "Completed items"
            }
        }
    }
}

extension ToDoTableViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        switch section {
        case .pending:
            return pendingToDoItems.count
        case .completed:
            return completedToDoItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else {
            return nil
        }
        switch section {
        case .pending:
            if pendingToDoItems.count > 0 {
                return section.title()
            }
        case .completed:
            if completedToDoItems.count > 0 {
                return section.title()
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section), let cell = tableView.dequeueReusableCell(withIdentifier: ToDoItemCell.reuseIdentifier) as? ToDoItemCell else {
            return UITableViewCell()
        }
        switch section {
        case .pending:
            let item = pendingToDoItems[indexPath.row]
            cell.setup(title: item.descriptionText, date: item.scheduledDate ?? Date(), id: Int(item.id), toggleAction: { [weak self] (id, _) in
                guard let self = self, let index = self.pendingToDoItems.firstIndex(where: {$0.id == id}) else { return }
                //TODO: This switching block can probably be a method and can be reused
                let row  = self.completedToDoItems.count
                let switchingItem = self.pendingToDoItems.remove(at: index)
                self.completedToDoItems.append(switchingItem)
                
                self.delegate?.update(item: switchingItem)
                
                let fromIndexPath = IndexPath(row: index, section: Section.pending.rawValue)
                let toIndexPath = IndexPath(row: row, section: Section.completed.rawValue)
                
                tableView.beginUpdates()
                tableView.moveRow(at: fromIndexPath, to: toIndexPath)
                tableView.endUpdates()
                tableView.reloadRows(at: [toIndexPath], with: .none)
            })
            cell.setEnabledAesthetic()
            return cell
        case .completed:
            let item = completedToDoItems[indexPath.row]
            cell.setup(title: item.descriptionText, date: item.scheduledDate ?? Date(), id: Int(item.id), checkStatus: true, toggleAction: { [weak self] (id, _) in
                guard let self = self, let index = self.completedToDoItems.firstIndex(where: {$0.id == id}) else { return }
                
                let row  = self.pendingToDoItems.count
                let switchingItem = self.completedToDoItems.remove(at: index)
                self.pendingToDoItems.append(switchingItem)
                
                self.delegate?.update(item: switchingItem)
                
                let fromIndexPath = IndexPath(row: index, section: Section.completed.rawValue)
                let toIndexPath = IndexPath(row: row, section: Section.pending.rawValue)
                
                tableView.beginUpdates()
                tableView.moveRow(at: fromIndexPath, to: toIndexPath)
                tableView.endUpdates()
                tableView.reloadRows(at: [toIndexPath], with: .none)
            })
            cell.setDisabledAesthetic()
            return cell
        }
    }
}

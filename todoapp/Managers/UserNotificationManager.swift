//
//  UserNotificationManager.swift
//  todoapp
//
//  Created by VM on 11/04/21.
//  Copyright © 2021 VM. All rights reserved.
//

import UserNotifications

struct UserNotificationManager {
    static func generateNotification(for message: String, on date: Date){
        let notification = UNMutableNotificationContent()
        notification.title = "ToDo App"
        notification.subtitle = "You have a scheduled item!"
        notification.body = message
        let notifyTrigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)
        let request = UNNotificationRequest(identifier: "ToDoNotification", content: notification, trigger: notifyTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            //FIXME: Log or handle error
            debugPrint("Notification Error \(String(describing: error))")
        })
    }
}

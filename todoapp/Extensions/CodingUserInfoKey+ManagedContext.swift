//
//  CodingUserInfoKey+ManagedContext.swift
//  todoapp
//
//  Created by VM on 11/04/21.
//  Copyright © 2021 VM. All rights reserved.
//

import Foundation

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

//FIX ME: let decoder = JSONDecoder()
//decoder.userInfo[CodingUserInfoKey.managedObjectContext] = myPersistentContainer.viewContext

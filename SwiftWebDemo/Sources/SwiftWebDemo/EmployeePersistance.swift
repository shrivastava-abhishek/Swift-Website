//
//  EmployeePersistance.swift
//  SwiftWebDemo
//
//  Created by ABHISHEK SHRIVASTAVA on 05/04/18.
//

import Foundation
import CouchDB
// 1
import SwiftyJSON

extension Employee {
    // 2
    class Persistence {
        
        static func getAll(from database: Database,
                           callback: @escaping (_ employee: [Employee]?, _ error: NSError?) -> Void) {
            database.retrieveAll(includeDocuments: true) { documents, error in
                guard let documents = documents else {
                    callback(nil, error)
                    return
                }
                var employees: [Employee] = []
                for document in documents["rows"].arrayValue {
                    let id = document["id"].stringValue
                    let firstName = document["doc"]["firstName"].stringValue
                    let lastName = document["doc"]["lastName"].stringValue
                    if let employee = Employee(id: id, firstName: firstName, lastName: lastName) {
                        employees.append(employee)
                    }
                }
                callback(employees, nil)
            }
        }
        
        static func save(_ employee: Employee, to database: Database,
                         callback: @escaping (_ id: String?, _ error: NSError?) -> Void) {
            getAll(from: database) { employees, error in
                guard let employees = employees else {
                    return callback(nil, error)
                }
                // 3
                guard !employees.contains(employee) else {
                    return callback(nil, NSError(domain: "Kitura-TIL",
                                                 code: 400,
                                                 userInfo: ["localizedDescription": "Duplicate entry"]))
                }
                database.create(JSON(["firstName": employee.firstName, "lastName": employee.lastName])) { id, _, _, error in
                    callback(id, error)
                }
            }
        }
        
        // 4
        static func get(from database: Database, with id: String,
                        callback: @escaping (_ employee: Employee?, _ error: NSError?) -> Void) {
            database.retrieve(id) { document, error in
                guard let document = document else {
                    return callback(nil, error)
                }
                guard let employee = Employee(id: document["_id"].stringValue,
                                            firstName: document["firstName"].stringValue,
                                            lastName: document["lastName"].stringValue) else {
                                                return callback(nil, error)
                }
                callback(employee, nil)
            }
        }
        
        static func delete(with id: String, from database: Database,
                           callback: @escaping (_ error: NSError?) -> Void) {
            database.retrieve(id) { document, error in
                guard let document = document else {
                    return callback(error)
                }
                let id = document["_id"].stringValue
                // 5
                let revision = document["_rev"].stringValue
                database.delete(id, rev: revision) { error in
                    callback(error)
                }
            }
        }
    }
}

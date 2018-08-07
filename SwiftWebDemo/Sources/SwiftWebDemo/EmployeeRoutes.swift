//
//  EmployeeRoutes.swift
//  SwiftWebDemo
//
//  Created by ABHISHEK SHRIVASTAVA on 05/04/18.
//

import CouchDB
import Kitura
import KituraContracts
import LoggerAPI

private var database: Database?

func initializeEmployeeRoutes(app: App) {
    database = app.database
    // 1
    app.router.get("/employee", handler: getEmployee)
    app.router.post("/employee", handler: addEmployee)
    app.router.delete("/employee", handler: deleteEmployee)
}

// 2
private func getEmployee(completion: @escaping ([Employee]?, RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    Employee.Persistence.getAll(from: database) { employees, error in
        return completion(employees, error as? RequestError)
    }
}

// 3
private func addEmployee(employee: Employee, completion: @escaping (Employee?, RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    Employee.Persistence.save(employee, to: database) { id, error in
        guard let id = id else {
            return completion(nil, .notAcceptable)
        }
        Employee.Persistence.get(from: database, with: id) { newEmployee, error in
            return completion(newEmployee, error as? RequestError)
        }
    }
}

// 4
private func deleteEmployee(id: String, completion: @escaping (RequestError?) -> Void) {
    guard let database = database else {
        return completion(.internalServerError)
    }
    Employee.Persistence.delete(with: id, from: database) { error in
        return completion(error as? RequestError)
    }
}

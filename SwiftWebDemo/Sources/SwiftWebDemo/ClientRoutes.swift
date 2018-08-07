//
//  ClientRoutes.swift
//  SwiftWebDemo
//
//  Created by ABHISHEK SHRIVASTAVA on 09/04/18.
//

import Foundation
import KituraStencil
import Kitura

func initializeClientRoutes(app: App) {
    // 1
    app.router.setDefault(templateEngine: StencilTemplateEngine())
    // 2
    app.router.all(middleware: StaticFileServer())
    
    // 3
    app.router.get("/") { _, response, _ in
        if let database = app.database {
            // 1
            Employee.Persistence.getAll(from: database) { Employee, error in
                guard let Employee = Employee else {
                    response.send(error?.localizedDescription)
                    return
                }
                var contextEmployees: [[String: Any]] = []
                for employees in Employee {
                    // 2
                    if let id = employees.id {
                        // 3
                        let map = ["firstName": employees.firstName, "lastName": employees.lastName, "id": id]
                        contextEmployees.append(map)
                    }
                }
                // 4
                do {
                    try response.render("home", context: ["Employee": contextEmployees])
                } catch let error {
                    response.send(error.localizedDescription)
                }
            }
        }
    }
}

//
//  Application.swift
//  SwiftWebDemo
//
//  Created by ABHISHEK SHRIVASTAVA on 05/04/18.
//

// 1
import CouchDB
import Foundation
import Kitura
import LoggerAPI

public class App {
    
    // 2
    var client: CouchDBClient?
    var database: Database?
    
    let router = Router()
    
    private func postInit() {
        // 1
        let connectionProperties = ConnectionProperties(host: "localhost", port: 5984,secured: false, username:"abhishek" , password:"abhish")
        client = CouchDBClient(connectionProperties: connectionProperties)
        // 2
        client!.dbExists("employee") { exists, _ in
            guard exists else {
                // 3
                self.createNewDatabase()
                return
            }
            // 4
            Log.info("Employee database located - loading...")
            self.finalizeRoutes(with: Database(connProperties: connectionProperties, dbName: "employee"))
        }
    }
    
    private func createNewDatabase() {
        Log.info("Database does not exist - creating new database")
        // 1
        client?.createDB("employee") { database, error in
            // 2
            guard let database = database else {
                let errorReason = String(describing: error?.localizedDescription)
                Log.error("Could not create new database: (\(errorReason)) - employee routes not created")
                return
            }
            self.finalizeRoutes(with: database)
        }
    }
    
    private func finalizeRoutes(with database: Database) {
        self.database = database
        initializeEmployeeRoutes(app: self)
        initializeClientRoutes(app: self)
        Log.info("Employee routes created")
    }
    
    public func run() {
        // 6
        postInit()
        Kitura.addHTTPServer(onPort: 8080, with: router)
        Kitura.run()
    }
}

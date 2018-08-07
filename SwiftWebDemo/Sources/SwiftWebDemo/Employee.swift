//
//  Employee.swift
//  SwiftWebDemo
//
//  Created by ABHISHEK SHRIVASTAVA on 05/04/18.
//

// 1
struct Employee: Codable {
    
    var id: String?
    var firstName: String
    var lastName: String
    
    init?(id: String?, firstName: String, lastName: String) {
        // 2
        if firstName.isEmpty || lastName.isEmpty {
            return nil
        }
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}

// 3
extension Employee: Equatable {
    
    public static func ==(lhs: Employee, rhs: Employee) -> Bool {
        return lhs.lastName == rhs.lastName && lhs.firstName == rhs.firstName
    }
}

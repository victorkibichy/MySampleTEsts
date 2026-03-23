//
//  IntentsView.swift
//  MySampleTEsts
//
//  Created by Vic on 11/03/2026.
//

import SwiftUI
internal import Combine

// MARK: - Model: Employee
struct Employee: Identifiable, Hashable {
    let id: UUID
    let name: String
    let email: String
    let department: String

    init(id: UUID = UUID(), name: String, email: String, department: String) {
        self.id = id
        self.name = name
        self.email = email
        self.department = department
    }
}

// MARK: - Department Model
struct Department: Identifiable, Hashable {
    let id: UUID
    let name: String
    let employees: [Employee]

    init(id: UUID = UUID(), name: String, employees: [Employee]) {
        self.id = id
        self.name = name
        self.employees = employees
    }
}

// MARK: - Sample Departments
extension Department {

    static let sampleDepartments: [Department] = [

        Department(
            name: "Engineering",
            employees: [
                Employee(name: "Alice Johnson", email: "alice@example.com", department: "Engineering"),
                Employee(name: "David Brown", email: "david@example.com", department: "Engineering")
            ]
        ),

        Department(
            name: "Design",
            employees: [
                Employee(name: "Bob Smith", email: "bob@example.com", department: "Design")
            ]
        ),

        Department(
            name: "Marketing",
            employees: [
                Employee(name: "Carol Williams", email: "carol@example.com", department: "Marketing")
            ]
        ),

        Department(
            name: "HR",
            employees: [
                Employee(name: "Eva Martinez", email: "eva@example.com", department: "HR")
            ]
        )
    ]
}

// MARK: - ViewModel

class AppModel: ObservableObject {

    @Published var employees: [Employee] = Employee.sampleEmployees
    @Published var departments: [Department] = Department.sampleDepartments

    func employee(by id: Employee.ID) -> Employee? {
        employees.first { $0.id == id }
    }

    func department(id: Department.ID?) -> Department? {
        departments.first { $0.id == id }
    }
}
class AppModel2: ObservableObject {

    @Published var employees: [Employee] = Employee.sampleEmployees
    @Published var departments: [Department] = Department.sampleDepartments

    func employee(by id: Employee.ID) -> Employee? {
        employees.first { $0.id == id }
    }

    func department(id: Department.ID?) -> Department? {
        departments.first { $0.id == id }
    }
}

// MARK: - Shared Preview Instance
extension AppModel {
    static let shared: AppModel = {
        AppModel()
    }()
}

// MARK: - Detail View
struct EmployeeDetails: View {

    let employeeIds: Set<Employee.ID>
    let model: AppModel

    var selectedEmployees: [Employee] {
        employeeIds.compactMap { model.employee(by: $0) }
    }

    var body: some View {
        Text("Details here")
    }
}

// MARK: - Main View (3 Column Navigation)
struct IntentsView: View {

    @State private var departmentId: Department.ID?
    @State private var employeeIds: Set<Employee.ID> = []

     let model: AppModel

    var body: some View {

        NavigationSplitView {

            // COLUMN 1 — Departments
            List(model.departments, selection: $departmentId) { department in
                Text(department.name)
                    .tag(department.id)
            }
            .navigationTitle("Departments")

        } content: {

            // COLUMN 2 — Employees
            if let department = model.department(id: departmentId) {

                List(department.employees, selection: $employeeIds) { employee in
                    Text(employee.name)
                        .tag(employee.id)
                }
                .navigationTitle(department.name)

            } else {

                ContentUnavailableView(
                    "Select a department",
                    systemImage: "building.2"
                )

            }

        } detail: {

            // COLUMN 3 — Employee Details
            EmployeeDetails(
                employeeIds: employeeIds,
                model: model
            )

        }
    }
}

// MARK: - Previews
//#Preview {
//    IntentsView()
//        .environmentObject(AppModel.shared)
//}
extension Employee { static let sampleEmployees: [Employee] = [ Employee(name: "Alice Johnson", email: "alice@example.com", department: "Engineering"), Employee(name: "Bob Smith", email: "bob@example.com", department: "Design"), Employee(name: "Carol Williams", email: "carol@example.com", department: "Marketing"), Employee(name: "David Brown", email: "david@example.com", department: "Engineering"), Employee(name: "Eva Martinez", email: "eva@example.com", department: "HR") ] }

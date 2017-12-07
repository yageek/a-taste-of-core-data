//: # Faulting
//:
//: Faulting prevents to load unecessary elements into the graph.

import CoreData

// Model
let fileURL = Bundle.main.url(forResource: "SimpleGraph", withExtension: "momd")!
let model = NSManagedObjectModel(contentsOf: fileURL)!

// Coordinators
let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

// Persistent Stores
do {
    try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    
} catch let error {
    print("An error occurs during setting store: \(error)")
}

let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
context.persistentStoreCoordinator = coordinator

// Work in context one
let superBoss = Boss(context: context)
superBoss.name = "Javier"

let employee = Employee(context: context)
employee.name = "Yannick"
employee.speciality = "iOS"

employee.boss = superBoss

if context.hasChanges {
    do {
        try context.save()
    } catch let error {
        print("Impossible to save context one: \(error)")
    }
}
// Reset context to its basic state
context.reset()

// Fetch the only boss node
let request = NSFetchRequest<Employee>(entityName: "Employee")

do {
    let employee = try context.fetch(request).first!
    print("Employee with a faulting boss: \(employee.boss?.isFault)")
    // Once you access a property, the fault is loaded
    let boss = employee.boss!
    print("Boss name \(boss.name)")
    
    print("Employee with a filled fault boss: \(employee.boss?.isFault)")
} catch let error {
    print("Error: \(error)")
}


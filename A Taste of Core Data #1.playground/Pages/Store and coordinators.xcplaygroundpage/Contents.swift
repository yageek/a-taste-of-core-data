//: # Store and coordinators
//:
//: We use an `NSPersistentStoreCoordinator` to synchronize
//: and validate the data between the `NSManagedObject` instances
//: and the `NSPersistentStore` instances.
import CoreData

// Model
let fileURL = Bundle.main.url(forResource: "SimpleGraph", withExtension: "momd")!
let model = NSManagedObjectModel(contentsOf: fileURL)!

// Coordinators
let coordinatorOne = NSPersistentStoreCoordinator(managedObjectModel: model)

let coordinatorTwo = NSPersistentStoreCoordinator(managedObjectModel: model)

// Persistent Stores
do {
    // One
    let urlBin = URL(fileURLWithPath: "./element.bin")
    print("Binary path:\(urlBin)")
    try coordinatorOne.addPersistentStore(ofType: CoreData.NSBinaryStoreType, configurationName: nil, at: urlBin, options: nil)
    try coordinatorOne.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    
    // Two
    let sqliteBin = URL(fileURLWithPath: "./element.sqlite")
    print("SQLite path:\(sqliteBin)")
    try coordinatorTwo.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteBin, options: nil)
    
} catch let error {
    print("An error occurs during setting store: \(error)")
}

let contextOne = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
contextOne.persistentStoreCoordinator = coordinatorOne

let contextTwo = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
contextTwo.persistentStoreCoordinator = coordinatorTwo

// Work in context one
let superBoss = Boss(context: contextOne)
superBoss.name = "Javier"

let employee = Employee(context: contextOne)
employee.name = "Yannick"
employee.speciality = "iOS"

employee.boss = superBoss

if contextOne.hasChanges {
    do {
        try contextOne.save()
    } catch let error {
        print("Impossible to save context one: \(error)")
    }
}


// Work in context two
let someBoss = Boss(context: contextTwo)
someBoss.name = "Mathieu"

let otherEmployee = Employee(context: contextTwo)
otherEmployee.name = "David"
otherEmployee.speciality = "iOS"

otherEmployee.boss = someBoss

if contextTwo.hasChanges {
    do {
        try contextTwo.save()
    } catch let error {
        print("Impossible to save context two: \(error)")
    }
}

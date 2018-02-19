//: # Editing the node
//:
//: `NSManagedObjectContext` provides basic primitives to modify and access
//: the value and the properties. Let's try to play a little bit with them.
//:
//: Let create the stack as usual.
import CoreData

let fileURL = Bundle.main.url(forResource: "SimpleGraph", withExtension: "momd")!
let model = NSManagedObjectModel(contentsOf: fileURL)!

// Load Entities
let bossDescription = model.entitiesByName["Boss"]!
let employeeDescription = model.entitiesByName["Employee"]!

// Create Graph
let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

// Create one entity
let boss = NSManagedObject(entity: bossDescription, insertInto: context)

//: Now we use the primitives to read and modify the name.


// Get the default name
print("Boss name value: \(boss.value(forKey: "name"))")

// Change the name
boss.setValue("Changed Name with primitives", forKey: "name")
// Get the default name
print("Boss updated name value: \(boss.value(forKey: "name"))")

// Create one employee and add it to the boss employee sets.

let employee = NSManagedObject(entity: employeeDescription, insertInto: context)

let employeesSet = boss.mutableSetValue(forKey: "employees")
employeesSet.add(employee)
boss.setValue(employeesSet, forKey: "employees")

// Check the new sets
let set = boss.value(forKey: "employees") as! NSSet
print("Boss has : \(set.count) employee(s)")

for element in set {
    let object = element as! NSManagedObject
    print("Entity of element: \(object.entity.name)")
}

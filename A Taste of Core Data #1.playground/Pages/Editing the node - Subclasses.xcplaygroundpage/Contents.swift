//: # Editing the node - Subclasses
//:
//: We can creates our own subclass of object instead of using plain
//: `NSManagedObject` instances
//:
//: We simply create subclasses and use the @NSManaged statement for the
//: differents properties. We also need to tell to the `NSEntityDescription`
//: instance to which class it is attached using either the `managedObjectClassName`
//: property or using the model editor.
//:
//: Let create the stack as usual.
import CoreData

@objc(Boss)
public class Boss: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var bosses: Set<Boss>?
    @NSManaged var employees: Set<Employee>
    
    @NSManaged func addEmployeesObject(_ employee: Employee)
}

@objc(Employee)
public class Employee: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var boss: Boss?
}

let fileURL = Bundle.main.url(forResource: "SimpleGraph", withExtension: "momd")!
let model = NSManagedObjectModel(contentsOf: fileURL)!

let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
// Create an object and insert it
let bossDescription = model.entitiesByName["Boss"]!
let boss = Boss(entity: bossDescription, insertInto: context)
print("Boss name value: \(boss.name)")
// Change the name
boss.name = "Changed Name with primitives"

// Get the default name
print("Boss updated name value: \(boss.name)")

// Create one employee and add it to the boss employee sets.
let employeeDescription = model.entitiesByName["Employee"]!
let employee = Employee(entity: employeeDescription, insertInto: context)

boss.addEmployeesObject(employee)
// Check the new sets
let set = boss.employees
print("Boss has : \(set.count) employee(s)")

for element in set {
    print("Entity of element: \(element)")
}

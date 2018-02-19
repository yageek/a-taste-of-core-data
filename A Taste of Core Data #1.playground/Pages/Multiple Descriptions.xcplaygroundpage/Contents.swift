//:
//: # Multiple Entity Description
//:
//: The [previous](@previous) page showed
import CoreData


// Attributes
let nameBossAttr = NSAttributeDescription()
nameBossAttr.name = "name"
nameBossAttr.attributeType = .stringAttributeType
nameBossAttr.defaultValue = "No Name For Boss"

let nameEmployeeAttr = NSAttributeDescription()
nameEmployeeAttr.name = "name"
nameEmployeeAttr.attributeType = .stringAttributeType

let specialityAttr = NSAttributeDescription()
specialityAttr.name = "speciality"
specialityAttr.attributeType = .stringAttributeType

// Boss Description
let bossDescription = NSEntityDescription()
bossDescription.name = "Boss"

// Employee Description
let employeeDescription = NSEntityDescription()
employeeDescription.name = "Employee"

// Relationships
let bossOneRel = NSRelationshipDescription()
bossOneRel.name = "boss"
bossOneRel.minCount = 0
bossOneRel.maxCount = 1 // To-One
bossOneRel.destinationEntity = bossDescription

let underBossesRel = NSRelationshipDescription()
underBossesRel.name = "underBosses"
underBossesRel.minCount = 0
underBossesRel.maxCount = 0 // To-Many
underBossesRel.deleteRule = .nullifyDeleteRule
underBossesRel.destinationEntity = bossDescription

bossOneRel.inverseRelationship = underBossesRel
underBossesRel.inverseRelationship = bossOneRel

let bossesMulRel = NSRelationshipDescription()
bossesMulRel.name = "bosses"
bossesMulRel.minCount = 0
bossesMulRel.maxCount = 0  // To-Many
bossesMulRel.deleteRule = .nullifyDeleteRule
bossesMulRel.destinationEntity = bossDescription

let employeeMulRel = NSRelationshipDescription()
employeeMulRel.name = "employees"
employeeMulRel.minCount = 0
employeeMulRel.maxCount = 0  // To-Many
employeeMulRel.deleteRule = .nullifyDeleteRule
employeeMulRel.destinationEntity = employeeDescription

// Assign Relationships
bossDescription.properties = [employeeMulRel, underBossesRel, bossOneRel, nameBossAttr];
employeeDescription.properties = [bossesMulRel, nameEmployeeAttr, specialityAttr];

// Specifying inverse
bossesMulRel.inverseRelationship = employeeMulRel
employeeMulRel.inverseRelationship = bossesMulRel

// Create an object and insert it
let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

let obj1 = NSManagedObject(entity: bossDescription, insertInto: context)

// Check the context status.
print("The context has now: \(context.insertedObjects.count) objects inserted.")


//: [Next](@next)

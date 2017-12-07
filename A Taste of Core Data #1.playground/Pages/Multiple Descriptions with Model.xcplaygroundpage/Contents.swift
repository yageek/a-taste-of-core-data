//: # Multiple Descriptions With Models
//:
//: As seen in the [previous](@previous) page, describing the graph with code
//: is verbose and error prone. An alternative is to use the model editor to
//: generate an `NSManagedObjectModel` containing the entity description instances
//: we define with the editor.

import CoreData

let fileURL = Bundle.main.url(forResource: "SimpleGraph", withExtension: "momd")!
let model = NSManagedObjectModel(contentsOf: fileURL)!

let bossDescription = model.entitiesByName["Boss"]!

// Create an object and insert it

let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

let obj1 = NSManagedObject(entity: bossDescription, insertInto: context)

// Check the context status.
print("The context has now: \(context.insertedObjects.count) objects inserted.")


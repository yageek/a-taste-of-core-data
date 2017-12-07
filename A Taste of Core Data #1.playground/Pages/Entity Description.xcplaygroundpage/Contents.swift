//: [Previous](@previous)
//: # Entity Description
//:
//: As the first intializer was not working, we
//: have to use the seconde one. This one requires an
//: `NSEntityDescription` instance to create the object.
//:  This part see how to creates such a description.
//:
//: ## Documentation
//:
//: The documentation page of `NSEntityDescription` gives some hints:
//: *Entities are to managed objects what Class is to id, or—to use a database analogy—what tables are to rows. An instance specifies an entity’s name, its properties (its attributes and relationships, expressed by instances of NSAttributeDescription and NSRelationshipDescription) and the class by which it is represented.*
//:
//: *An NSEntityDescription object is associated with a specific class whose instances are used to represent entries in a persistent store in applications using the Core Data Framework. Minimally, an entity description should have*:
//: * A name
//: * The name of a managed object class. (If an entity has no managed object class name, it defaults to NSManagedObject.)
//:
//: Basically, `NSEntityDescription` describes the metadata associated to a node inside the graph.
//:
//: Let's implement the minimum information by just setting the name. (name of the managed object class will remains to the default value).

import CoreData

// Context
let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

// Description
let descriptionSimpleNode: NSEntityDescription = {
    let desc = NSEntityDescription()
    desc.name = "SimpleNode"
    return desc
}()

// Equivalent to: let node1 = NSManagedObject(entity: descriptionSimpleNode, insertInto: context)
let node1 = NSManagedObject(entity: descriptionSimpleNode, insertInto: nil)
context.insert(node1)

// Check the context status.
print("The context has now: \(context.insertedObjects.count) objects inserted.")

//: We were able to create a simple node and attach it to the graph.
//:
//: [Next](@next)

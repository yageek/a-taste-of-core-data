//: # A taste of CoreData - Lesson 1
//:
//: The goal of this lesson is just to present the semancitcs and basics concepts of CoreData
//:
//: ----
//:
//: In this section we will try to create a basic graph instance.
//: Do not hesitate to take a look at the CoreData documentation

import CoreData

//: ## Creation of the model
//:
//: Let create a context. We'll talk about concurrencyType in the next session

// Swift
let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

//: For the object/node, the documentation provides two initializers:
//:
//: As we only know that a context is, let's try to use the second one:

//: Initializing using a context
//var obj1 = NSManagedObject(context: context) // Comment/Uncomment

//: May be like this?
var obj2 = NSManagedObject() // Cool, but...
context.insert(obj2)

//: As you see, this was not the one.
//: (See documentation of `NSManagedObject`)






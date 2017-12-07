//: # Editing the graph
//:
//: ## Dynamicity of Objective-C 2.0
//:
//: Objective-c is a dynamic language where every class
//: can be transformed at runtime using the different `class_<method>` of `objc_<method>`.
//:
//: We know that using the `@dynamic` statement, we can define a property without synthezising it.
//: It is just a promises that at this property will exist at runtime. Kind of the equivalent
//: can be achieved by using @NSManaged in swift.


import Foundation

@objc class MyClass: NSObject {
    @NSManaged var value: NSString?
}

//: ```
//:  // Objective-C equivalent
//:  @interface MyClass: NSObject
//:  @propery(nonatomic, copy) NSString *value;
//:  @end
//:
//:  @implementation MyClass
//:  @dynamic value;
//:  @end
//: ```

//: Now if we call the `value` property wihtout synthesizing it, it will crash at runtime..

// The class is empty
let i = MyClass()
//print("Value: \(i.value)") // Uncomment and it will crash

//: We can implement this property getter and setter at runtime using the `ObjectiveC` framework

import ObjectiveC

//: Let first set a type for our Swift methods version of the IMP.

// typedef id (*IMP)(id self,SEL _cmd,...)
// Define a setter and getter type
typealias ValueGetter = @convention(c) (AnyObject, Selector) -> Any?
typealias ValueSetter = @convention(c) (AnyObject, Selector, NSString) -> Void

//: We set a default value to prevent a crash if get is called befire set
// Set default value to prevent crash
var objKey: UInt8 = 0
objc_setAssociatedObject(i, &objKey, "Default Value" as NSString, .OBJC_ASSOCIATION_COPY_NONATOMIC)

//: Let's provide some implementation for the setter and the getter
// Define a setter
let setter: ValueSetter = { (selfInstance, selector, value) in
    objc_setAssociatedObject(selfInstance, &objKey, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
}


// Define a getter
let getter: ValueGetter = { (selfInstance, selector) in
    return objc_getAssociatedObject(selfInstance, &objKey)
}

//: Then we can attach them to the class using the appropriate methods
// Attach the setter

let setterIMP = unsafeBitCast(setter, to: IMP.self)
let setterSignature = "v@:@".cString(using: String.defaultCStringEncoding)
let pS = UnsafePointer<Int8>(setterSignature)
class_addMethod(MyClass.self, Selector("setValue:"), setterIMP, pS)

// Attach the getter
let getterIMP = unsafeBitCast(getter, to: IMP.self)
let getterSignature = "@@:".cString(using: String.defaultCStringEncoding)
let pG = UnsafePointer<Int8>(getterSignature)
class_addMethod(MyClass.self, Selector("value"), getterIMP, pG)

//: Finally, let's play with the new methods
print("Value: \(i.value)")

// Update
i.value = "Changed value" as NSString

// Read
print("Value: \(i.value)")

//: It does not crash :)


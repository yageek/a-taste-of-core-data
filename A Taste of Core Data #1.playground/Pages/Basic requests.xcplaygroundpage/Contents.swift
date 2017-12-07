//: # Basic requests
//:
//: Let see the basic to fetch some date.
//: Let first take a big amount of data.

import CoreData
import Foundation
import CoreLocation

// Core Data stack
// Model
let fileURL = Bundle.main.url(forResource: "Earthquakes", withExtension: "momd")!
let model = NSManagedObjectModel(contentsOf: fileURL)!

// Coordinators
let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

let sqliteBin = URL(fileURLWithPath: "./earthquakes.sqlite")
// Persistent Stores
do {

    print("SQLite path:\(sqliteBin)")
    try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteBin, options: nil)
    
} catch let error {
    print("An error occurs during setting store: \(error)")
}
let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
context.persistentStoreCoordinator = coordinator
context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

// Parse input Data
let jsonFileURL = Bundle.main.url(forResource: "all_month", withExtension: "geojson")
let data = try! Data(contentsOf: jsonFileURL!)
let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [AnyHashable: Any]

let quakes = json["features"] as! [[String: AnyObject]]
print("Total objects: \(quakes.count)")

// Not optimal here
for remoteQuake in quakes {
    let quake = Quake(context: context)
    
    do {
        try quake.update(with: remoteQuake)
    } catch let error {
        print("Error during reading data: \(error)")
        context.delete(quake)
        continue
    }
}
print("Finished loading data :)")
if context.hasChanges {
    do {
        try context.save()
    } catch let error {
        print("Error during saving: \(error)")
    }
    print("Success to saved")
}

//: Great :) Now fetch some data and play with fetchRequests.
//:
//: Look for last 5 quake of the set in time
let request = NSFetchRequest<Quake>(entityName: "Quake")
request.fetchLimit = 5
request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
do {
    let previous = Date().timeIntervalSinceReferenceDate
    let elements = try context.fetch(request)
    let total = Date().timeIntervalSinceReferenceDate - previous
    print("Last 5 quakes: \(elements) - Searched in: \(total) s")
} catch let error {
    print("Error: \(error)")
}

//: Look for all quakes with magnitude > 2, ordered in Time
request.fetchLimit = 0
request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
request.predicate = NSPredicate(format: "magnitude > 2")
do {
    let previous = Date.timeIntervalSinceReferenceDate
    let elements = try context.fetch(request)
    let total = Date().timeIntervalSinceReferenceDate - previous
    print("All quakes greater than 2 in magnitude: \(elements.count) - Searched in: \(total) s")
} catch let error {
    print("Error: \(error)")
}

//: The same request on the coordinator directly (equivalent)
do {
    let previous = Date.timeIntervalSinceReferenceDate
    let elements = try coordinator.execute(request, with: context) as! [Quake]
    let total = Date().timeIntervalSinceReferenceDate - previous
    print("[Coordinator] All quakes greater than 2 in magnitude: \(elements.count) - Searched in: \(total) s")
} catch let error {
    print("Error: \(error)")
}

//: If the count only interests you, you can use count:
do {
    let previous = Date().timeIntervalSinceReferenceDate
    let count = try context.count(for: request)
        let total = Date().timeIntervalSinceReferenceDate - previous
    print("Count quakes greater than 2 in magnitude: \(count) total - Searched in: \(total) s")
} catch let error {
    print("Error: \(error)")
}
try! FileManager.default.removeItem(at: sqliteBin)


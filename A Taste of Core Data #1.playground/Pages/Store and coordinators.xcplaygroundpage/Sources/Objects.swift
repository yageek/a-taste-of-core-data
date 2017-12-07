import CoreData


@objc(Boss)
public class Boss: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var bosses: Set<Boss>?
    @NSManaged public var employees: Set<Employee>
    
    @NSManaged func addEmployeesObject(_ employee: Employee)
}

@objc(Employee)
public class Employee: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var speciality: String?
    @NSManaged public var boss: Boss?
}

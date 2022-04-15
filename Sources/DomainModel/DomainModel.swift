import AppKit
struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    var amountInUSD: Double
    
    init(amount: Int, currency: String){
        self.amount = amount
        self.currency = currency
        switch currency {
        case "USD":
            self.amountInUSD = Double(amount)
        case "GBP":
            self.amountInUSD = Double(amount) * 2
        case "CAN":
            self.amountInUSD = Double(amount) / 1.25
        case "EUR":
            self.amountInUSD = Double(amount) / 1.5
        default:
            self.amountInUSD = 0
        }
    }
    
    func convert(_ currencyCode: String) -> Money{
        switch currencyCode {
        case "USD":
            return Money(amount: Int(self.amountInUSD), currency: "USD")
        case "GBP":
            return Money(amount: Int(self.amountInUSD * 0.5), currency: "GBP")
        case "EUR":
            return Money(amount: Int(self.amountInUSD * 1.5), currency: "EUR")
        case "CAN":
            return Money(amount: Int(self.amountInUSD * 1.25), currency: "CAN")
        default:
            return Money(amount: -1, currency: "Cannot convert to this currency")
        }
    }
    
    func add(_ money: Money) -> Money{
        let total = money.amount + Int(self.convert(money.currency).amount)
        return Money(amount: total, currency: money.currency)
    }
    
    func subtract(_ money: Money) -> Money{
        let total = Int(self.convert(money.currency).amount) - money.amount
        return Money(amount: total, currency: money.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    let title: String
    var type: JobType
    
    init(title: String, type: JobType){
        self.title = title
        self.type = type
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    
    func calculateIncome(_ time: Int) -> Int{
        switch type {
        case .Hourly(let double):
            return Int(double * Double(time))
        case .Salary(let uInt):
            return Int(uInt)
        }
    }
    
    func raise(byAmount: Double) {
        switch type {
        case .Hourly(let double):
            self.type = JobType.Hourly(double + byAmount)
        case .Salary(let uInt):
            self.type = JobType.Salary(uInt + UInt(byAmount))
        }
    }
    
    func raise(byPercent: Double) {
        switch type {
        case .Hourly(let double):
            self.type = JobType.Hourly(double * (1 + byPercent))
        case .Salary(let uInt):
            self.type = JobType.Salary(UInt(Double(uInt) * Double(1 + byPercent)))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet{
            if age <= 15 {
                job = nil
            }
        }
    }
    var spouse: Person?{
        didSet{
            if age <= 17 {
                spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int){
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = nil
        self.spouse = nil
    }
    
    func toString() -> String{
        return String("[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(job?.title) spouse:\(spouse?.firstName)]")
    }
    
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person] = []
    
    init(spouse1: Person, spouse2: Person){
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members = [spouse1, spouse2]
        }
    }
    
    func haveChild(_ person: Person) -> Bool{
        if members.count >= 2 && (self.members[0].age >= 21 || self.members[1].age >= 21) {
            members.append(person)
            return true
        } else {
            return false
        }
        
    }
    
    func householdIncome() -> Int{
        var total = 0
        for person in members {
            total += person.job?.calculateIncome(2000) ?? 0
        }
        return total
    }
}

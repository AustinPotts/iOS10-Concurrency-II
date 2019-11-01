//: [Previous](@previous)


import UIKit

var sharedResource = 0
let lock = NSLock()
let group = DispatchGroup() //Making sure things happen in the order that we want them to




//All happening at once due to .concurrent \/
let concurrentQueue = DispatchQueue(label: "Concurrent Queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)


let numberOfIterations = 20_000

var startTime = CACurrentMediaTime()//Exact time something was executed, more precise

for _ in 0..<numberOfIterations {
    group.enter()
    concurrentQueue.async {
        lock.lock()
        
        
        sharedResource += 1
        
        
        lock.unlock()
        
        group.leave()
    }
}


group.wait() //Everything is going to pause here

var endTime = CACurrentMediaTime()
var elapsedTime = endTime - startTime
print("Time elapsed to add: \(numberOfIterations) with locks \(elapsedTime)")


//Using Queues Expample
let sharedResourceQueue = DispatchQueue(label: "Serial Queue")

startTime = CACurrentMediaTime()//Exact time something was executed, more precise

for _ in 0..<numberOfIterations {
    group.enter()
    concurrentQueue.async {
        
        sharedResourceQueue.sync {
            sharedResource += 1
            group.leave()
        }
        
    }
}


group.wait() //Everything is going to pause here

print("Shared Resource: \(sharedResource)")

 endTime = CACurrentMediaTime()
 elapsedTime = endTime - startTime
print("Time elapsed to add: \(numberOfIterations) with queues \(elapsedTime)")


//: [Next](@next)


import Foundation

var x = 42

let sharedAccessQueue = DispatchQueue(label: "Shared Resource Queue")

extension NSLock {
    func withLock(_ work: () -> Void){ //This will help lock & unlock NSLock without having to call both
        lock()
        work()
        unlock()
    }
}

//This will not print out 142 because there is no thread safety, each computer runs the same thing at the same time without
DispatchQueue.concurrentPerform(iterations: 100) { threadNumber in
    
    sharedAccessQueue.sync {
        
        print("Executing concurrent perform \(threadNumber + 1)")
        var localCopy = x
        localCopy += 1
        x = localCopy
    }
  
//    lockForX.withLock {
//         var localCopy = x
//           localCopy += 1
//           x = localCopy
//    }
    //Using locks allows us to effectiley access
}
print(x)



var listOfNames: [String] = []
let nameLock = NSLock()
let sharedAccessQueue2 = DispatchQueue(label: "Network Access Queue")//Label of Queue

//Lock resources that will be concurrently accessed

URLSession.shared.dataTask(with: URL(string: "https://swapi.co/people/1/")!) { (data, response, error) in
    
//    DispatchQueue.main.async {
//        listOfNames.append("Luke")   //Running on main queue
//        print(listOfNames)
//    }
    
    sharedAccessQueue2.async { //Do not wait-async
       // nameLock.lock()
        listOfNames.append("Luke")
        print(listOfNames)
       // nameLock.unlock()  //These are no longer needed when using sharedAccessQueue
    }
    
    
       
}.resume()

URLSession.shared.dataTask(with: URL(string: "https://swapi.co/people/1/")!) { (data, response, error) in
    
    sharedAccessQueue2.async {
       // nameLock.lock()
        listOfNames.append("Han")
        print(listOfNames)
       // nameLock.unlock() //These are no longer needed when using sharedAccessQueue
    }
    
    
       
}.resume()

URLSession.shared.dataTask(with: URL(string: "https://swapi.co/people/1/")!) { (data, response, error) in
    
    sharedAccessQueue2.async {
        //nameLock.lock()
         listOfNames.append("Yoda")
         print(listOfNames)
         //nameLock.unlock() //These are no longer needed when using sharedAccessQueue
    }
     
         
       
}.resume()

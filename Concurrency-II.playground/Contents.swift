import Foundation

var x = 42
let lockForX = NSLock()

extension NSLock {
    func withLock(_ work: () -> Void){ //This will help lock & unlock NSLock without having to call both
        lock()
        work()
        unlock()
    }
}

//This will not print out 142 because there is no thread safety, each computer runs the same thing at the same time without
DispatchQueue.concurrentPerform(iterations: 100) { _ in
  
    lockForX.withLock {
         var localCopy = x
           localCopy += 1
           x = localCopy
    }
   
    //Using locks allows us to effectiley access
   
}

print(x)



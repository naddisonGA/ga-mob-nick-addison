//: Playground - noun: a place where people can play

import UIKit


var str = "Hello, playground"

class Async
{
    func each<T, R>(array: [T], iterator: (T, (R?, NSError?) -> () ) -> (), callback: ([R?]?, NSError?) -> () )
    {
        var resultArray = [R?]()
        var resultError: NSError? = nil
        
        // for each item in the array of type T
        for item in array
        {
            // call the iterator function for the item in the array
            iterator(item) {
                (result, error) in
                
                // if iterator returned an error
                if error != nil
                {
                    // and this is the first iterator to return an error
                    if resultError == nil
                    {
                        // set the iterator error to the resultError so we no the callback has already been called if other iteators error
                        resultError = error
                        
                        // pass the error back in the callback
                        callback(nil, error)
                    }
                    
                    // if not the first iterator to error then just ignore it as we have already call the callback with the first error
                }
                // if no error was returned
                else
                {
                    // add the result of the iterator to the result array
                    // note its possible to add a nil result
                    resultArray.append(result)
                    
                    // if the last callback to be
                    if resultArray.count == array.count
                    {
                        callback(resultArray, nil)
                    }
                }
            }
        }
    }
    
    static func series(
        // array of functions with take a callback function as their parameters
        // the callback function takes optional NSError and AnyObject
        tasks: [(callback: (error: NSError?, result: Any?) ->() ) -> ()],
        completionHandler: ([AnyObject]?, NSError?) -> () )
    {
        var tasksProcessed = 0
        var resultArray = [Any?]()
        var resultError: NSError? = nil
        
        var iterate: (()->())!
        // then set iterate variable to the real iterate fucntion
        iterate =
            {
                tasks[tasksProcessed]
                
                // resultArray[tasksProcessed]
        }
        
        // start the first iteration
        iterate()
    }
}


func add(a: Int, b: Int) -> Int
{
    return a + b
}

func minus(a: Int, b: Int) -> Int
{
    return a - b
}

add(1, 2)
minus(1, 2)

let funcArray = [add, minus]

funcArray[0](1,1)


func log(txt: String, #resolve: () -> (), #reject: () -> ()) {
    var delta: Int64 = 1 * Int64(NSEC_PER_SEC)
    var time = dispatch_time(DISPATCH_TIME_NOW, delta)
    
    dispatch_after(time, dispatch_get_main_queue(), {
        println("closures are " + txt)
        resolve()
    });
}

log("not the same as JS closures",
    resolve: {
        println("and done")
    },
    reject: {
        // handle errors
})



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
}

func fib(n: Int) -> Int {
    return n < 2 ? n : (fib(n — 1) + fib(n — 2))
}
println(fib(10))


func factorial(n: Int) -> Int {
    return n == 0 ? 1 : n * factorial(n — 1)
}

func sum(n: Int, acc: Int) -> Int {
    if n == 0 { return acc }
    else { return sum(n - 1, acc + 1) }
}

println(factorial(5))


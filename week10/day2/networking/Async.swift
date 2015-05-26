//
//  Async.swift
//  networking
//
//  Created by Nicholas Addison on 11/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Dollar

// Swift implementation of Node.js async library https://github.com/caolan/async
// used to control the flow of asynchronous calls
class Async
{
    // Implementation of async.each https://github.com/caolan/async#each
    // iterator callback only returns an error. It does not return any reults
    static func each<T>(
        array: [T],
        iterator: (arrayItem: T, callabck: (error: NSError?) -> () ) -> (),
        completionHandler: (error: NSError?) -> () )
    {
        var iteratorsProcessed = 0
        var resultError: NSError? = nil
        
        // for each item in the array of type T
        for item in array
        {
            // call the iterator function for the item in the array
            iterator(arrayItem: item) {
                (error) in
                
                // if iterator returned an error
                if error != nil
                {
                    // and this is the first iterator to return an error
                    if resultError == nil
                    {
                        // set the iterator error to the resultError so we no the callback has already been called if other iteators error
                        resultError = error
                        
                        // pass the error back in the callback
                        completionHandler(error: error)
                    }
                    
                    // if not the first iterator to error then just ignore it as we have already called the callback with the first error
                }
                    // if no error was returned
                else
                {
                    // increment the number of iterators that have been processed
                    iteratorsProcessed++
                    
                    // if all iterators have been processed
                    if iteratorsProcessed >= array.count
                    {
                        // pass the results from all the iterators back in the callback
                        completionHandler(error: nil)
                    }
                }
            }
        }
    }
    
    // Implementation of async.each https://github.com/caolan/async#each
    // iterator callback returns optional result
    static func each<T,R>(
        array: [T],
        iterator: (arrayItem: T, callback: (result: R?, error: NSError?) -> () ) -> (),
        completionHandler: (results: [R]?, error: NSError?) -> () )
    {
        var iteratorsProcessed = 0
        var resultArray = [R]()
        var resultError: NSError? = nil
        
        // for each item in the array of type T
        for item in array
        {
            // call the iterator function for the item in the array
            iterator(arrayItem: item) {
                (result, error) in
                
                // if iterator returned an error
                if error != nil
                {
                    // and this is the first iterator to return an error
                    if resultError == nil
                    {
                        // set the iterator error to the resultError so we know the callback has already been called if other iteator errors
                        resultError = error
                        
                        // pass the error back in the callback
                        completionHandler(results: nil, error: error)
                    }
                    
                    // if not the first iterator to error then just ignore it as we have already called the callback with the first error
                }
                // if no error was returned
                else
                {
                    iteratorsProcessed++
                    
                    if let result = result
                    {
                        // add the result of the iterator to the result array
                        resultArray.append(result)
                    }
                    
                    // if all iterators have been processed
                    if iteratorsProcessed >= array.count
                    {
                        // pass the results from all the iterators back in the callback
                        completionHandler(results: resultArray, error: nil)
                    }
                }
            }
        }
    }
    
    // Implementation of async.each https://github.com/caolan/async#each
    // iterator callback returns optional array of results
    static func each<T,R>(
        array: [T],
        iterator: (arrayItem: T, callback: (result: [R]?, error: NSError?) -> () ) -> (),
        completionHandler: (results: [R]?, error: NSError?) -> () )
    {
        var iteratorsProcessed = 0
        var resultsArray = [R]()
        var resultError: NSError? = nil
        
        // for each item in the array of type T
        for item in array
        {
            // call the iterator function for the item in the array
            iterator(arrayItem: item) {
                (results, error) in
                
                // if iterator returned an error
                if error != nil
                {
                    // and this is the first iterator to return an error
                    if resultError == nil
                    {
                        // set the iterator error to the resultError so we know the callback has already been called if other iteator errors
                        resultError = error
                        
                        // pass the error back in the callback
                        completionHandler(results: nil, error: error)
                    }
                    
                    // if not the first iterator to error then just ignore it as we have already called the callback with the first error
                }
                    // if no error was returned
                else
                {
                    iteratorsProcessed++
                    
                    if let results = results
                    {
                        // merge the results array of the iterator to the final results array
                        resultsArray = $.merge(resultsArray, results)
                    }
                    
                    // if all iterators have been processed
                    if iteratorsProcessed >= array.count
                    {
                        // pass the results from all the iterators back in the callback
                        completionHandler(results: resultsArray, error: nil)
                    }
                }
            }
        }
    }
    
    // Implementation of async.eachSeries https://github.com/caolan/async#eachSeries
    static func eachSeries<T, R>(
        array: [T],
        iterator: (arrayItem: T, callback: (R?, NSError?) -> () ) -> (),
        completionHandler: (results: [R]?, error: NSError?) -> () )
    {
        var iteratorsProcessed = 0
        var resultArray = [R]()
        var resultError: NSError? = nil
        
        // the following is a workaround the problem that local functions can't reference themselves
        // http://stackoverflow.com/questions/25808885/no-self-reference-to-callback-function-possible
        // initialize the iterate function to do nothing
        var iterate: (()->())!
        // then set iterate variable to the real iterate fucntion
        iterate =
        {
            iterator(arrayItem: array[resultArray.count]) {
                result, error in
                
                if error != nil
                {
                    if resultError == nil
                    {
                        resultError = error
                        
                        completionHandler(results: nil, error: error)
                    }
                    
                    // if not the first iterator to error then just ignore it as we have already call the callback with the first error. That is, do not call iterate()
                }
                // if no error was returned
                else
                {
                    iteratorsProcessed++
                    
                    if let result = result
                    {
                        // add the result of the iterator to the result array
                        resultArray.append(result)
                    }
                    
                    // if all iterators have been processed
                    if iteratorsProcessed == array.count
                    {
                        // pass the results from all the iterators back in the callback
                        completionHandler(results: resultArray, error: nil)
                    }
                    else
                    {
                        // perform the next iteration
                        iterate()
                    }
                }
            }
        }
        
        // start the first iteration
        iterate()
    }
    
    // no result return in iterator
    static func eachSeries<T>(
        array: [T],
        // no result returned in iterator callback
        iterator: (arrayItem: T, callback: (error: NSError?) -> () ) -> (),
        completionHandler: (NSError?) -> () )
    {
        // wrap the iterator with no result return with one where a result is returned
        func wrapperIterator(arrayItem: T, wrpperCallback: (result: Any?, error: NSError?) -> () )
        {
            // call iterator with not result returned
            iterator(arrayItem: arrayItem) {
                error in
                
                // pass nil result back in the wrapper callback
                wrpperCallback(result: nil, error: error)
            }
        }
        
        Async.eachSeries(array, iterator: wrapperIterator) {
            results, error in
            
            completionHandler(error)
        }
    }
    
    static func series (
        // array of functions with take a callback function as their parameters
        // the callback function takes optional NSError and AnyObject
        tasks: [(callback: (result: Any?, error: NSError?) ->() ) -> ()],
        completionHandler: (results: [Any?]?, error: NSError?) -> () )
    {
        var tasksProcessed = 0
        var resultArray = [Any?]()
        var resultError: NSError? = nil
        
        // the following is a workaround the problem that local functions can't reference themselves
        // http://stackoverflow.com/questions/25808885/no-self-reference-to-callback-function-possible
        // initialize the iterate function to do nothing
        var iterate: (()->())!
        // then set iterate variable to the real iterate fucntion
        iterate =
        {
            tasks[tasksProcessed] {
                result, error in
                
                if error != nil
                {
                    if resultError == nil
                    {
                        resultError = error
                        
                        completionHandler(results: nil, error: error)
                    }
                    
                    // if not the first iterator to error then just ignore it as we have already call the callback with the first error. That is, do not call iterate()
                }
                // if no error was returned
                else
                {
                    tasksProcessed++
                    
                    resultArray.append(result)
                    
                    // if all tasks have been processed
                    if tasksProcessed == tasks.count
                    {
                        // pass the results from all the iterators back in the callback
                        completionHandler(results: resultArray, error: nil)
                    }
                    else
                    {
                        // perform the next iteration
                        iterate()
                    }
                }
            }
        }
        
        // start the first iteration
        iterate()
    }
    
    // Implementation of async.each https://github.com/caolan/async#each
    // iterator callback only returns an error. It does not return any reults
    static func parallel<T>(
        // array of functions with take a callback function as their parameters
        // the callback function takes optional NSError and AnyObject
        tasks: [(callback: (result: Any?, error: NSError?) ->() ) -> ()],
        completionHandler: (results: [Any?]?, error: NSError?) -> () )
    {
        var tasksProcessed = 0
        var resultArray = [Any?]()
        var resultError: NSError? = nil
        
        // for each taks
        for task in tasks
        {
            // execute the task function
            task {
                result, error in
                
                // if task returned an error
                if error != nil
                {
                    // and this is the first task to return an error
                    if resultError == nil
                    {
                        // set the task error to the resultError so we know the callback has already been called if other task errors
                        resultError = error
                        
                        // pass the error back in the callback
                        completionHandler(results: nil, error: error)
                    }
                    
                    // if not the first task to error then just ignore it as we have already called the callback with the first error
                }
                // if no error was returned
                else
                {
                    // increment the number of tasks that have been processed
                    tasksProcessed++
                    
                    resultArray.append(result)
                    
                    // if all iterators have been processed
                    if tasksProcessed >= tasks.count
                    {
                        // pass the results from all the iterators back in the callback
                        completionHandler(results: resultArray, error: nil)
                    }
                }
            }
        }
    }
}



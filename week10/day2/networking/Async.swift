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
    // iterator completionHandler only returns an error. It does not return any reults
    static func each<T>(
        array: [T],
        iterator: (T, (NSError?) -> () ) -> (),
        completionHandler: (NSError?) -> () )
    {
        var iteratorsProcessed = 0
        var resultError: NSError? = nil
        
        // for each item in the array of type T
        for item in array
        {
            // call the iterator function for the item in the array
            iterator(item) {
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
                        completionHandler(error)
                    }
                    
                    // if not the first iterator to error then just ignore it as we have already call the callback with the first error
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
                        completionHandler(nil)
                    }
                }
            }
        }
    }
    
    // Implementation of async.each https://github.com/caolan/async#each
    // iterator completionHandler returns optional result
    static func each<T, R>(
        array: [T],
        iterator: (T, (R?, NSError?) -> () ) -> (),
        completionHandler: ([R]?, NSError?) -> () )
    {
        var iteratorsProcessed = 0
        var resultArray = [R]()
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
                        completionHandler(nil, error)
                    }
                    
                    // if not the first iterator to error then just ignore it as we have already call the callback with the first error
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
                        completionHandler(resultArray, nil)
                    }
                }
            }
        }
    }
    
    // Implementation of async.each https://github.com/caolan/async#each
    // iterator completionHandler returns optional array of optional results
    static func each<T, R>(
        array: [T],
        iterator: (T, ([R]?, NSError?) -> () ) -> (),
        completionHandler: ([R]?, NSError?) -> () )
    {
        var iteratorsProcessed = 0
        var resultsArray = [R]()
        var resultError: NSError? = nil
        
        // for each item in the array of type T
        for item in array
        {
            // call the iterator function for the item in the array
            iterator(item) {
                (results, error) in
                
                // if iterator returned an error
                if error != nil
                {
                    // and this is the first iterator to return an error
                    if resultError == nil
                    {
                        // set the iterator error to the resultError so we no the callback has already been called if other iteators error
                        resultError = error
                        
                        // pass the error back in the callback
                        completionHandler(nil, error)
                    }
                    
                    // if not the first iterator to error then just ignore it as we have already call the callback with the first error
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
                        completionHandler(resultsArray, nil)
                    }
                }
            }
        }
    }
    
    // Implementation of async.eachSeries https://github.com/caolan/async#eachSeries
    static func eachSeries<T, R>(
        array: [T],
        iterator: (T, (R?, NSError?) -> () ) -> (),
        completionHandler: ([R]?, NSError?) -> () )
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
            iterator(array[resultArray.count]) {
                (result, error) in
                
                if error != nil
                {
                    if resultError == nil
                    {
                        resultError = error
                        
                        completionHandler(nil, error)
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
                        completionHandler(resultArray, nil)
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
}



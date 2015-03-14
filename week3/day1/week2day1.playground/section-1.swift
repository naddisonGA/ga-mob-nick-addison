// Playground - noun: a place where people can play

import UIKit

enum Size : String {
    case small, medium, large
}

class Animal
{
    var name: String
    var clean: Bool
    var id: Int?
    
    init(name: String, clean: Bool)
    {
        self.name = name
        self.clean = clean
    }
}

class Dog: Animal
{
    let breed: String
    let size: Size
    var owner: String?
    
    var puppies: [Dog]
    
    init(name: String, breed: String, size: Size)
    {
        self.breed = breed
        self.size = size
        
        puppies = []
        
        super.init(name: name, clean: true)
    }
    
    func bark() -> String
    {
        if (size == Size.small)
        {
            return "yap"
        }
        else
        {
            return "woof"
        }
        
    }
    
    func clean()
    {
        self.clean = true
    }
    
    func addPuppies(puppies: [Dog])
    {
        //puppies = [Dog(name: "puppy dog", breed: "German", size: Size.small)]
        
        self.puppies += puppies
    }
    
    func doesLike(animal: Animal) -> Bool
    {
        if (animal is Dog)
        {
            return true
        }
        else
        {
            return false
        }
    }
}

class Cat: Animal
{
    let fur: String
    
    init(name: String, clean: Bool = true, fur: String)
    {
        self.fur = fur
        
        super.init(name: name, clean: clean)
    }
}

let smallDog = Dog(name: "Yappie", breed: "Jack Russell", size: Size.small)
let largeDog = Dog(name: "Bruce", breed: "kelpie", size: Size.large)
let furryCat = Cat(name: "Fluffy", fur: "long")

smallDog.bark()
smallDog.doesLike(largeDog)
smallDog.doesLike(furryCat)
smallDog.owner

println("owner \(smallDog.owner)" )

smallDog.owner = "me"
smallDog.owner

smallDog.id = 234234
smallDog.id! + 1


smallDog.puppies.append(largeDog)
smallDog.puppies.count

var cup = Size.small

var puppies = [Dog(name: "my dog", breed: "German", size: Size.small)]
puppies.count

smallDog.addPuppies(puppies)

puppies.count



# OSJSON
Simple Objective-C wrapper for consuming JSON in Swift.

## Why?
Having decided to write some API wrappers in Swift, we ran in to the age old
problem that writing JSON parsing wrappers in is a little bit painful, with
`guard`s and `as?`s and `if let`s all over the place. So we searched the internet
and the internet told us their favourite Swift JSON library. And we liked the
look of plenty of them. All had pros and cons around their API, but they all
allowed us to write more expressive, more focussed code.

Then we timed them. And they all had the same problem. They were slow compared
to an equivalent piece of Objective-C code using good old `NSJSONSerialization`.
So we removed them all and added back in our original, `guard` and cast heavy
code. And it was _slightly_ faster. Our test was parsing a json file with a
dictionary and an array of 100 other dictionaries in to a set of model objects,
using an XCTest `measure` block. Our results for various swift libraries ranged
from 1.5 seconds in the extreme, to around 0.05 seconds for the common case.
Our library free implementation managed 0.042 seconds.

## What?
Go back to Objective-C. Basically, we're just letting the Objective-C runtime
handle the "type safety" issues. We know this is cheating and isn't true type
safety, but hey, it's our JSON, so we're happy to take the risk. And do you know
what, it's way faster. 0.007 seconds to parse the same JSON in to our model.

So we know it's dirty, but it works.

## Example
```swift
import OSJSON

struct MyModel: Decodable {
  let firstName: String
  let lastName: String
  let address: String?

  init?(json: JSON) {
    guard let firstName = json.stringValueForKey("firstName"),
              lastName = json.stringValueForKey("lastName") else {
                  return nil
    }
    let address = json.stringValueForKey("address")
    self.init(firstName: firstName, lastName: lastName, address: address)
  }
}
```
So it's still `guard`-heavy on required values, but lets the Objective-C runtime
take care of the type safety.

## Using it in your own project
We use Carthage, so just add
```
github "OrdnanceSurvey/osjson-ios"
```
to your Cartfile and run `carthage update --platform iOS`

## License
This framework is released under the [Apache 2.0 License](LICENSE)

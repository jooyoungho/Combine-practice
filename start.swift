import Combine
import Foundation
Just(5).sink {
    i in 
    print(i)
}

class CustomSubscrbier: Subscriber {
    func receive(completion: Subscribers.Completion<Never>) {
        print("Done")
    }
    
    func receive(subscription: Subscription) {
        print("Start")
        subscription.request(.max(2))
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        print("Data", input)
        return .unlimited
    }
    typealias Input = String
    typealias Failure = Never
}

let publisher = ["A","B","C","D","E","F","G"].publisher

let formatter = NumberFormatter()
formatter.numberStyle = .ordinal
(1...10).publisher.map {
    formatter.string(from: NSNumber(integerLiteral: $0)) ?? ""
}.sink {
    print($0)
}
let subscriber = CustomSubscrbier()
publisher.subscribe(subscriber)


let subject = PassthroughSubject<String, Error>()
subject.sink(receiveCompletion: {
    completion in
    switch completion {
    case .failure:
        print("error") 
    case .finished:
        print("end")
    }
}, receiveValue: { print($0) })

subject.send("A")
subject.send("B")
subject.send(completion: .finished)


let currentStatus = CurrentValueSubject<Bool, Error>(true)

currentStatus.sink(receiveCompletion: { com in
    switch com {
    case .finished:
        print("end") 
    case .failure:
        print("error")
    }
    
}, receiveValue: {print($0)})

currentStatus.send(true)


let exProvider = PassthroughSubject<String, Never>()
let anyCancleable = exProvider.sink { print($0) }
let anyCancleable2 = exProvider.sink { print($0) }

exProvider.send("A")
exProvider.send("B")
exProvider.send("C")

anyCancleable.cancel()

exProvider.send("D")



protocol OneElementSequence {
    associatedtype Element

    mutating func append(_ x: Element)
    func get() -> Element?
}


// fast read
// slow write
struct OneElementArray<T>: OneElementSequence {
    typealias Element = T

    private var array = [Element]()

    mutating func append(_ x: Element) {
        self.array.append(x)
    }

    func get() -> Element? {
        return self.array.first
    }
}


// slow read
// fast write
struct OneElementLinkedList<T>: OneElementSequence {
    typealias Element = T

    private var value: Element?

    mutating func append(_ x: Element) {
        self.value = x
    }

    func get() -> Element? {
        return self.value
    }
}


struct AnyOneElementSequence<T>: OneElementSequence {
    typealias Element = T


    private let _append: (Element) -> Void
    private let _get: () -> Element?


    //   Seq <- OneElementLinkedList<T>           OneElementLinkedList.Element -> Int => AnyOneElementSequence<Int>
    init<Seq: OneElementSequence>(seq: Seq) where Seq.Element == Element {
        var varSeq = seq

        self._append = { x in
            varSeq.append(x)
        }

        self._get = {
            return varSeq.get()
        }
    }


    mutating func append(_ x: T) {
        self._append(x)
    }

    func get() -> T? {
        return self._get()
    }
}


let x = AnyOneElementSequence(seq: OneElementLinkedList<Int>())



class OneElementArrayUser {
    init() {}

    private var seq: AnyOneElementSequence<Int>?
}
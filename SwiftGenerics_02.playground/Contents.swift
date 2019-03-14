import UIKit

// MARK: - Задача 2

// MARK: - Additional

extension Array {
    func get(_ index: Int) -> Element? {
        guard (index) < count else {return nil}
        return self[index]
    }
    
}

// MARK: - Container Protocol

protocol Container {
    associatedtype Value
    var count: Int {get}
    mutating func append(_ element: Value)
    func element(at index: Int) -> Value?
}

// MARK: - LinkedList

class LinkedListNode<T> {
    var value: T
    var next: LinkedListNode?
    weak var previous: LinkedListNode?
    
    public init(value: T) {
        self.value = value
    }
}

extension LinkedListNode: CustomStringConvertible {
    public var description: String {
        return "LinkedListNode<\(T.self)>; value: \(self.value); next: \(self.next?.simpleDescription ?? "nil"); previous: \(self.previous?.simpleDescription  ?? "nil")"
    }
    
    public var simpleDescription: String {
        return "LinkedListNode<\(T.self)>; value: \(self.value);"
    }
}

struct LinkedList<T>: Container {
    typealias Value = T
    
    private var head: LinkedListNode<T>?
    
    public var count: Int {
        guard var node = head else {
            return 0
        }
        
        var count = 1
        while let next = node.next {
            node = next
            count += 1
        }
        return count
    }
    
    public var first: LinkedListNode<T>? {
        return head
    }
    
    public var last: LinkedListNode<T>? {
        guard var node = head else {
            return nil
        }
        
        while let next = node.next {
            node = next
        }
        return node
    }
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    mutating func append(_ element: Value) {
        let newNode = LinkedListNode(value: element)
        if let lastNode = last {
            newNode.previous = lastNode
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }
    
    func element(at index: Int) -> Value? {
        return node(at: index)?.value
    }
    
    func node(at index: Int) -> LinkedListNode<T>? {
        if index == 0 {
            return head
        } else {
            var node = head?.next
            for _ in 1..<index {
                node = node?.next
                if node == nil { //(*1)
                    break
                }
            }
            return node
        }
    }
    
    public subscript(index: Int) -> LinkedListNode<T>? {
        return self.node(at: index)
    }
    
    static func +=(lhs: inout LinkedList, rhs: LinkedList) {
        var rhsNode = rhs.head
        var lhsLastNode = lhs.last
        while let node = rhsNode {
            lhsLastNode?.next = node
            lhsLastNode = node
            rhsNode = rhsNode?.next
        }
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        var s = "LinkedList<\(Value.self)>["
        var node = head
        while node != nil {
            s += "\(node!.value)"
            node = node!.next
            if node != nil { s += ", " }
        }
        return s + "]"
    }
}

extension LinkedList: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Value
    init(arrayLiteral elements: LinkedList.ArrayLiteralElement...) {
        elements.forEach {append($0)}
    }
    
    init(_ elements: [T]) {
        elements.forEach {append($0)}
    }
}



//var list: LinkedList<String> = ["34","51425","54315"]
//
//list.append("4")
//list.append("5")
//list.append("1")
//list += ["95","2345"]
//list += ["1"]
//print(list.count)
//print(list.node(at: 2))
//print(list[4])
//print(list)
//print(list[59])
//
//var intList: LinkedList<Int> = [1,2,3,54,5,4,6]
//
//print(intList)


// MARK: - Queue

struct Queue<T>: Container {
    
    typealias Value = T
    
    private var array = [T?]()
    private var head = 0
    
    var isEmpty: Bool {
        return count == 0
    }
    
    var count: Int {
        return array.count - head
    }
    
    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        
        array[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
    
    var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
    
    mutating func append(_ element: T) {
        enqueue(element)
    }
    
    func element(at index: Int) -> T? {
        return array.get(index)?.flatMap{$0}
    }
    
    public subscript(index: Int) -> T? {
        return array.get(index)?.flatMap{$0}
    }
    
    static func +=(lhs: inout Queue, rhs: Queue) {
        for value in rhs.array.compactMap({$0}) {
            lhs.enqueue(value)
        }
    }
    
}

extension Queue: CustomStringConvertible {
    public var description: String {
        return array.description
    }
}

extension Queue: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Value
    init(arrayLiteral elements: Queue.ArrayLiteralElement...) {
        elements.forEach {enqueue($0)}
    }
    
    init(_ elements: [T]) {
        elements.forEach {enqueue($0)}
    }
}

//var queueInt: Queue<Int> = []
//
//queueInt += [1,2,3,4]
//print(queueInt)
//print(queueInt.dequeue())
//print(queueInt)
//print(queueInt.dequeue())
//print(queueInt)
//print(queueInt.enqueue(1))
//print(queueInt)

let arr = Array(0...1000000)
let list = Queue<Int>(arr)
print(list[5489])

//var queueLinkedListInt: Queue<LinkedList<Int>> = [[1,2,3,5],[1,2,3,5,6], [1,3,4,2,3,5]]
//
//let first = queueLinkedListInt.dequeue()
//print(first)
//print(first?[0])
//print(queueLinkedListInt)

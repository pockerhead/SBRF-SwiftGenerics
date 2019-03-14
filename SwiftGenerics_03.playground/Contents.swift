import UIKit

// MARK: - Задача 3*. К выполнению необязательна. 

enum LinkedList<T> {
    indirect case node(T, next: LinkedList<T>?, previous: LinkedList<T>?)
    case empty
}

extension LinkedList {
    var count: Int {
        switch self {
        case let .node(_, next, _):
            var count = 1
            if let next = next {
                count += next.count
            }
            return count
        case .empty:
            return 0
        }
    }
    
    var isEmpty: Bool {
        return self == .empty
    }
    
    @discardableResult
    mutating func append(_ element: T) -> LinkedList<T>? {
        switch self {
        case .node(let val, var next, let previous):
            self = .node(val, next: next?.append(element) ?? .node(element, next: nil, previous: self), previous: previous)
            return self
        case .empty:
            self = .node(element, next: nil, previous: nil)
            return self
        }
    }
    
    func element(at index: Int) -> T? {
        switch self {
        case let .node (val, next, _):
            if index == 0 {
                return val
            } else {
                let nextIndex = 1
                return next?.element(at: index, nextIndex: nextIndex)
            }
        case .empty:
            return nil
        }
    }
    
    private func element(at index: Int, nextIndex: Int) -> T? {
        switch self {
        case let .node (val, next, _):
            if index == nextIndex {
                return val
            } else {
                let nextIndex = nextIndex + 1
                return next?.element(at: index, nextIndex: nextIndex)
            }
        case .empty:
            return nil
        }
    }
    
    public subscript(index: Int) -> T? {
        return element(at: index)
    }
    
}

extension LinkedList: Equatable {
    static func == (lhs: LinkedList<T>, rhs: LinkedList<T>) -> Bool {
        switch (lhs, rhs) {
        case (.node, .node):
            return true
        case (.empty, .empty):
            return true
        default:
            return false
        }
    }
}

extension LinkedList: CustomStringConvertible {
    var description: String {
        switch self {
        case let .node(val, next, previous):
            var descr: String = ""
            if previous == nil {
                descr += "["
            }
            descr += "\(val)"
            if next == nil {
                descr += "]"
            } else {
                descr += ", \(next?.description ?? "")"
            }
            return descr
        case .empty:
            return "[]"
        }
    }
}

extension LinkedList: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = T
    init(arrayLiteral elements: LinkedList.ArrayLiteralElement...) {
        guard elements.isEmpty == false else {
            self = .empty
            return
        }
        var mutableElements = elements
        self = .node(mutableElements[0], next: nil, previous: nil)
        mutableElements.remove(at: 0)
        mutableElements.forEach{self.append($0)}
    }
    
    init(_ elements: [T]) {
        guard elements.isEmpty == false else {
            self = .empty
            return
        }
        var mutableElements = elements
        self = LinkedList.node(mutableElements[0], next: nil, previous: nil)
        mutableElements.remove(at: 0)
        mutableElements.forEach{self.append($0)}
    }
}
var list: LinkedList<Int> = []
print(list.count)
list.append(4)
print(list.isEmpty)


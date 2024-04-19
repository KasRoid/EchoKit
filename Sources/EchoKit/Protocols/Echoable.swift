//
//  Echoable.swift
//
//
//  Created by Lukas on 4/19/24.
//

public protocol Echoable {}

public extension Echoable {
    
    func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        Swift.print(items, separator: separator, terminator: terminator)
    }
    
    func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        Swift.debugPrint(items, separator: separator, terminator: terminator)
    }
    
    func debugPrint<Target>(_ items: Any..., separator: String = " ", terminator: String = "\n", to output: inout Target) where Target: TextOutputStream {
        Swift.debugPrint(items, separator: separator, terminator: terminator, to: &output)
    }
    
    @discardableResult
    func dump<T>(_ value: T, name: String? = nil, indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> T {
        Swift.dump(value, name: name, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
    }
    
    @discardableResult
    func dump<T, TargetStream>(_ value: T, to target: inout TargetStream, name: String? = nil, indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> T where TargetStream: TextOutputStream {
        Swift.dump(value, to: &target, name: name, indent: indent, maxDepth: maxDepth, maxItems: maxItems)
    }
}

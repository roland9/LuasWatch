//
// Created by Roland Gropmair on 08/03/2025.
// Copyright © 2025. All rights reserved.
//

@testable import LuasAPI
import Foundation

class MockPrintable: Printable {

    // MARK: - Variables for Trackings Method Invocation

    struct Method: OptionSet, Sendable {
        let rawValue: UInt
        static let printItemsSeparatorTerminatorCalled = Method(rawValue: 1 << 0)
    }
    private(set) var calledMethods = Method()

    struct MethodParameter: OptionSet, Sendable {
        let rawValue: UInt
        static let items = MethodParameter(rawValue: 1 << 0)
        static let separator = MethodParameter(rawValue: 1 << 1)
        static let terminator = MethodParameter(rawValue: 1 << 2)
    }
    private(set) var assignedParameters = MethodParameter()

    // MARK: - Variables for Captured Parameter Values

    private(set) var items: [String] = []
    private(set) var separator: String?
    private(set) var terminator: String?

    func reset() {
        calledMethods = []
        assignedParameters = []
        items = []
        separator = nil
        terminator = nil
    }

    // MARK: - Methods for Protocol Conformance

    func print(
      _ items: String,
      separator: String,
      terminator: String
  ) {
        calledMethods.insert(.printItemsSeparatorTerminatorCalled)
    self.items.append(items)
        assignedParameters.insert(.items)
        self.separator = separator
        assignedParameters.insert(.separator)
        self.terminator = terminator
        assignedParameters.insert(.terminator)
    }

}

extension MockPrintable.Method: CustomStringConvertible {
    var description: String {
        var value = "["
        var first = true
        func handleFirst() {
            if first {
                first = false
            } else {
                value += ", "
            }
        }

        if self.contains(.printItemsSeparatorTerminatorCalled) {
            handleFirst()
            value += ".printItemsSeparatorTerminatorCalled"
        }

        value += "]"
        return value
    }
}

extension MockPrintable.MethodParameter: CustomStringConvertible {
    var description: String {
        var value = "["
        var first = true
        func handleFirst() {
            if first {
                first = false
            } else {
                value += ", "
            }
        }

        if self.contains(.items) {
            handleFirst()
            value += ".items"
        }
        if self.contains(.separator) {
            handleFirst()
            value += ".separator"
        }
        if self.contains(.terminator) {
            handleFirst()
            value += ".terminator"
        }

        value += "]"
        return value
    }
}

extension MockPrintable: CustomReflectable {
    var customMirror: Mirror {
        Mirror(self,
               children: [
                "calledMethods": calledMethods,
                "assignedParameters": assignedParameters
               ],
               displayStyle: .none
        )
    }
}

//
//  Created by Roland Gropmair on 08/03/2025.
//

import Foundation
import Testing

@testable import LuasAPI

struct LoggingTests {

  let mock = MockPrintable()

  init() {
    mock.reset()
  }

  @Test func myPrint_printsOneItem() throws {
    myPrint("first item", printFunction: mock)

    #expect(mock.calledMethods == [.printItemsSeparatorTerminatorCalled])
    #expect(mock.assignedParameters == [.items, .separator, .terminator])
    let items = mock.items

    #expect(items.count == 1)
    #expect(items.first!.hasSuffix("LoggingTests.myPrint_printsOneItem():19 first item"))
    #expect(mock.terminator == "\n")
    #expect(mock.separator == " ")
  }

  @Test func myPrint_printsTwoItems() throws {
    myPrint("first item", "second item", printFunction: mock)

    #expect(mock.calledMethods == [.printItemsSeparatorTerminatorCalled])
    #expect(mock.assignedParameters == [.items, .separator, .terminator])
    let items = mock.items

    #expect(items.count == 2)
    #expect(items[0].hasSuffix("LoggingTests.myPrint_printsTwoItems():32 first item"))
    #expect(items[1].hasSuffix("LoggingTests.myPrint_printsTwoItems():32 second item"))
    #expect(mock.terminator == "\n")
    #expect(mock.separator == " ")
  }
}

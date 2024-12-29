//
//  Created by Roland Gropmair on 28/12/2024.
//

import Testing

@testable import LuasAPI

struct TrainTests {

  let trainDue = Train(
    destination: "Broombridge",
    direction: "inbound",
    dueTime: "DUE")

  let train2Mins = Train(
    destination: "LUAS Sandyford",
    direction: "outbound",
    dueTime: "2")

  @Test func train_initialiser() throws {
    #expect(trainDue.destination == "Broombridge")
    #expect(trainDue.direction == "inbound")
    #expect(trainDue.dueTime == "DUE")

    #expect(train2Mins.destination == "LUAS Sandyford")
    #expect(train2Mins.direction == "outbound")
    #expect(train2Mins.dueTime == "2")
  }

  @Test func train_description() throws {
    #expect(trainDue.description == "Broombridge: Due")
    #expect(train2Mins.description == "Sandyford: 2 mins")
  }

  @Test func train_dueTimeDescriptionShort() throws {
    #expect(trainDue.dueTimeDescriptionShort == "Due")
    #expect(train2Mins.dueTimeDescriptionShort == "2")
  }

  @Test func train_destinationDescription() throws {
    #expect(trainDue.destinationDescription == "Broombridge")
    #expect(train2Mins.destinationDescription == "Sandyford")
  }

  @Test func train_destinationDueTimeDescription() throws {
    #expect(trainDue.destinationDueTimeDescription ==
            "Luas to Broombridge is Due")
    #expect(train2Mins.destinationDueTimeDescription ==
            "Luas to Sandyford in 2")
  }
}

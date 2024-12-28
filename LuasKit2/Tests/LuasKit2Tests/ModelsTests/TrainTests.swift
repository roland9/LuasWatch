//
//  Created by Roland Gropmair on 28/12/2024.
//

import Testing

@testable import LuasKit2

struct TrainTests {

  let trainDue = Train(
    destination: "destination",
    direction: "inbound",
    dueTime: "DUE")
  let train2Mins = Train(
    destination: "LUAS destination2",
    direction: "outbound",
    dueTime: "2")

  @Test func train_initialiser() throws {
    #expect(trainDue.destination == "destination")
    #expect(trainDue.direction == "inbound")
    #expect(trainDue.dueTime == "DUE")
    #expect(train2Mins.destination == "LUAS destination2")
    #expect(train2Mins.direction == "outbound")
    #expect(train2Mins.dueTime == "2")
  }

  @Test func train_description() throws {
    #expect(trainDue.description == "destination: 'destination: Due'")
    #expect(train2Mins.description == "destination2: 'destination2: 2 mins'")
  }

  @Test func train_dueTimeDescription() throws {
    #expect(trainDue.dueTimeDescription == "destination: Due")
    #expect(train2Mins.dueTimeDescription == "destination2: 2 mins")
  }

  @Test func train_destinationDescription() throws {
    #expect(trainDue.destinationDescription == "destination")
    #expect(train2Mins.destinationDescription == "destination2")
  }

  @Test func train_destinationDueTimeDescription() throws {
    #expect(trainDue.destinationDueTimeDescription ==
            "Luas to destination is Due")
    #expect(train2Mins.destinationDueTimeDescription ==
            "Luas to LUAS destination2 in 2")
  }}

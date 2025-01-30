//
//  Created by Roland Gropmair on 28/12/2024.
//

import Testing

@testable import LuasAPI

struct TrainsByDirectionTests {

  @Test func trainsByDirection_shortcutOutput() throws {
    let trains = TrainsByDirection(
      station: stationHarcourt,
      inbound: [
        Train(destination: "Broombridge", direction: "Inbound", dueTime: "Due"),
        Train(destination: "Broombridge", direction: "Inbound", dueTime: "12"),
      ],

      outbound: [
        Train(destination: "Bride's Glen", direction: "Outbound", dueTime: "7"),
        Train(destination: "Bride's Glen", direction: "Outbound", dueTime: "14"),
      ],
      message: "Phibsborough lift works until 28/04/23. See news."
    )

    var output = trains.shortcutOutput(direction: Direction.both)
    var expected =
    """
    Luas to Broombridge is Due.
    Luas to Broombridge in 12.
    Luas to Bride's Glen in 7.
    Luas to Bride's Glen in 14.
    
    """
    #expect(expected == output)

    output = trains.shortcutOutput(direction: Direction.inbound)
    expected =
    """
    Luas to Broombridge is Due.
    Luas to Broombridge in 12.
    
    """
    #expect(expected == output)

    output = trains.shortcutOutput(direction: Direction.outbound)
    expected =
    """
    Luas to Bride's Glen in 7.
    Luas to Bride's Glen in 14.
    
    """
    #expect(expected == output)

    let noTrainsInBothDirections = TrainsByDirection(
      station: stationHarcourt,
      inbound: [],
      outbound: [],
      message: "Phibsborough lift works until 28/04/23. See news."
    )

    output = noTrainsInBothDirections.shortcutOutput(
      direction: Direction.inbound)
    expected =
    """
    No trains found for Harcourt LUAS stop.
    
    """
    #expect(expected == output)
  }

  @Test func trainsByDirection_HasOverflow_noInbound_noOutbound_returns_InboundFalse_OutboundSmallAndLarge_false() throws {

    let trains = TrainsByDirection(
      station: stationHarcourt,
      inbound: [],
      outbound: []
    )

    #expect(trains.inboundHasOverflowSmall == false)
    #expect(trains.outboundHasOverflowSmall == false)
    #expect(trains.inboundNoOverflowSmall == [])
    #expect(trains.outboundNoOverflowSmall == [])

    #expect(trains.inboundHasOverflowLarge == false)
    #expect(trains.outboundHasOverflowLarge == false)
    #expect(trains.inboundNoOverflowLarge == [])
    #expect(trains.outboundNoOverflowLarge == [])
  }

  @Test func
  trainsByDirection_HasOverflow_threeInbound_threeOutbound_returns_InboundOutboundSmall_false_InbountLarge_false() throws {

    let train = Train(
      destination: "Broombridge",
      direction: "Inbound",
      dueTime: "Due"
    )
    let trains = TrainsByDirection(
      station: stationHarcourt,
      inbound: [train, train, train],
      outbound: [train, train, train]
    )

    #expect(trains.inboundHasOverflowSmall == false)
    #expect(trains.outboundHasOverflowSmall == false)
    #expect(trains.inboundNoOverflowSmall == [train, train, train])
    #expect(trains.outboundNoOverflowSmall == [train, train, train])

    #expect(trains.inboundHasOverflowLarge == false)
    #expect(trains.outboundHasOverflowLarge == false)
    #expect(trains.inboundNoOverflowLarge == [train, train, train])
    #expect(trains.outboundNoOverflowLarge == [train, train, train])
  }

  @Test func
  trainsByDirection_HasOverflow_fourInbound_fourOutbound_returns_InboundOutboundSmall_true_InbountOutboundLarge_false() throws  {

    let train1 = Train(destination: "Broombridge1", direction: "Inbound", dueTime: "Due")
    let train2 = Train(destination: "Broombridge2", direction: "Inbound", dueTime: "Due")
    let train3 = Train(destination: "Broombridge3", direction: "Inbound", dueTime: "Due")
    let train4 = Train(destination: "Broombridge4", direction: "Inbound", dueTime: "Due")

    let trains = TrainsByDirection(
      station: stationHarcourt,
      inbound: [train1, train2, train3, train4],
      outbound: [train1, train2, train3, train4])

    #expect(trains.inboundHasOverflowSmall == true)
    #expect(trains.outboundHasOverflowSmall == true)
    #expect(trains.inboundNoOverflowSmall == [train1, train2, train3])
    #expect(trains.outboundNoOverflowSmall == [train1, train2, train3])

    #expect(trains.inboundHasOverflowLarge == false)
    #expect(trains.outboundHasOverflowLarge == false)
    #expect(trains.inboundNoOverflowLarge == [train1, train2, train3, train4])
    #expect(trains.outboundNoOverflowLarge == [train1, train2, train3, train4])
  }

  @Test func
  trainsByDirection_HasOverflow_sevenInbound_sevenOutbound_returns_InboundOutboundSmall_true_InbountOutboundLarge_true() throws
  {

    let train1 = Train(destination: "Broombridge1", direction: "Inbound", dueTime: "Due")
    let train2 = Train(destination: "Broombridge2", direction: "Inbound", dueTime: "Due")
    let train3 = Train(destination: "Broombridge3", direction: "Inbound", dueTime: "Due")
    let train4 = Train(destination: "Broombridge4", direction: "Inbound", dueTime: "Due")
    let train5 = Train(destination: "Broombridge5", direction: "Inbound", dueTime: "Due")
    let train6 = Train(destination: "Broombridge6", direction: "Inbound", dueTime: "Due")
    let train7 = Train(destination: "Broombridge7", direction: "Inbound", dueTime: "Due")

    let trains = TrainsByDirection(
      station: stationHarcourt,
      inbound: [train1, train2, train3, train4, train5, train6, train7],
      outbound: [train1, train2, train3, train4, train5, train6, train7]
    )

    #expect(trains.inboundHasOverflowSmall == true)
    #expect(trains.outboundHasOverflowSmall == true)
    #expect(trains.inboundNoOverflowSmall == [train1, train2, train3])
    #expect(trains.outboundNoOverflowSmall == [train1, train2, train3])

    #expect(trains.inboundHasOverflowLarge == true)
    #expect(trains.outboundHasOverflowLarge == true)
    #expect(trains.inboundNoOverflowLarge == [train1, train2, train3, train4, train5, train6])
    #expect(
      trains.outboundNoOverflowLarge == [train1, train2, train3, train4, train5, train6])
  }
}

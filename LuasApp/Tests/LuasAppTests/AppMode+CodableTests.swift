//
//  Created by Roland Gropmair on 30/12/2024.
//

import Foundation
import Testing

@testable import LuasApp

struct AppModeCodableTests {

  //  @Test func appModeCodable_fromDecoder() throws {
  //    let appMode: AppMode = .closest
  //
  //    let storedAppMode = try? JSONDecoder().decode(
  //      AppMode.self, from: storedAppModeData)
  //  }

  @Test func appModeCodable_encodeDecode_closest() throws {
    let appMode: AppMode = .closest
    let encoded = try JSONEncoder().encode(appMode)
    let decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded == AppMode.closest)
  }

  @Test func appModeCodable_encodeDecode_closestOtherLine() throws {
    let appMode: AppMode = .closestOtherLine
    let encoded = try JSONEncoder().encode(appMode)
    let decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded == AppMode.closestOtherLine)
  }

  @Test func appModeCodable_encodeDecode_favourite() throws {
    let appMode: AppMode = .favourite(stationBluebell)
    let encoded = try JSONEncoder().encode(appMode)
    let decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded.description == "favourite: Bluebell")
  }

  @Test func appModeCodable_encodeDecode_favourite_notFound() throws {
    let appMode: AppMode = .favourite(stationRed)
    let encoded = try JSONEncoder().encode(appMode)
    let decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded == AppMode.closest)
  }

  @Test func appModeCodable_encodeDecode_nearby() throws {
    let appMode: AppMode = .nearby(stationHarcourt)
    let encoded = try JSONEncoder().encode(appMode)
    let decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded.description == "nearby: Harcourt")
  }

  @Test func appModeCodable_encodeDecode_nearby_notFound() throws {
    let appMode: AppMode = .nearby(stationRed)
    let encoded = try JSONEncoder().encode(appMode)
    let decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded == AppMode.closest)
  }

  @Test func appModeCodable_encodeDecode_specific() throws {
    let appMode: AppMode = .specific(stationBluebell)
    let encoded = try JSONEncoder().encode(appMode)
    let decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded.description == "specific: Bluebell")
  }

  @Test func appModeCodable_encodeDecode_specific_notFound() throws {
    let appMode: AppMode = .specific(stationRed)
    let encoded = try JSONEncoder().encode(appMode)
    let decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded == AppMode.closest)
  }

  @Test func appModeCodable_encodeDecode_recents() throws {
    let appMode: AppMode = .recents(stationHarcourt)
    let encoded = try JSONEncoder().encode(appMode)
    let decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded.description == "recents: Harcourt")
  }

  @Test func appModeCodable_encodeDecode_recents_notFound() throws {
    let appMode: AppMode = .recents(stationRed)
    let encoded = try JSONEncoder().encode(appMode)
    let decoded = try JSONDecoder().decode(AppMode.self, from: encoded)
    #expect(decoded == AppMode.closest)
  }

}

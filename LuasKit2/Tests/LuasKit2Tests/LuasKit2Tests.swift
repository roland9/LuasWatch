import CoreLocation
import Foundation
import Testing

@testable import LuasKit2

@Test func buildsAPIRequest() async throws {
  let api = LuasAPI()
  let request = api.buildRequest()

  //  #expect(request.method == .get)
}

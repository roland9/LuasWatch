//
//  Created by Roland Gropmair on 19/08/2019.
//  Copyright © 2019 mApps.ie. All rights reserved.
//

import Foundation

// credit to BenS https://github.com/nsscreencast/425-parsing-xml-in-swift/blob/master/SwiftParsingXML/SwiftParsingXML/main.swift

protocol ParserDelegate: XMLParserDelegate {
  var delegateStack: ParserDelegateStack? { get set }
  func didBecomeActive()
}

extension ParserDelegate {
  func didBecomeActive() {}
}

protocol NodeParser: ParserDelegate {
  associatedtype Item
  var result: Item? { get }
}

class ParserDelegateStack {
  private var parsers: [ParserDelegate] = []
  private let xmlParser: XMLParser

  init(xmlParser: XMLParser) {
    self.xmlParser = xmlParser
  }

  func push(_ parser: ParserDelegate) {
    parser.delegateStack = self
    xmlParser.delegate = parser
    parsers.append(parser)
  }

  func pop() {
    parsers.removeLast()
    if let next = parsers.last {
      xmlParser.delegate = next
      next.didBecomeActive()
    } else {
      xmlParser.delegate = nil
    }
  }
}

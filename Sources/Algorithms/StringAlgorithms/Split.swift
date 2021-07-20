//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Algorithms open source project
//
// Copyright (c) 2021 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

extension Collection {
  @inlinable
  public func split<Separator: Collection>(
    separator: Separator,
    maxSplits: Int = Int.max,
    omittingEmptySubsequences: Bool = true,
    by areEquivalent: (Element, Separator.Element) throws -> Bool
  ) rethrows -> [SubSequence] {
    precondition(maxSplits >= 0, "Must take zero or more splits")
    precondition(!separator.isEmpty)
    
    var index = startIndex
    var result: [SubSequence] = []
    
    func append(upTo end: Index) {
      if !omittingEmptySubsequences || index != end {
        result.append(self[index..<end])
      }
    }
    
    while result.count != maxSplits, let range = try self[index...]
            .firstRange(of: separator, by: areEquivalent)
    {
      append(upTo: range.lowerBound)
      index = range.upperBound
    }
    
    append(upTo: endIndex)
    return result
  }
}

extension Collection where Element: Equatable {
  @inlinable
  @_disfavoredOverload // To make sure the element separator version is
                       // preferred when a string literal is used
  public func split<Separator: Collection>(
    separator: Separator,
    maxSplits: Int = Int.max,
    omittingEmptySubsequences: Bool = true
  ) -> [SubSequence] where Separator.Element == Element {
    split(
      separator: separator,
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      by: ==)
  }
}

// TODO: a lazy variant

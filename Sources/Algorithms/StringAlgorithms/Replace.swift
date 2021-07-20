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

//===----------------------------------------------------------------------===//
// replacingOccurrences(of:with:)
//===----------------------------------------------------------------------===//

extension RangeReplaceableCollection {
  @inlinable
  public func replacingOccurrences<Target: Collection, Replacement: Collection>(
    of target: Target,
    with replacement: Replacement,
    subrange: Range<Index>,
    by areEquivalent: (Element, Target.Element) throws -> Bool
  ) rethrows -> Self where Replacement.Element == Element {
    precondition(!target.isEmpty)
    
    var index = subrange.lowerBound
    var result = Self()
    result.append(contentsOf: self[..<index])
    
    while let range = try self[index..<subrange.upperBound]
            .firstRange(of: target, by: areEquivalent)
    {
      result.append(contentsOf: self[index..<range.lowerBound])
      result.append(contentsOf: replacement)
      index = range.upperBound
    }
    
    result.append(contentsOf: self[index...])
    return result
  }
  
  @inlinable
  public func replacingOccurrences<Target: Collection, Replacement: Collection>(
    of target: Target,
    with replacement: Replacement,
    by areEquivalent: (Element, Target.Element) throws -> Bool
  ) rethrows -> Self where Replacement.Element == Element {
    try replacingOccurrences(
      of: target,
      with: replacement,
      subrange: startIndex..<endIndex,
      by: areEquivalent)
  }
}

extension RangeReplaceableCollection where Element: Equatable {
  @inlinable
  public func replacingOccurrences<Target: Collection, Replacement: Collection>(
    of target: Target,
    with replacement: Replacement,
    subrange: Range<Index>
  ) -> Self where Target.Element == Element, Replacement.Element == Element {
    replacingOccurrences(
      of: target,
      with: replacement,
      subrange: subrange,
      by: ==)
  }
  
  @inlinable
  public func replacingOccurrences<Target: Collection, Replacement: Collection>(
    of target: Target,
    with replacement: Replacement
  ) -> Self where Target.Element == Element, Replacement.Element == Element {
    replacingOccurrences(
      of: target,
      with: replacement,
      subrange: startIndex..<endIndex)
  }
}

//===----------------------------------------------------------------------===//
// replaceOccurrences(of:with:)
//===----------------------------------------------------------------------===//

extension RangeReplaceableCollection {
  @inlinable
  public mutating func replaceOccurrences<
    Target: Collection,
    Replacement: Collection
  >(
    of target: Target,
    with replacement: Replacement,
    by areEquivalent: (Element, Target.Element) throws -> Bool
  ) rethrows where Replacement.Element == Element {
    self = try replacingOccurrences(
      of: target,
      with: replacement,
      by: areEquivalent)
  }
}

extension RangeReplaceableCollection where Element: Equatable {
  @inlinable
  public mutating func replaceOccurrences<
    Target: Collection,
    Replacement: Collection
  >(
    of target: Target,
    with replacement: Replacement
  ) where Target.Element == Element, Replacement.Element == Element {
    replaceOccurrences(of: target, with: replacement, by: ==)
  }
}

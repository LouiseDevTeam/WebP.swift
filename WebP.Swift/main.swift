//
//  main.swift
//  WebP.Swift
//
//  Created by Louis Shen on 2021/1/11.
//

import Foundation

func makeCString(_ str: String) -> UnsafeMutablePointer<Int8> {
    let count = str.utf8.count + 1
    let result = UnsafeMutablePointer<Int8>.allocate(capacity: count)
    str.withCString { (baseAddress) in
        result.initialize(from: baseAddress, count: count)
    }
    return result
}

cwebp(5,
      makeCString("-lossless"),
      makeCString("/Users/louisshen/Desktop/bp.png"),
      makeCString("-o"),
      makeCString("/Users/louisshen/Desktop/bp.webp"),
      makeCString("-v"),
      makeCString(""),
      makeCString(""))

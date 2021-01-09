//
//  Utils.swift
//  WebP.swift
//
//  Created by Louis Shen on 2021/1/9.
//

import Foundation

struct Utils {
    public static func HelpShort() {
      print("Usage:");
      print("   cwebp [options] -q quality input.png -o output.webp");
      print("where quality is between 0 (poor) to 100 (very good).");
      print("Typical value is around 80.");
      print("Try -longhelp for an exhaustive list of advanced options.");
    }
}

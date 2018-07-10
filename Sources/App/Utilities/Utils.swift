//
//  Utils.swift
//  App
//
//  Created by jj on 02/07/2018.
//

import Foundation
import Debugging

//public func jjecho(_ items: Any..., file: String = #file, line: Int = #line) {
//
//    print("\(file):\(line)")
//    print(items)
//
//}


extension SourceLocation: CustomStringConvertible {
    public var description: String {
        let fileName = URL(string: file)?.lastPathComponent ?? ""
        return "\(fileName):\(line)"
    }
}

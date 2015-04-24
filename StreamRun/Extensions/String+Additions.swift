//
//  String+Additions.swift
//  StreamRun
//
//  Created by Nikita Nagaynik on 12/02/15.
//  Copyright (c) 2015 rrunfa. All rights reserved.
//

import Foundation

extension String {
    func stringByAddQueryParams(params: Dictionary<String, String>) -> String {
        if params.count == 0 {
            return self
        }
        var result = self + "?"
        for (index, elem) in enumerate(params) {
            result = result.stringByAppendingFormat("\(elem.0)=\(elem.1)")
            if (index + 1 != params.count) {
                result += "&"
            }
        }
        return result
    }
}
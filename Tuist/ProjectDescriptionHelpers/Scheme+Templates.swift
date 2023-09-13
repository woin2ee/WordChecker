//
//  Scheme+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Jaewon Yun on 2023/05/22.
//

import ProjectDescription

extension Scheme {
    
    public static func hideScheme(name: String) -> Scheme {
        return .init(name: name, hidden: true)
    }
    
}

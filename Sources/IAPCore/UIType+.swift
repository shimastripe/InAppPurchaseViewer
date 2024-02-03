//
//  UIType+.swift
//
//
//  Created by shimastripe on 2024/02/06.
//

import UniformTypeIdentifiers

extension UTType {
    public static var privateKey: UTType {
        .init(exportedAs: "p8")
    }
}

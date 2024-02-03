//
//  CellText.swift
//
//
//  Created by shimastripe on 2024/02/19.
//

import SwiftUI

struct CellText: View {

    let value: String

    init(_ value: String?, defaultValue: String = "") {
        self.value = value ?? defaultValue
    }

    var body: some View {
        Text(value)
    }
}

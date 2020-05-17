//
//  Playground.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-09.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import Foundation

let inputSignal: Signal = EcgSignal()

public func getInputSignalValue(at time: TimeInterval) -> OpaqueSignalValue {
	inputSignal.value(at: time)
}

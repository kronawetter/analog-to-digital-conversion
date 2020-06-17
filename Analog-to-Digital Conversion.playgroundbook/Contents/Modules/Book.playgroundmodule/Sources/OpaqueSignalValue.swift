//
//  OpaqueSignalValue.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-08.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

public struct OpaqueSignalValue {
	let comparisonFunction: (Double) -> Bool
	
	public static func < (left: OpaqueSignalValue, right: Double) -> Bool {
		left.comparisonFunction(right)
	}
}

//
//  R2RResistorLadder.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-07.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import Darwin

public struct R2RResistorLadder {
	let numberOfBits: Int
	let referenceVoltage: Double

	private var factor: UInt64 = 0

	public init(numberOfBits: Int, referenceVoltage: Double) {
		precondition((1...UInt64.bitWidth).contains(numberOfBits))
		
		self.numberOfBits = numberOfBits
		self.referenceVoltage = referenceVoltage
	}

	public var outputVoltage: Double {
		return referenceVoltage * Double(factor) / (pow(2.0, Double(numberOfBits)) - 1)
	}

	public mutating func setBit(at index: Int) {
		precondition((0..<numberOfBits).contains(index))

		factor |= 1 << index
	}

	public mutating func clearBit(at index: Int) {
		precondition((0..<numberOfBits).contains(index))
		factor &= ~(1 << index)
	}

	public mutating func clearAllBits() {
		factor = 0
	}
}

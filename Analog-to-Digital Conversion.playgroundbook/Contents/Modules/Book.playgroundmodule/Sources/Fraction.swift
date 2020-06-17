//
//  Fraction.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-14.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

public struct Fraction {
	public var nominator: Int
	public var denominator: Int

	public init(nominator: Int, denominator: Int) {
		self.nominator = nominator
		self.denominator = denominator
	}

	public var value: Double {
		Double(nominator) / Double(denominator)
	}
}

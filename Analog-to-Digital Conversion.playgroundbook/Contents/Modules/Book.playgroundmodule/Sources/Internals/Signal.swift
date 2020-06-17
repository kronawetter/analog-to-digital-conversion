//
//  Signal.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-05.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import UIKit

protocol Signal {
	var timeRange: ClosedRange<TimeInterval> { get }
	var valueRange: ClosedRange<Double> { get }

	func value(at time: TimeInterval) -> OpaqueSignalValue
	func path(for size: CGSize) -> UIBezierPath
	func x(for time: TimeInterval, width: CGFloat) -> CGFloat
	func y(for value: Double, height: CGFloat) -> CGFloat
}

extension Signal {
	func x(for time: TimeInterval, width: CGFloat) -> CGFloat {
		CGFloat((time - timeRange.lowerBound) / (timeRange.upperBound - timeRange.lowerBound)) * width
	}

	func y(for value: Double, height: CGFloat) -> CGFloat {
		CGFloat((value - valueRange.lowerBound) / (valueRange.upperBound - valueRange.lowerBound)) *  height
	}
}

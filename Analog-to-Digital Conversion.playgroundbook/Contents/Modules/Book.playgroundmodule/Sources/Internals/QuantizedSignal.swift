//
//  QuantizedSignal.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-15.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import UIKit

struct QuantizedSignal: Signal {
	var samples: [(time: TimeInterval, value: Double)] = [(time: 0.0, value: 0.0)]

	var timeRange: ClosedRange<TimeInterval> {
		return 0.0...7.0
	}

	var valueRange: ClosedRange<Double> {
		return 0.0...10.0
	}

	func value(at time: TimeInterval) -> OpaqueSignalValue {
		fatalError("Not implemented")
	}

	func path(for size: CGSize) -> UIBezierPath {
		let path = UIBezierPath()

		guard !samples.isEmpty else {
			return path
		}

		let firstPoint = samples.first!
		path.move(to: CGPoint(x: x(for: firstPoint.time, width: size.width), y: y(for: firstPoint.value, height: size.height)))

		for (time, value) in samples.dropFirst() {
			path.addLine(to: CGPoint(x: x(for: time, width: size.width), y: y(for: value, height: size.height)))
		}

		return path
	}
}

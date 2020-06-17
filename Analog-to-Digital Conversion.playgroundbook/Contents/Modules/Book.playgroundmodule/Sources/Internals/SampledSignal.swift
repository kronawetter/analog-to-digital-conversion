//
//  SampledSignal.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-08.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import UIKit

struct SampledSignal: Signal {
	var samples: [(time: TimeInterval, value: Double)] = []

	var timeRange: ClosedRange<TimeInterval> {
		0.0...0.7
	}

	var valueRange: ClosedRange<Double> {
		0.0...0.02
	}

	func value(at time: TimeInterval) -> OpaqueSignalValue {
		fatalError("Not implemented")
	}

	func path(for size: CGSize) -> UIBezierPath {
		let combinedPath = CGMutablePath()
		for sample in samples {
			let point = CGPoint(x: x(for: sample.time, width: size.width), y: y(for: sample.value, height: size.height))
			let path = UIBezierPath(arcCenter: point, radius: 4.0, startAngle: 0.0, endAngle: 2.0 * .pi, clockwise: true)
			combinedPath.addPath(path.cgPath)
		}
		return UIBezierPath(cgPath: combinedPath)
	}
}

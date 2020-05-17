//
//  EcgSignal.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-08.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import UIKit

struct EcgSignal: Signal {
	init() {
		
	}

	var timeRange: ClosedRange<TimeInterval> {
		0.0...0.7
	}

	var valueRange: ClosedRange<Double> {
		0.0...0.02
	}

	func value(at time: TimeInterval) -> OpaqueSignalValue {
		OpaqueSignalValue { value in
			let size = CGSize(width: 500.0, height: 500.0)
			let path = self.path(for: size, closed: true)
			let point = CGPoint(x: self.x(for: time, width: size.width), y: self.y(for: value, height: size.height))

			return !path.contains(point)
		}
	}

	func path(for size: CGSize) -> UIBezierPath {
		self.path(for: size, closed: false)
	}

	private func path(for size: CGSize, closed: Bool) -> UIBezierPath {
		let path = UIBezierPath()

		if closed {
			path.move(to: CGPoint(x: 0.0, y: 0.0))
			path.addLine(to: CGPoint(x: 0.0, y: 3.0))
		} else {
			path.move(to: CGPoint(x: 0.0, y: 3.0))
		}

		path.addCurve(to: CGPoint(x: 2.16, y: 2.55), controlPoint1: CGPoint(x: 1.1, y: 2.62), controlPoint2: CGPoint(x: 1.82, y: 2.58))
		path.addCurve(to: CGPoint(x: 16.33, y: 5.28), controlPoint1: CGPoint(x: 8.95, y: 1.97), controlPoint2: CGPoint(x: 13.64, y: 5.28))
		path.addCurve(to: CGPoint(x: 22.72, y: 1.79), controlPoint1: CGPoint(x: 19.02, y: 5.28), controlPoint2: CGPoint(x: 20.81, y: 1.1))
		path.addCurve(to: CGPoint(x: 27.17, y: 1.92), controlPoint1: CGPoint(x: 24.63, y: 2.48), controlPoint2: CGPoint(x: 25.02, y: 2.83))
		path.addCurve(to: CGPoint(x: 31.24, y: 2.54), controlPoint1: CGPoint(x: 29.31, y: 1.01), controlPoint2: CGPoint(x: 28.5, y: 4.7))
		path.addCurve(to: CGPoint(x: 35.78, y: 55), controlPoint1: CGPoint(x: 33.98, y: 0.39), controlPoint2: CGPoint(x: 34.2, y: 55))
		path.addCurve(to: CGPoint(x: 39.55, y: 1.79), controlPoint1: CGPoint(x: 37.35, y: 55), controlPoint2: CGPoint(x: 37.99, y: 2.78))
		path.addCurve(to: CGPoint(x: 42.44, y: 8.33), controlPoint1: CGPoint(x: 41.11, y: 0.8), controlPoint2: CGPoint(x: 41.14, y: 9.86))
		path.addCurve(to: CGPoint(x: 46.06, y: 5.28), controlPoint1: CGPoint(x: 43.75, y: 6.8), controlPoint2: CGPoint(x: 43.72, y: 2.78))
		path.addCurve(to: CGPoint(x: 51.89, y: 6.64), controlPoint1: CGPoint(x: 48.4, y: 7.78), controlPoint2: CGPoint(x: 48.56, y: 5.05))
		path.addCurve(to: CGPoint(x: 66.34, y: 23.36), controlPoint1: CGPoint(x: 55.22, y: 8.24), controlPoint2: CGPoint(x: 60.95, y: 16.28))
		path.addCurve(to: CGPoint(x: 78.56, y: 7.71), controlPoint1: CGPoint(x: 71.72, y: 30.44), controlPoint2: CGPoint(x: 74.85, y: 15.41))
		path.addCurve(to: CGPoint(x: 92.73, y: 3.09), controlPoint1: CGPoint(x: 82.28, y: 0.01), controlPoint2: CGPoint(x: 87.42, y: 1.74))
		path.addCurve(to: CGPoint(x: 100, y: 3), controlPoint1: CGPoint(x: 94.63, y: 3.58), controlPoint2: CGPoint(x: 97.06, y: 3.55))

		if closed {
			path.addLine(to: CGPoint(x: 100.0, y: 0.0))
			path.close()
		}

		path.apply(CGAffineTransform(scaleX: size.width / 100.0, y: size.height / 55.0))

		return path
	}
}

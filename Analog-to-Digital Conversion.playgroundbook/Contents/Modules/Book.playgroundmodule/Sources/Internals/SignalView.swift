//
//  SignalView.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-05.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import UIKit

class SignalView: UIView {
	func transformForDisplay(path: UIBezierPath) -> UIBezierPath {
		path.apply(CGAffineTransform(translationX: bounds.minX, y: bounds.maxY).scaledBy(x: 1.0, y: -1.0))
		return path
	}

	private(set) var continuousSignal: Signal

	var sampledSignal: Signal {
		didSet {
			sampledSignalLayer.path = transformForDisplay(path: sampledSignal.path(for: plotRect(for: sampledSignal).size)).cgPath
		}
	}

	var axisTimeRange: ClosedRange<Double> {
		didSet {
			assert(axisTimeRange.lowerBound == 0.0)
			setNeedsLayout()
		}
	}

	var axisValueRange: ClosedRange<Double> {
		didSet {
			assert(axisValueRange.lowerBound == 0.0)
			setNeedsLayout()
		}
	}

	private let continuousSignalLayer = CAShapeLayer()
	private let sampledSignalLayer = CAShapeLayer()
	private let approximationLayer = CAShapeLayer()
	private let axisLayer = CAShapeLayer()
	private var xAxisLabels: [UILabel] = []
	private var yAxisLabels: [UILabel] = []

	private let axisLabelFormatter: MeasurementFormatter = {
		let formatter = MeasurementFormatter()
		formatter.unitStyle = .short
		return formatter
	}()

	func plotRect(for signal: Signal) -> CGRect {
		assert(axisTimeRange.lowerBound == 0.0)
		assert(axisValueRange.lowerBound == 0.0)
		assert(signal.timeRange.lowerBound == 0.0)
		assert(signal.valueRange.lowerBound == 0.0)

		let scaleX = CGFloat(signal.timeRange.upperBound / axisTimeRange.upperBound)
		let scaleY = CGFloat(signal.valueRange.upperBound / axisValueRange.upperBound)

		return bounds.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
	}

	var xAxisTicks: [CGFloat] {
		let tickInterval: CGFloat = 400.0 / 7.0

		guard bounds.width >= tickInterval else {
			return []
		}

		return (1...Int(bounds.width / tickInterval)).map { CGFloat($0) * tickInterval }
	}

	var yAxisTicks: [CGFloat] {
		let tickInterval: CGFloat = 50.0

		guard bounds.height >= tickInterval else {
			return []
		}

		return (1...Int(bounds.height / tickInterval)).map { CGFloat($0) * tickInterval }
	}

	var axisPath: UIBezierPath {
		let path = UIBezierPath()

		path.move(to: CGPoint(x: 0.0, y: 0.0))
		path.addLine(to: CGPoint(x: bounds.width, y: 0.0))

		for tick in xAxisTicks {
			path.move(to: CGPoint(x: tick, y: 0.0))
			path.addLine(to: CGPoint(x: tick, y: -10.0))
		}

		path.move(to: CGPoint(x: 0.0, y: 0.0))
		path.addLine(to: CGPoint(x: 0.0, y: bounds.height))

		for tick in yAxisTicks {
			path.move(to: CGPoint(x: 0.0, y: tick))
			path.addLine(to: CGPoint(x: -10.0, y: tick))
		}

		return path
	}

	private func updateAxisLabels() {
		xAxisLabels.forEach { $0.removeFromSuperview() }
		xAxisLabels = xAxisTicks.map { x in
			let relativeX = x / bounds.width
			let time = Double(relativeX) * (axisTimeRange.upperBound - axisTimeRange.lowerBound) + axisTimeRange.lowerBound

			let label = UILabel(frame: CGRect(x: x - 25.0, y: bounds.height + 10.0, width: 50.0, height: 20.0))
			label.text = axisLabelFormatter.string(for: Measurement(value: time, unit: UnitDuration.seconds))
			label.textAlignment = .center
			label.textColor = .label
			label.font = .systemFont(ofSize: 13.0)
			return label
		}
		xAxisLabels.forEach { addSubview($0) }

		yAxisLabels.forEach { $0.removeFromSuperview() }
		yAxisLabels = yAxisTicks.map { y in
			let relativeY = y / bounds.height
			let value = Double(relativeY) * (axisValueRange.upperBound - axisValueRange.lowerBound) + axisValueRange.lowerBound

			let label = UILabel(frame: CGRect(x: -65.0, y: bounds.height - y - 10.0, width: 50.0, height: 20.0))
			label.text = axisLabelFormatter.string(for: Measurement(value: value, unit: UnitElectricPotentialDifference.volts))
			label.textAlignment = .right
			label.textColor = .label
			label.font = .systemFont(ofSize: 13.0)
			return label
		}
		yAxisLabels.forEach { addSubview($0) }
	}

	override func layoutSublayers(of layer: CALayer) {
		if layer == self.layer {
			continuousSignalLayer.path = transformForDisplay(path: continuousSignal.path(for: plotRect(for: continuousSignal).size)).cgPath
			sampledSignalLayer.path = transformForDisplay(path: sampledSignal.path(for: plotRect(for: sampledSignal).size)).cgPath
			axisLayer.path = transformForDisplay(path: axisPath).cgPath

			updateAxisLabels()
		}
	}

	init(frame: CGRect, continuousSignal: Signal, sampledSignal: Signal) {
		self.continuousSignal = continuousSignal
		self.sampledSignal = sampledSignal

		axisTimeRange = continuousSignal.timeRange
		axisValueRange = continuousSignal.valueRange

		super.init(frame: frame)

		approximationLayer.fillColor = UIColor.systemGray.cgColor

		sampledSignalLayer.fillColor = UIColor.label.cgColor

		continuousSignalLayer.strokeColor = UIColor.systemRed.cgColor
		continuousSignalLayer.lineWidth = 2.0
		continuousSignalLayer.fillColor = .none

		axisLayer.strokeColor = UIColor.label.cgColor
		axisLayer.lineWidth = 1.0
		axisLayer.fillColor = .none

		layer.addSublayer(axisLayer)
		layer.addSublayer(continuousSignalLayer)
		layer.addSublayer(approximationLayer)
		layer.addSublayer(sampledSignalLayer)

		updateAxisLabels()
	}

	public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)

		approximationLayer.fillColor = UIColor.systemGray.cgColor
		continuousSignalLayer.strokeColor = UIColor.systemRed.cgColor
		sampledSignalLayer.fillColor = UIColor.label.cgColor
		axisLayer.strokeColor = UIColor.label.cgColor
	}

	func showApproximation(for value: Double, at time: TimeInterval, animated: Bool) {
		approximationLayer.removeAllAnimations()

		let x = continuousSignal.x(for: time, width: plotRect(for: continuousSignal).width)
		let y = continuousSignal.y(for: value, height: plotRect(for: continuousSignal).height)
		let rect = CGRect(x: x - 2.5, y: 0.0, width: 5.0, height: y)
		let path = UIBezierPath(rect: rect)

		let oldPath = approximationLayer.path
		approximationLayer.path = transformForDisplay(path: path).cgPath

		if animated {
			let animation = CABasicAnimation(keyPath: "path")
			animation.duration = 0.1
			animation.fromValue = oldPath
			animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

			approximationLayer.add(animation, forKey: animation.keyPath)
		}
	}

	func setContinuousSignal(_ continuousSignal: Signal, animated: Bool) {
		self.continuousSignal = continuousSignal
		
		continuousSignalLayer.removeAllAnimations()

		let oldPath = continuousSignalLayer.path
		continuousSignalLayer.path = transformForDisplay(path: continuousSignal.path(for: plotRect(for: continuousSignal).size)).cgPath

		if animated {
			let animation = CABasicAnimation(keyPath: "path")
			animation.duration = 0.1
			animation.fromValue = oldPath
			animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

			continuousSignalLayer.add(animation, forKey: animation.keyPath)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

//
//  AnalogDigitalConversionViewController.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-05.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import UIKit
import PlaygroundSupport

public class AnalogDigitalConversionViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
	private let scrollView = UIScrollView()
	private let containerView = UIView()
	private let layoutGuide = UILayoutGuide()
	private let circuitView = SarCircuitView(dacResolution: 8)
	private let signalView = SignalView(frame: .zero, continuousSignal: EcgSignal(), sampledSignal: SampledSignal())

	private let voltageLabelContainer = UIView()
	private let voltageLabel = UILabel()
	private let voltageFormatter: MeasurementFormatter = {
		let formatter = MeasurementFormatter()
		formatter.numberFormatter.minimumFractionDigits = 5
		formatter.numberFormatter.maximumFractionDigits = 5
		return formatter
	}()

	public override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground

		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.contentInset = UIEdgeInsets(top: 60.0, left: 60.0, bottom: 60.0, right: 60.0)
		view.addSubview(scrollView)
		NSLayoutConstraint.activate([
			scrollView.leadingAnchor.constraint(equalTo: liveViewSafeAreaGuide.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor),
			scrollView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor)
		])

		containerView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(containerView)
		NSLayoutConstraint.activate([
			containerView.widthAnchor.constraint(greaterThanOrEqualTo: liveViewSafeAreaGuide.widthAnchor, constant: -(scrollView.contentInset.left + scrollView.contentInset.right)),
			containerView.heightAnchor.constraint(greaterThanOrEqualTo: liveViewSafeAreaGuide.heightAnchor, constant: -(scrollView.contentInset.top + scrollView.contentInset.bottom)),
			containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
		])

		containerView.addLayoutGuide(layoutGuide)
		NSLayoutConstraint.activate([
			layoutGuide.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
			containerView.widthAnchor.constraint(greaterThanOrEqualTo: layoutGuide.widthAnchor),
			layoutGuide.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
			containerView.heightAnchor.constraint(greaterThanOrEqualTo: layoutGuide.heightAnchor)
		])

		circuitView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(circuitView)
		NSLayoutConstraint.activate([
			circuitView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
			layoutGuide.widthAnchor.constraint(greaterThanOrEqualTo: circuitView.widthAnchor),
			circuitView.topAnchor.constraint(equalTo: layoutGuide.topAnchor)
		])

		voltageLabelContainer.translatesAutoresizingMaskIntoConstraints = false
		voltageLabelContainer.layer.cornerRadius = 20.0
		voltageLabelContainer.layer.cornerCurve = .continuous
		voltageLabelContainer.backgroundColor = .secondarySystemBackground
		voltageLabel.translatesAutoresizingMaskIntoConstraints = false
		voltageLabel.text = "Current D/A Converter Output Voltage:\n\(voltageFormatter.string(from: Measurement(value: 0.0, unit: UnitElectricPotentialDifference.volts)))"
		voltageLabel.textAlignment = .center
		voltageLabel.textColor = .secondaryLabel
		voltageLabel.numberOfLines = 0
		voltageLabelContainer.addSubview(voltageLabel)
		view.addSubview(voltageLabelContainer)
		NSLayoutConstraint.activate([
			voltageLabelContainer.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
			layoutGuide.widthAnchor.constraint(greaterThanOrEqualTo: voltageLabelContainer.widthAnchor),
			voltageLabelContainer.topAnchor.constraint(equalTo: circuitView.bottomAnchor, constant: 37.0),
			voltageLabelContainer.widthAnchor.constraint(equalTo: voltageLabel.widthAnchor, constant: 44.0),
			voltageLabelContainer.heightAnchor.constraint(equalTo: voltageLabel.heightAnchor, constant: 30.0),
			voltageLabel.centerXAnchor.constraint(equalTo: voltageLabelContainer.centerXAnchor),
			voltageLabel.centerYAnchor.constraint(equalTo: voltageLabelContainer.centerYAnchor)
		])

		signalView.translatesAutoresizingMaskIntoConstraints = false
		signalView.backgroundColor = .secondarySystemBackground
		scrollView.addSubview(signalView)
		NSLayoutConstraint.activate([
			signalView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
			layoutGuide.widthAnchor.constraint(greaterThanOrEqualTo: signalView.widthAnchor),
			signalView.topAnchor.constraint(equalTo: voltageLabelContainer.bottomAnchor, constant: 44.0),
			signalView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
			signalView.widthAnchor.constraint(equalToConstant: 400.0),
			signalView.heightAnchor.constraint(equalToConstant: 200.0)
		])
	}
}

extension AnalogDigitalConversionViewController: PlaygroundLiveViewMessageHandler {
	public func receive(_ message: PlaygroundValue) {
		let animated = PlaygroundPage.current.executionMode != .runFastest

		guard case .dictionary(let dict) = message else {
			preconditionFailure()
		}

		if let value = dict["SetDacResolution"] {
			guard case .integer(let resolution) = value else {
				preconditionFailure()
			}

			circuitView.dacResolution = resolution
		}

		if let value = dict["SetMaximumVoltage"] {
			guard case .floatingPoint(let maximumVoltage) = value else {
				preconditionFailure()
			}

			signalView.axisValueRange = 0...max(maximumVoltage, signalView.continuousSignal.valueRange.upperBound)
		}

		if let value = dict["SetBit"] {
			guard case .integer(let index) = value else {
				preconditionFailure()
			}

			circuitView.setValueOfDacInputLine(at: index, value: true)
		}

		if let value = dict["ClearBit"] {
			guard case .integer(let index) = value else {
				preconditionFailure()
			}

			circuitView.setValueOfDacInputLine(at: index, value: false)
		}

		if let _ = dict["ClearAllBits"] {
			(0..<circuitView.dacResolution).forEach { circuitView.setValueOfDacInputLine(at: $0, value: false) }
		}

		if let value = dict["ShowOutputVoltage"] {
			guard case .dictionary(let dict) = value else {
				preconditionFailure()
			}
			guard let timeValue = dict["Time"], case .floatingPoint(let time) = timeValue else {
				preconditionFailure()
			}
			guard let voltageValue = dict["Voltage"], case .floatingPoint(let voltage) = voltageValue else {
				preconditionFailure()
			}

			voltageLabel.text = "Current D/A Converter Output Voltage:\n\(voltageFormatter.string(from: Measurement(value: voltage, unit: UnitElectricPotentialDifference.volts)))"

			if animated || voltage == 0.0 {
				signalView.showApproximation(for: voltage, at: time, animated: animated)
			}
		}

		if let value = dict["SaveSample"] {
			guard case .dictionary(let dict) = value else {
				preconditionFailure()
			}
			guard let timeValue = dict["Time"], case .floatingPoint(let time) = timeValue else {
				preconditionFailure()
			}
			guard let voltageValue = dict["Voltage"], case .floatingPoint(let voltage) = voltageValue else {
				preconditionFailure()
			}

			var sampledSignal = signalView.sampledSignal as! SampledSignal
			sampledSignal.samples.append((time: time, value: voltage))
			signalView.sampledSignal = sampledSignal

			if case .pass = PlaygroundPage.current.assessmentStatus {
				
			} else {
				if voltage > 0.012 && (0.2..<0.3).contains(time) {
					PlaygroundPage.current.assessmentStatus = .pass(message: "# Good Job!\nThe voltage peak at approximately 0.25 seconds is visible in the captured digital signal. You have completed this Playground Book.")
				}
			}
		}

		if let _ = dict["ClearSamples"] {
			signalView.sampledSignal = SampledSignal()

			PlaygroundPage.current.assessmentStatus = nil
		}

		if let _ = dict["CheckForAssessmentFailure"] {
			if case .pass = PlaygroundPage.current.assessmentStatus {

			} else {
				PlaygroundPage.current.assessmentStatus = .fail(hints: ["Make sure that the time between conversions is smaller than the duration of the voltage peak at approximately 0.25 seconds.", "Ensure that you use a number of bits that allows you to differentiate between the main voltage peak at approximately 0.25 seconds and the smaller voltage peak at approximately 0.48 seconds.", "Check whether the maximum voltage is appropriately set. It is a good idea to set the maximum voltage to the maximum voltage of the input signal."], solution: "````\nsetNumberOfBits(8)\nsetMaximumVoltage(0.02)\nsetTimeBetweenConversions(0.02)\n````")
			}
		}
	}
}

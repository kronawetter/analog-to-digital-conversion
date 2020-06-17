//
//  FixedPointArithmeticViewController.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-14.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import UIKit
import PlaygroundSupport

public class FixedPointArithmeticViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
	private let scrollView = UIScrollView()
	private let containerView = UIView()
	private let layoutGuide = UILayoutGuide()
	private let binaryView = BinaryRepresentationView(numberOfBits: 8)
	private let arrowsImageView = UIImageView(image: UIImage(named: "Arrows")!.withTintColor(.label))
	private let integerLabel = UILabel()
	private let fixedPointLabel = UILabel()

	private let font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
	private let largeFont = UIFont.systemFont(ofSize: 28.0, weight: .medium)
	private let largeFractionFont: UIFont = {
		let font = UIFont.systemFont(ofSize: 28.0, weight: .medium)
		let fontDescriptor = font.fontDescriptor.addingAttributes([
			.featureSettings: [
				[
					UIFontDescriptor.FeatureKey.featureIdentifier: kFractionsType,
					UIFontDescriptor.FeatureKey.typeIdentifier: kDiagonalFractionsSelector
				]
			]
		])
		return UIFont(descriptor: fontDescriptor, size: font.pointSize)
	}()

	public override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground

		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.contentInset = UIEdgeInsets(top: 40.0, left: 60.0, bottom: 40.0, right: 60.0)
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

		binaryView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(binaryView)
		NSLayoutConstraint.activate([
			binaryView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
			containerView.widthAnchor.constraint(greaterThanOrEqualTo: binaryView.widthAnchor),
			binaryView.topAnchor.constraint(equalTo: layoutGuide.topAnchor)
		])

		arrowsImageView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(arrowsImageView)
		NSLayoutConstraint.activate([
			arrowsImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
			containerView.widthAnchor.constraint(greaterThanOrEqualTo: arrowsImageView.widthAnchor),
			arrowsImageView.topAnchor.constraint(equalTo: binaryView.bottomAnchor, constant: 20.0),
		])

		integerLabel.translatesAutoresizingMaskIntoConstraints = false
		integerLabel.textAlignment = .center
		integerLabel.textColor = .label
		integerLabel.numberOfLines = 0
		view.addSubview(integerLabel)
		NSLayoutConstraint.activate([
			integerLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -123.5),
			integerLabel.topAnchor.constraint(equalTo: arrowsImageView.bottomAnchor, constant: 13.0),
			layoutGuide.leadingAnchor.constraint(lessThanOrEqualTo: integerLabel.leadingAnchor),
			layoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: integerLabel.bottomAnchor)
		])

		fixedPointLabel.translatesAutoresizingMaskIntoConstraints = false
		fixedPointLabel.textAlignment = .center
		fixedPointLabel.textColor = .label
		fixedPointLabel.numberOfLines = 0
		view.addSubview(fixedPointLabel)
		NSLayoutConstraint.activate([
			fixedPointLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 123.5),
			fixedPointLabel.topAnchor.constraint(equalTo: arrowsImageView.bottomAnchor, constant: 13.0),
			fixedPointLabel.leadingAnchor.constraint(greaterThanOrEqualTo: integerLabel.trailingAnchor, constant: 6.0),
			layoutGuide.trailingAnchor.constraint(greaterThanOrEqualTo: fixedPointLabel.trailingAnchor),
			layoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: fixedPointLabel.bottomAnchor)
		])

		[0, 1, 4, 5].forEach { binaryView.setValueOfBit(at: $0, to: true) }
		updateLabels(integer: 51, fixedPoint: 0.2, scalingFactorNominator: 1, scalingFactorDenominator: 255)
	}

	func updateLabels(integer: Int, fixedPoint: Double, scalingFactorNominator: Int, scalingFactorDenominator: Int) {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 3

		let formattedFixedPoint = formatter.string(for: NSNumber(value: fixedPoint))!

		let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
		paragraphStyle.lineHeightMultiple = 1.15
		paragraphStyle.alignment = .center

		let integerLabelText = NSMutableAttributedString(string: "as unsigned\ninteger:\n", attributes: [
			.font: font
		])
		integerLabelText.append(NSAttributedString(string: "\(integer)", attributes: [
			.font: largeFont,
			.paragraphStyle: paragraphStyle
		]))
		integerLabel.attributedText = integerLabelText

		let fixedPointLabelText = NSMutableAttributedString(string: "as unsigned\nfixed-point number:\n", attributes: [
			.font: font
		])
		fixedPointLabelText.append(NSAttributedString(string: "\(integer) × ", attributes: [
			.font: largeFont,
			.paragraphStyle: paragraphStyle
		]))
		fixedPointLabelText.append(NSAttributedString(string: "\(scalingFactorNominator)⁄\(scalingFactorDenominator)", attributes: [
			.font: largeFractionFont,
			.paragraphStyle: paragraphStyle
		]))
		fixedPointLabelText.append(NSAttributedString(string: " = " + formattedFixedPoint, attributes: [
			.font: largeFont,
			.paragraphStyle: paragraphStyle
		]))
		fixedPointLabel.attributedText = fixedPointLabelText
	}
}

extension FixedPointArithmeticViewController: PlaygroundLiveViewMessageHandler {
	public func receive(_ message: PlaygroundValue) {
		guard case .dictionary(let dict) = message else {
			preconditionFailure()
        }

		if let value = dict["SetNumberOfBits"] {
			guard case .integer(let numberOfBits) = value else {
				preconditionFailure()
			}

			binaryView.numberOfBits = numberOfBits
		}

		if let value = dict["SetBit"] {
			guard case .integer(let index) = value else {
				preconditionFailure()
			}

			binaryView.setValueOfBit(at: index, to: true)
		}

		if let value = dict["ClearBit"] {
			guard case .integer(let index) = value else {
				preconditionFailure()
			}

			binaryView.setValueOfBit(at: index, to: false)
		}

		if let value = dict["UpdateLabels"] {
			guard case .dictionary(let dict) = value else {
				preconditionFailure()
			}
			guard let integerValue = dict["Integer"], case .integer(let integer) = integerValue else {
				preconditionFailure()
			}
			guard let fixedPointValue = dict["FixedPoint"], case .floatingPoint(let fixedPoint) = fixedPointValue else {
				preconditionFailure()
			}
			guard let scalingFactorNominatorValue = dict["ScalingFactorNominator"], case .integer(let scalingFactorNominator) = scalingFactorNominatorValue else {
				preconditionFailure()
			}
			guard let scalingFactorDenominatorValue = dict["ScalingFactorDenominator"], case .integer(let scalingFactorDenominator) = scalingFactorDenominatorValue else {
				preconditionFailure()
			}

			updateLabels(integer: integer, fixedPoint: fixedPoint, scalingFactorNominator: scalingFactorNominator, scalingFactorDenominator: scalingFactorDenominator)
		}
	}
}

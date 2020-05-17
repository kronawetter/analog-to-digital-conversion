//
//  R2RCircuitView.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-10.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import UIKit

class R2RCircuitView: UIView {
	private static let firstBitImage = UIImage(named: "R2RFirstBit")!.withTintColor(.label)
	private static let lastBitImage = UIImage(named: "R2RLastBit")!.withTintColor(.label)
	private static let bitImage = UIImage(named: "R2RBit")!.withTintColor(.label)
	private static let switchReferenceImage = UIImage(named: "R2RSwitchReference")!.withTintColor(.systemRed)
	private static let switchGroundImage = UIImage(named: "R2RSwitchGround")!.withTintColor(.label)

	private let firstBitImageView: UIImageView
	private let lastBitImageView: UIImageView
	private var bitImageViews: [UIImageView]
	private var switchImageViews: [UIImageView]
	private let referenceVoltageLabel: UILabel
	private let outputVoltageLabel: UILabel
	private var horizontalResistorLabels: [UILabel]
	private var verticalResistorLabels: [UILabel]
	private var switchLabels: [UILabel]

	let xSpacingBetweenImageViews: CGFloat = -18.0

	var resolution: Int {
		didSet {
			bitImageViews.forEach { $0.removeFromSuperview() }
			switchImageViews.forEach { $0.removeFromSuperview() }
			horizontalResistorLabels.forEach { $0.removeFromSuperview() }
			verticalResistorLabels.forEach { $0.removeFromSuperview() }
			switchLabels.forEach { $0.removeFromSuperview() }

			// I don’t know why, but this fixes a weird issue where the images of the `bitImageViews` and `switchImageViews` members have an inncorrect tint color when opening Playground page, enabling/disabling dark mode and then pressing run.
			bitImageViews = (0..<(resolution - 2)).map { _ in
				let imageView = UIImageView(image: UIImage(named: "R2RBit")!.withRenderingMode(.alwaysTemplate))
				imageView.tintColor = .label
				return imageView
			}
			//bitImageViews = (0..<(resolution - 2)).map { _ in UIImageView(image: Self.bitImage) }
			switchImageViews = (0..<resolution).map { _ in UIImageView(image: Self.switchGroundImage) }

			horizontalResistorLabels = (0..<(resolution - 1)).map { _ in
				let label = UILabel(frame: .zero)
				label.text = "R"
				label.textAlignment = .center
				label.textColor = .label
				label.font = .systemFont(ofSize: 13.0)
				label.sizeToFit()
				return label
			}

			verticalResistorLabels = (0...resolution).map { _ in
				let label = UILabel(frame: .zero)
				label.text = "2R"
				label.textColor = .label
				label.font = .systemFont(ofSize: 13.0)
				label.sizeToFit()
				return label
			}

			switchLabels = (0..<resolution).map { index in
				let label = UILabel(frame: .zero)
				label.text = "Bit \(index)"
				label.textColor = .label
				label.font = .systemFont(ofSize: 13.0)
				label.sizeToFit()
				return label
			}

			bitImageViews.forEach { addSubview($0) }
			switchImageViews.forEach { addSubview($0) }
			horizontalResistorLabels.forEach { addSubview($0) }
			verticalResistorLabels.forEach { addSubview($0) }
			switchLabels.forEach { addSubview($0) }

			setNeedsLayout()
			invalidateIntrinsicContentSize()
		}
	}

	enum SwitchPosition {
		case reference
		case ground
	}

	func setSwitch(at index: Int, to position: SwitchPosition) {
		switch position {
		case .reference:
			switchImageViews[index].image = Self.switchReferenceImage
			switchLabels[index].textColor = .systemRed
		case .ground:
			switchImageViews[index].image = Self.switchGroundImage
			switchLabels[index].textColor = .label
		}
	}

	init(resolution: Int) {
		self.resolution = resolution

		firstBitImageView = UIImageView(image: Self.firstBitImage)
		bitImageViews = (0..<(resolution - 2)).map { _ in UIImageView(image: Self.bitImage) }
		lastBitImageView = UIImageView(image: Self.lastBitImage)
		switchImageViews = (0..<resolution).map { _ in UIImageView(image: Self.switchGroundImage) }

		referenceVoltageLabel = UILabel(frame: .zero)
		referenceVoltageLabel.text = "Maximum Voltage"
		referenceVoltageLabel.textColor = .label
		referenceVoltageLabel.font = .systemFont(ofSize: 13.0)
		referenceVoltageLabel.sizeToFit()

		outputVoltageLabel = UILabel(frame: .zero)
		outputVoltageLabel.text = "Output Voltage"
		outputVoltageLabel.textColor = .label
		outputVoltageLabel.font = .systemFont(ofSize: 13.0)
		outputVoltageLabel.sizeToFit()

		horizontalResistorLabels = (0..<(resolution - 1)).map { _ in
			let label = UILabel(frame: .zero)
			label.text = "R"
			label.textAlignment = .center
			label.textColor = .label
			label.font = .systemFont(ofSize: 13.0)
			label.sizeToFit()
			return label
		}

		verticalResistorLabels = (0...resolution).map { _ in
			let label = UILabel(frame: .zero)
			label.text = "2R"
			label.textColor = .label
			label.font = .systemFont(ofSize: 13.0)
			label.sizeToFit()
			return label
		}

		switchLabels = (0..<resolution).map { index in
			let label = UILabel(frame: .zero)
			label.text = "Bit \(index)"
			label.textColor = .label
			label.font = .systemFont(ofSize: 13.0)
			label.sizeToFit()
			return label
		}

		super.init(frame: .zero)

		addSubview(firstBitImageView)
		addSubview(lastBitImageView)
		bitImageViews.forEach { addSubview($0) }
		switchImageViews.forEach { addSubview($0) }

		addSubview(referenceVoltageLabel)
		addSubview(outputVoltageLabel)
		horizontalResistorLabels.forEach { addSubview($0) }
		verticalResistorLabels.forEach { addSubview($0) }
		switchLabels.forEach { addSubview($0) }

		setNeedsLayout()
		invalidateIntrinsicContentSize()
	}

	override func layoutSubviews() {
		firstBitImageView.frame.origin = .zero
		var maxXOfPreviousImageView = firstBitImageView.frame.maxX

		bitImageViews.enumerated().forEach { index, view in
			view.frame.origin = CGPoint(x: maxXOfPreviousImageView + xSpacingBetweenImageViews, y: 0.0)
			maxXOfPreviousImageView = view.frame.maxX
		}

		lastBitImageView.frame.origin = CGPoint(x: maxXOfPreviousImageView + xSpacingBetweenImageViews, y: 0.0)

		switchImageViews.enumerated().forEach { index, view in
			view.frame.origin = CGPoint(x: 98.0 + 70.0 * CGFloat(index) - view.frame.width, y: 0.0)
		}

		referenceVoltageLabel.frame.origin = CGPoint(x: 4.0, y: bounds.height - referenceVoltageLabel.frame.height)

		outputVoltageLabel.frame.origin = CGPoint(x: bounds.width - outputVoltageLabel.frame.width, y: 2.0)

		horizontalResistorLabels.enumerated().forEach { index, view in
			view.frame.size.width = 30.0
			view.frame.origin = CGPoint(x: 95.0 + 70.0 * CGFloat(index), y: 0.0)
		}

		verticalResistorLabels.enumerated().forEach { index, view in
			view.frame.size.height = 30.0
			view.frame.origin = CGPoint(x: 18.0 + 70.0 * CGFloat(index), y: 45.0)
		}

		switchLabels.enumerated().forEach { index, view in
			view.frame.origin = CGPoint(x: 63.0 + 70.0 * CGFloat(index) - view.frame.width, y: 88.0)
		}

		super.layoutSubviews()
	}

	override var intrinsicContentSize: CGSize {
		let width = Self.firstBitImage.size.width + Self.lastBitImage.size.width + Self.bitImage.size.width * CGFloat(resolution - 2) + xSpacingBetweenImageViews * CGFloat(resolution - 1)
		let height = Self.firstBitImage.size.height
		return CGSize(width: width, height: height)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

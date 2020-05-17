//
//  SarCircuitView.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-08.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import UIKit

class SarCircuitView: UIView {
	class DacInputLineView: UIView {
		let line: UIView
		let label: UILabel

		var isActive: Bool = false {
			didSet {
				label.text = isActive ? "1" : "0"

				let color = isActive ? UIColor.systemRed : UIColor.label
				line.backgroundColor = color
				label.textColor = color
			}
		}

		override init(frame: CGRect) {
			line = UIView(frame: CGRect(x: 20.0, y: 0.0, width: 2.0, height: 30.0))
			line.backgroundColor = .label

			label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 30.0))
			label.text = "0"
			label.textAlignment = .right
			label.textColor = .label
			label.font = .systemFont(ofSize: 13.0)

			super.init(frame: CGRect(x: frame.minX, y: frame.minY, width: 22.0, height: 30.0))

			addSubview(line)
			addSubview(label)
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}

	private let baseImage = UIImage(named: "SARCircuitBase")!
	private let baseView: UIImageView
	private let logicLabel: UILabel
	private let dacLabel: UILabel
	private let inputVoltageLabel: UILabel
	private let referenceVoltageLabel: UILabel
	private var dacInputLineViews: [DacInputLineView]

	var dacResolution: Int {
		willSet {
			dacInputLineViews.forEach { $0.removeFromSuperview() }
			dacInputLineViews = []
		}
		didSet {
			baseView.frame.size.width = 70.0 + 144.0 + CGFloat(dacResolution) * 22.0
			logicLabel.frame.size.width = 20.0 + CGFloat(dacResolution) * 22.0 - 4.0
			dacLabel.frame.size.width = 20.0 + CGFloat(dacResolution) * 22.0 - 4.0
			inputVoltageLabel.frame.size.width = 20.0 + CGFloat(dacResolution) * 22.0 + 30.0

			dacInputLineViews = (0..<dacResolution).reversed().map { DacInputLineView(frame: CGRect(x: 70.0 + CGFloat($0) * 22.0, y: 44.0, width: 2.0, height: 30.0)) }
			dacInputLineViews.forEach { addSubview($0) }

			invalidateIntrinsicContentSize()
		}
	}

	init(dacResolution: Int) {
		precondition(dacResolution > 0)

		baseView = UIImageView(image: baseImage.withTintColor(.label))
		baseView.frame.size.width = 70.0 + 144.0 + CGFloat(dacResolution) * 22.0

		logicLabel = UILabel(frame: CGRect(x: 70.0 + 2.0, y: 2.0, width: 20.0 + CGFloat(dacResolution) * 22.0 - 4.0, height: 40.0))
		logicLabel.text = "Logic"
		logicLabel.textAlignment = .center
		logicLabel.font = .systemFont(ofSize: 13.0)
		logicLabel.textColor = .label

		dacLabel = UILabel(frame: CGRect(x: 70.0 + 2.0, y: 76.0, width: 20.0 + CGFloat(dacResolution) * 22.0 - 4.0, height: 40.0))
		dacLabel.text = "D/A Converter"
		dacLabel.textAlignment = .center
		dacLabel.font = .systemFont(ofSize: 13.0)
		dacLabel.textColor = .label

		inputVoltageLabel = UILabel(frame: CGRect(x: 70.0 + 0.0, y: 145.0, width: 20.0 + CGFloat(dacResolution) * 22.0 + 30.0, height: 20.0))
		inputVoltageLabel.text = "Input Voltage"
		inputVoltageLabel.font = .systemFont(ofSize: 13.0)
		inputVoltageLabel.textColor = .label

		referenceVoltageLabel = UILabel(frame: CGRect(x: 0.0, y: 101.0, width: 65.0, height: 37.0))
		referenceVoltageLabel.text = "Maximum Voltage"
		referenceVoltageLabel.font = .systemFont(ofSize: 13.0)
		referenceVoltageLabel.numberOfLines = 0
		referenceVoltageLabel.textColor = .label

		dacInputLineViews = (0..<dacResolution).reversed().map { DacInputLineView(frame: CGRect(x: 70.0 + CGFloat($0) * 22.0, y: 44.0, width: 2.0, height: 30.0)) }

		self.dacResolution = dacResolution

		super.init(frame: CGRect(origin: .zero, size: baseView.frame.size))

		addSubview(baseView)
		addSubview(logicLabel)
		addSubview(dacLabel)
		addSubview(inputVoltageLabel)
		addSubview(referenceVoltageLabel)
		dacInputLineViews.forEach { addSubview($0) }
	}

	override var intrinsicContentSize: CGSize {
		CGSize(width: 70.0 + 144.0 + CGFloat(dacResolution) * 22.0, height: baseImage.size.height)
	}

	override func sizeThatFits(_ size: CGSize) -> CGSize {
		intrinsicContentSize
	}

	func setValueOfDacInputLine(at index: Int, value: Bool) {
		dacInputLineViews[index].isActive = value
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

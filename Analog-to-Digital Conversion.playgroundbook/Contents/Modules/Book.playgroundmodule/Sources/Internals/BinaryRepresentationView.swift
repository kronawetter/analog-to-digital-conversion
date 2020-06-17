//
//  BinaryRepresentationView.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-15.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import UIKit

public class BinaryRepresentationView: UIView {
	private let image = UIImage(named: "BinaryRepresentation")!.withTintColor(.label)
	private let imageSingle = UIImage(named: "BinaryRepresentationSingle")!.withTintColor(.label)
	private let imageView: UIImageView
	private var bitIndexLabels: [UILabel]
	private var bitValueLabels: [UILabel]

	private let bitIndexLabelHeight: CGFloat = 28.0
	private let bitValueLabelHeight: CGFloat = 33.0

	public var numberOfBits: Int {
		didSet {
			imageView.image = (numberOfBits > 1 ? image : imageSingle)
			imageView.isHidden = numberOfBits <= 0

			bitIndexLabels.forEach { $0.removeFromSuperview() }
			bitValueLabels.forEach { $0.removeFromSuperview() }

			bitIndexLabels = (0..<numberOfBits).reversed().map { index in
				let label = UILabel()
				label.text = "\(index)"
				label.textAlignment = .center
				label.textColor = .label
				label.font = .systemFont(ofSize: 14.0)
				return label
			}

			bitValueLabels = (0..<numberOfBits).map { _ in
				let label = UILabel()
				label.text = "0"
				label.textAlignment = .center
				label.textColor = .label
				label.font = .systemFont(ofSize: 20.0, weight: .medium)
				return label
			}

			bitIndexLabels.forEach { addSubview($0) }
			bitValueLabels.forEach { addSubview($0) }

			setNeedsLayout()
			invalidateIntrinsicContentSize()
		}
	}

	public init(numberOfBits: Int) {
		self.numberOfBits = numberOfBits

		imageView = UIImageView(image: numberOfBits > 1 ? image : imageSingle)
		imageView.isHidden = numberOfBits <= 0

		bitIndexLabels = (0..<numberOfBits).reversed().map { index in
			let label = UILabel()
			label.text = "\(index)"
			label.textAlignment = .center
			label.textColor = .label
			label.font = .systemFont(ofSize: 14.0)
			return label
		}

		bitValueLabels = (0..<numberOfBits).map { _ in
			let label = UILabel()
			label.text = "0"
			label.textAlignment = .center
			label.textColor = .label
			label.font = .systemFont(ofSize: 20.0, weight: .medium)
			return label
		}

		super.init(frame: .zero)

		addSubview(imageView)
		bitIndexLabels.forEach { addSubview($0) }
		bitValueLabels.forEach { addSubview($0) }

		frame = CGRect(origin: .zero, size: intrinsicContentSize)
	}

	public override var intrinsicContentSize: CGSize {
		return CGSize(width: 1.0 + CGFloat(numberOfBits) * 31.0, height: bitIndexLabelHeight + bitValueLabelHeight + 2.0)
	}

	public override func layoutSubviews() {
		imageView.frame = CGRect(x: 0.0, y: bitIndexLabelHeight, width: bounds.width, height: bitValueLabelHeight + 2.0)

		for (index, label) in bitIndexLabels.enumerated() {
			label.frame = CGRect(x: 1.0 + CGFloat(index) * 31.0, y: 1.0, width: 30.0, height: bitIndexLabelHeight)
		}

		for (index, label) in bitValueLabels.enumerated() {
			label.frame = CGRect(x: 1.0 + CGFloat(index) * 31.0, y: bitIndexLabelHeight + 1.0, width: 30.0, height: bitValueLabelHeight)
		}

		super.layoutSubviews()
	}

	public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)

		// `image`/`imageSingle` sometimes doesn’t get re-tinted automatically when dark mode is enabled or disabled, so set the image again on the image view to force re-tinting
		let oldImage = imageView.image
		imageView.image = nil
		imageView.image = oldImage
	}

	func setValueOfBit(at index: Int, to value: Bool) {
		let label = bitValueLabels[numberOfBits - index - 1]
		
		label.text = value ? "1" : "0"
		label.textColor = value ? .systemRed : .label
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

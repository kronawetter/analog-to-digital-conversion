//
//  IntroductionViewController.swift
//  analog
//
//  Created by Philip Kronawetter on 2020-05-16.
//  Copyright © 2020 Philip Kronawetter. All rights reserved.
//

import UIKit
import PlaygroundSupport

public class IntroductionViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
	private let scrollView = UIScrollView()
	private let containerView = UIView()
	private let signalView = SignalView(frame: .zero, continuousSignal: EcgSignal(), sampledSignal: SampledSignal())

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

		signalView.translatesAutoresizingMaskIntoConstraints = false
		signalView.backgroundColor = .secondarySystemBackground
		scrollView.addSubview(signalView)
		NSLayoutConstraint.activate([
			signalView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
			containerView.widthAnchor.constraint(greaterThanOrEqualTo: signalView.widthAnchor),
			signalView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
			containerView.heightAnchor.constraint(greaterThanOrEqualTo: signalView.heightAnchor),
			signalView.widthAnchor.constraint(equalToConstant: 400.0),
			signalView.heightAnchor.constraint(equalToConstant: 200.0)
		])
	}
}

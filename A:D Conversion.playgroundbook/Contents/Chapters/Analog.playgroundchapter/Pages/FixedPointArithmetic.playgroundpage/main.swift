/*:
Before we get started, let’s talk about a concept that is core to the explanations on the following pages.

As you probably know, computers work with bits. We can take a number of bits and use them to encode an integer.

Bits can also be used to encode other types of data, for example real numbers. One way to encode real numbers is to still treat the bits like integers, but to think that their value is scaled by a constant factor. This is called *fixed-point arithmetic*.

- Note:
The number of bits determines the amount of information that can be stored. As the number of available bits in a system is usually finite, it is not possible to precisely represent every real number in digital systems.
*/
//#-hidden-code
import Book
import Foundation
import PlaygroundSupport
import Darwin

func / (left: UInt, right: UInt) -> Fraction {
	guard right > 0 else {
		fatalError("The denominator must not be zero.")
	}
	return Fraction(nominator: Int(left), denominator: Int(right))
}

var numberOfBits = 0
var scalingFactor: Fraction = 1 / 1
let remoteView = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
var input: UInt32 = 0
var fixedPointValue: Double {
	Double(input) * scalingFactor.value
}

func setNumberOfBits(_ value: Int) {
	guard value > 0 else {
		fatalError("There must be at least one bit.")
	}
	guard value <= input.bitWidth else {
		fatalError("This example only supports up to \(input.bitWidth) bits.")
	}
	numberOfBits = value
}

func setScalingFactor(_ value: Fraction) {
	scalingFactor = value
}

//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(literal, show, integer)
setNumberOfBits(/*#-editable-code*/8/*#-end-editable-code*/)
setScalingFactor(/*#-editable-code*/1/*#-end-editable-code*/ / /*#-editable-code*/255/*#-end-editable-code*/)
//#-hidden-code

var delay: TimeInterval {
	switch PlaygroundPage.current.executionMode {
	case .run:
		return 0.0
	case .step:
		return 1.5
	case .stepSlowly:
		return 1.5
	default:
		return 0.0
	}
}

/// Sets the bit at the specified index.
/// - Parameter index: Index of the bit to set. Must be larger than 0 and smaller than the configured number of bits.
func setBit(at index: Int) {
	guard index < numberOfBits else {
		fatalError("You’ve set the number of bits to \(numberOfBits), so index of the highest possible bit index is \(numberOfBits - 1).")
	}

	input |= 1 << index

	remoteView.send(.dictionary([
		"SetBit": .integer(index),
		"UpdateLabels": .dictionary([
			"Integer": .integer(Int(input)),
			"FixedPoint": .floatingPoint(fixedPointValue),
			"ScalingFactorNominator": .integer(scalingFactor.nominator),
			"ScalingFactorDenominator": .integer(scalingFactor.denominator)
		])
	]))

	Thread.sleep(forTimeInterval: delay)
}

/// Clears the bit at the specified index.
/// - Parameter index: Index of the bit to clear. Must be larger than 0 and smaller than the configured number of bits.
func clearBit(at index: Int) {
	guard index < numberOfBits else {
		fatalError("You’ve set the number of bits to \(numberOfBits), so index of the highest possible bit index is \(numberOfBits - 1).")
	}

	input &= ~(1 << index)

	remoteView.send(.dictionary([
		"ClearBit": .integer(index),
		"UpdateLabels": .dictionary([
			"Integer": .integer(Int(input)),
			"FixedPoint": .floatingPoint(fixedPointValue),
			"ScalingFactorNominator": .integer(scalingFactor.nominator),
			"ScalingFactorDenominator": .integer(scalingFactor.denominator)
		])
	]))

	Thread.sleep(forTimeInterval: delay)
}

remoteView.send(.dictionary([
	"SetNumberOfBits": .integer(numberOfBits),
	"UpdateLabels": .dictionary([
		"Integer": .integer(Int(input)),
		"FixedPoint": .floatingPoint(fixedPointValue),
		"ScalingFactorNominator": .integer(scalingFactor.nominator),
		"ScalingFactorDenominator": .integer(scalingFactor.denominator)
	])
]))
//#-end-hidden-code

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, setBit(at:), clearBit(at:))
//#-editable-code Use setBit(at:) and clearBit(at:) to set and clear bits.
setBit(at: 0)
setBit(at: 1)
setBit(at: 4)
setBit(at: 5)
//#-end-editable-code

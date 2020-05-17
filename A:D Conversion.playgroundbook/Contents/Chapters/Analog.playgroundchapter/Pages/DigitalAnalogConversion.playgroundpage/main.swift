/*:
There are electric circuits that can output a fixed-point number as an electrical voltage. A variant of such a circuit is called *R-2R resistor ladder* and is shown in the Live View. As these circuits generate an analog voltage from a digital signal, we refer to them as *digital-to-analog converters*.

Essentially, the circuit has a number of switches that corresponds to the number of bits. Placing a switch in its left position is equivalent to setting the corresponding bit, while placing it in its right position is equivalent to clearing that bit.

When all bits are set, the circuit outputs a voltage that is equivalent to the maximum voltage it can generate. Consequently, the scaling factor of the fixed-point number is `maximumVoltage` ∕ ((2 ^ `numberOfBits`) - 1).

- Note:
The code below updates the output voltage on a constant time interval. This is another significant difference between analog and digital systems. While analog systems can change their outputs anytime, digital systems can only refresh them at specific points in time.

---

- Experiment:
The code below generates a voltage that represents an exponential function. Change the parameters and observe how the generated voltage changes.
*/
//#-code-completion(everything, hide)
//#-code-completion(literal, show, integer)
//#-hidden-code
import Book
import Foundation
import PlaygroundSupport
import Darwin

var numberOfBits: Int = 0
var maximumVoltage: Double = 0.0
var timeBetweenUpdates: TimeInterval = 0.5

func setNumberOfBits(_ value: Int) {
	guard (2...UInt64.bitWidth).contains(value) else {
		fatalError("This example requires 2 bits at least and 64 bits at most.")
	}
	numberOfBits = value
}

func setMaximumVoltage(_ value: Double) {
	guard value > 0.0 else {
		fatalError("This example only supports maximum voltages that are larger than zero.")
	}
	maximumVoltage = value
}

func setTimeBetweenUpdates(_ value: TimeInterval) {
	guard value > 0.0 else {
		fatalError("The time between updates must be larger than zero.")
	}
	timeBetweenUpdates = value
}

//#-end-hidden-code
setNumberOfBits(/*#-editable-code*/5/*#-end-editable-code*/)
setMaximumVoltage(/*#-editable-code*/10.0/*#-end-editable-code*/)
setTimeBetweenUpdates(/*#-editable-code*/0.5/*#-end-editable-code*/)
/*:
- Callout(Tip):
Try the different execution modes by tapping on the stopwatch button next to the “Run My Code” button. For example, choose “Step Through My Code” to see the effect of every line, or choose “Run Fastest” to quickly obtain the conversion result.
*/
//#-hidden-code

let remoteView = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
var resistorLadder = R2RResistorLadder(numberOfBits: numberOfBits, referenceVoltage: maximumVoltage)
var currentTime: TimeInterval = 0.0

var delay: TimeInterval {
	switch PlaygroundPage.current.executionMode {
	case .run:
		return 0.5
	case .runFaster:
		return 0.2
	case .step:
		return 0.5
	case .stepSlowly:
		return 0.5
	default:
		return 0.01
	}
}

func setBit(at index: Int) {
	resistorLadder.setBit(at: index)

	remoteView.send(.dictionary([
		"SetBit": .integer(index),
		"SaveSample": .dictionary([
			"Time": .floatingPoint(currentTime),
			"Voltage": .floatingPoint(resistorLadder.outputVoltage)
		])
	]))

	Thread.sleep(forTimeInterval: delay / 2.0)
}

func clearBit(at index: Int) {
	resistorLadder.clearBit(at: index)

	remoteView.send(.dictionary([
		"ClearBit": .integer(index),
		"SaveSample": .dictionary([
			"Time": .floatingPoint(currentTime),
			"Voltage": .floatingPoint(resistorLadder.outputVoltage)
		])
	]))

	Thread.sleep(forTimeInterval: delay / 2.0)
}

func clearAllBits(saveSample: Bool = true) {
	resistorLadder.clearAllBits()

	if saveSample {
		remoteView.send(.dictionary([
			"ClearAllBits": .boolean(true),
			"SaveSample": .dictionary([
				"Time": .floatingPoint(currentTime),
				"Voltage": .floatingPoint(resistorLadder.outputVoltage)
			])
		]))
	} else {
		remoteView.send(.dictionary([
			"ClearAllBits": .boolean(true)
		]))
	}

	Thread.sleep(forTimeInterval: delay / 2.0)
}

func wait(for time: TimeInterval) {
	currentTime += time

	remoteView.send(.dictionary([
		"SaveSample": .dictionary([
			"Time": .floatingPoint(currentTime),
			"Voltage": .floatingPoint(resistorLadder.outputVoltage)
		])
	]))

	Thread.sleep(forTimeInterval: delay)
}

remoteView.send(.dictionary([
	"SetDacResolution": .integer(numberOfBits),
	"SetMaximumVoltage": .floatingPoint(maximumVoltage),
	"ClearSamples": .boolean(true)
]))

func getOutputValue() -> Double {
	resistorLadder.outputVoltage
}

clearAllBits(saveSample: false)

//#-end-hidden-code
for step in 0..<Int(7.0 / timeBetweenUpdates) {
	let bitIndex = step % (numberOfBits + 1)

	if bitIndex == 0 {
		clearAllBits()
	} else {
		setBit(at: bitIndex - 1)
	}

	wait(for: timeBetweenUpdates)
}

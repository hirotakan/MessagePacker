import XCTest

extension ArrayPackedTests {
    static let __allTests = [
        ("test2DimensionalArray", test2DimensionalArray),
        ("testBinaryArray", testBinaryArray),
        ("testFixArray", testFixArray),
        ("testNilArray", testNilArray),
    ]
}

extension ArrayUnpackedTests {
    static let __allTests = [
        ("test2DimensionalArray", test2DimensionalArray),
        ("testBinaryArray", testBinaryArray),
        ("testFixArray", testFixArray),
        ("testNilArray", testNilArray),
    ]
}

extension BinaryPackedTests {
    static let __allTests = [
        ("testBinary8", testBinary8),
    ]
}

extension BinaryUnpackedTests {
    static let __allTests = [
        ("testBinary8", testBinary8),
    ]
}

extension BoolPackedTests {
    static let __allTests = [
        ("testFalse", testFalse),
        ("testTrue", testTrue),
    ]
}

extension BoolUnpackedTests {
    static let __allTests = [
        ("testFalse", testFalse),
        ("testTrue", testTrue),
    ]
}

extension CustomPackedTests {
    static let __allTests = [
        ("testCustom", testCustom),
        ("testCustomUnkeyedCollection", testCustomUnkeyedCollection),
        ("testDate", testDate),
        ("testURL", testURL),
    ]
}

extension CustomUnpackedTests {
    static let __allTests = [
        ("testCustom", testCustom),
        ("testCustomUnkeyedCollection", testCustomUnkeyedCollection),
        ("testDate", testDate),
        ("testURL", testURL),
    ]
}

extension DoublePackedTests {
    static let __allTests = [
        ("testDouble", testDouble),
    ]
}

extension DoubleUnpackedTests {
    static let __allTests = [
        ("testDouble", testDouble),
    ]
}

extension ExtensionPackedTests {
    static let __allTests = [
        ("testExt16", testExt16),
        ("testExt32", testExt32),
        ("testExt8", testExt8),
        ("testFixext1", testFixext1),
        ("testFixext16", testFixext16),
        ("testFixext2", testFixext2),
        ("testFixext4", testFixext4),
        ("testFixext8", testFixext8),
    ]
}

extension ExtensionUnpackedTests {
    static let __allTests = [
        ("testExt16", testExt16),
        ("testExt32", testExt32),
        ("testExt8", testExt8),
        ("testFixext1", testFixext1),
        ("testFixext16", testFixext16),
        ("testFixext2", testFixext2),
        ("testFixext4", testFixext4),
        ("testFixext8", testFixext8),
    ]
}

extension FloatPackedTests {
    static let __allTests = [
        ("testFloat", testFloat),
    ]
}

extension FloatUnpackedTests {
    static let __allTests = [
        ("testFloat", testFloat),
    ]
}

extension IntegerPackedTests {
    static let __allTests = [
        ("testInt16", testInt16),
        ("testInt32", testInt32),
        ("testInt64", testInt64),
        ("testInt8", testInt8),
        ("testNegativeFixint", testNegativeFixint),
        ("testPositiveFixint", testPositiveFixint),
        ("testUInt16", testUInt16),
        ("testUInt32", testUInt32),
        ("testUInt64", testUInt64),
        ("testUInt8", testUInt8),
    ]
}

extension IntegerUnpackedTests {
    static let __allTests = [
        ("testInt16", testInt16),
        ("testInt32", testInt32),
        ("testInt64", testInt64),
        ("testInt8", testInt8),
        ("testNegativeFixint", testNegativeFixint),
        ("testPositiveFixint", testPositiveFixint),
        ("testUInt16", testUInt16),
        ("testUInt32", testUInt32),
        ("testUInt64", testUInt64),
        ("testUInt8", testUInt8),
    ]
}

extension MapPackedTests {
    static let __allTests = [
        ("test2DimensionalMap", test2DimensionalMap),
        ("testFixMap", testFixMap),
        ("testNilMap", testNilMap),
    ]
}

extension MapUnpackedTests {
    static let __allTests = [
        ("test2DimensionalMap", test2DimensionalMap),
        ("testFixMap", testFixMap),
        ("testNilMap", testNilMap),
    ]
}

extension NilPackedTests {
    static let __allTests = [
        ("testNil", testNil),
        ("testValue", testValue),
    ]
}

extension NilUnpackedTests {
    static let __allTests = [
        ("testNil", testNil),
        ("testValue", testValue),
    ]
}

extension StringPackedTests {
    static let __allTests = [
        ("testFixString", testFixString),
        ("testFixString16", testFixString16),
        ("testFixString32", testFixString32),
        ("testFixString8", testFixString8),
    ]
}

extension StringUnpackedTests {
    static let __allTests = [
        ("testFixString", testFixString),
        ("testFixString16", testFixString16),
        ("testFixString32", testFixString32),
        ("testFixString8", testFixString8),
    ]
}

extension TimestampPackedTests {
    static let __allTests = [
        ("testTimestamp32", testTimestamp32),
        ("testTimestamp64", testTimestamp64),
        ("testTimestamp96", testTimestamp96),
    ]
}

extension TimestampUnpackedTests {
    static let __allTests = [
        ("testTimestamp32", testTimestamp32),
        ("testTimestamp64", testTimestamp64),
        ("testTimestamp96", testTimestamp96),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ArrayPackedTests.__allTests),
        testCase(ArrayUnpackedTests.__allTests),
        testCase(BinaryPackedTests.__allTests),
        testCase(BinaryUnpackedTests.__allTests),
        testCase(BoolPackedTests.__allTests),
        testCase(BoolUnpackedTests.__allTests),
        testCase(CustomPackedTests.__allTests),
        testCase(CustomUnpackedTests.__allTests),
        testCase(DoublePackedTests.__allTests),
        testCase(DoubleUnpackedTests.__allTests),
        testCase(ExtensionPackedTests.__allTests),
        testCase(ExtensionUnpackedTests.__allTests),
        testCase(FloatPackedTests.__allTests),
        testCase(FloatUnpackedTests.__allTests),
        testCase(IntegerPackedTests.__allTests),
        testCase(IntegerUnpackedTests.__allTests),
        testCase(MapPackedTests.__allTests),
        testCase(MapUnpackedTests.__allTests),
        testCase(NilPackedTests.__allTests),
        testCase(NilUnpackedTests.__allTests),
        testCase(StringPackedTests.__allTests),
        testCase(StringUnpackedTests.__allTests),
        testCase(TimestampPackedTests.__allTests),
        testCase(TimestampUnpackedTests.__allTests),
    ]
}
#endif

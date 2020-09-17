import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DPEdgeMenu_SwiftTests.allTests),
    ]
}
#endif

//
//  IconFinderTests.swift
//  IconFinderTests
//
//  Created by Петр Постников on 19.06.2024.
//

import XCTest
@testable import IconFinder

final class IconFinderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURLWorker() throws {
        let worker = URLWorker()
        let url = worker.getURLImage(icon: Icon(
            categories: [],
            containers: [],
            tags: [],
            publishedAt: "",
            type: .vector,
            iconID: 0,
            vectorSizes: [],
            styles: [],
            isPremium: false,
            prices: nil,
            rasterSizes: [RasterSize(sizeHeight: 200,
                                     formats: [FormatElement(
                                        previewURL: "previewURL",
                                        format: .png,
                                        downloadURL: "downloadURL")],
                                     size: 100,
                                     sizeWidth: 100)],
            isIconGlyph: false),
                           format: .png)
        XCTAssertEqual(url, "downloadURL", "must be downloadURL")
    }
    
    func testMainViewModel() throws {
        let networkProvider = NetworkProviderTest()
        let viewModel = MainViewModel(networkProvider: networkProvider)
        viewModel.getRequest(searchText: "")
        let count = viewModel.result?.totalCount
        XCTAssertEqual(count, 0, "must be 0")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

private class NetworkProviderTest: NetworkProviderProtocol {
    func getRequest(searchText: String, completion: @escaping (IconFinder.ResultsModel?) -> ()) {
        completion(ResultsModel(totalCount: 0, icons: []))
    }
}

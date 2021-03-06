//
//  AddEventTests.swift
//  TravTests
//
//  Created by Tommaso Scarlatti on 30/12/2017.
//  Copyright © 2017 Tommaso Scarlatti. All rights reserved.
//

import XCTest

@testable import Trav

class AddEventTests: XCTestCase {
    
    struct EventToTest: Decodable {
        var events: [Event]
        var message: String
    }
    
    var addedEvent: Event?
    
    let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjFjYTY2ZjNkMjcyYjM3YjgzOTc5NjlkOGEyNGQxNDIxMWU1YzM4MjdjYTMxMzEzNGNhYmVlNWNlOGE4YzIzMmZkZDIxNWYwMGIwZTczZGQ0In0.eyJhdWQiOiIyIiwianRpIjoiMWNhNjZmM2QyNzJiMzdiODM5Nzk2OWQ4YTI0ZDE0MjExZTVjMzgyN2NhMzEzMTM0Y2FiZWU1Y2U4YThjMjMyZmRkMjE1ZjAwYjBlNzNkZDQiLCJpYXQiOjE1MTQ4OTEyOTAsIm5iZiI6MTUxNDg5MTI5MCwiZXhwIjoxNTQ2NDI3MjkwLCJzdWIiOiI5MjQiLCJzY29wZXMiOltdfQ.z68dU8bwmGU3mAP1iJcQm3Jad2s3l-Y8i5mNX7WcS0Iu4Uh53NACq-8GAm6nMfHRiNOk712l5b7sxP6UoaUoZVB0A8bbjctLV-iY47Y46fSuV6T7a4jCz0xjbb8HJJzfQFwp8H7NxSMxmltiwwTAN9qPNKEmyMWPElk2r7EaXqm_Ycmz2qVx2JgsadyoEZaHbmpsqf1jK8x2WU6jpENbRZGnyh2JZ_NNNi-fSCJW_lDYVJx5v5fHexKiyMSQvMJo7BMK9YgqwqWGjBjZ29KhMwrxYgpWrhb2VRfKNwNN11idOD-c8_KXlaFzNOAYahMyKxkzvDdcA8uavxcp2I-1L0GkWprRJvTna5eGnooBI9xRWonhVrLVgR8cpIkpO3v-H-ql6-6Vy4a1UYaCyF6lLmSRQyG5XdUt_yfdBjsDbk4TVO26b-UR6f6WozQBroIxjwPVtE7skRt56elGOvCOagy-lhkBxFf9QdvcPmtjRH3JPfAL59_lHGdoWNzo-Hft49FN36do6A07vWZgtmxNfblFKLvo6SkOtvqf9nFbuHxjyWvocBTu__2uau8FBc7VJzfRkBFrcBRdUA2U8-Vvnwof5ojLano0iAO5MlIHPmP3QFW4LTq_Do8FNYMZ_RDl9Cjtn5l3LzVUx-kBVBhBOn_bqLNS8U-Eb_eCQQ7Ukew"
    
    var addEventVC: AddEventViewController?
    var dayVC: DayViewController?
    
    override func setUp() {
        super.setUp()
        addEventVC = AddEventViewController()
        dayVC = DayViewController()
    }
    
    // In order to make the effects of the test nullable, every added event is deleted
    override func tearDown() {
        let ex = expectation(description: "Expecting the deletion of the added event")
        
        dayVC?.deleteEvent(authenticateWith: token, event: (addedEvent?.id)!) { (statusCode) in
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
        
        super.tearDown()
    }
    
    func testAddEventWithNoTravel() {
        RawEventToBeAdded.title = "Test Title"
        RawEventToBeAdded.description = "Test Description"
        RawEventToBeAdded.start = 50000
        RawEventToBeAdded.end = 51000
        
        let ex = expectation(description: "Expecting a value of statusCode == 200")
        
        addEventVC!.addEventToServer(authenticateWith: token) { (statusCode, data) in
            XCTAssertEqual(statusCode, 200)
            
            if let json = data {
                do {
                    let decodedEvent = try JSONDecoder().decode(EventToTest.self, from: json)
                    self.addedEvent = decodedEvent.events[0]
                } catch {}
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    func testAddFlexibleEvent() {
        RawEventToBeAdded.title = "Test Flexible Event Title"
        RawEventToBeAdded.description = "Test Description"
        RawEventToBeAdded.start = 13000
        RawEventToBeAdded.end = 14000
        RawEventToBeAdded.isFlexible = true
        RawEventToBeAdded.duration = 500
        
        let ex = expectation(description: "Expecting a value of statusCode == 200")
        
        addEventVC!.addEventToServer(authenticateWith: token) { (statusCode, data) in
            XCTAssertEqual(statusCode, 200)
            
            if let json = data {
                do {
                    let decodedEvent = try JSONDecoder().decode(EventToTest.self, from: json)
                    self.addedEvent = decodedEvent.events[0]
                } catch {}
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
   
}

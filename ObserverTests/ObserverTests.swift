//
//  ObserverTests.swift
//  ObserverTests
//
//  Created by Dmitry Gordin on 12/23/16.
//  Copyright © 2016 Dmitry Gordin. All rights reserved.
//

import XCTest
@testable import Observer

class ObserverTests: XCTestCase {
    
    class VoidObserver {
        var isCalled = false
        
        func callMe() {
            isCalled = true
        }
    }
    class StringObserver {
        var isCalled = false
        var parametr: String? = nil
        
        func callMe(param: String) {
            isCalled = true
            parametr = param
        }
    }
    class TupleObserver {
        var isCalled = false
        var stringParametr: String? = nil
        var intParametr: Int? = nil
        
        func callMe(param1: String, param2: Int) {
            isCalled = true
            stringParametr = param1
            intParametr = param2
        }
    }
    class DynamicObserver {
        static var callCount = 0
        
        func callMe() {
            DynamicObserver.callCount += 1
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimpleCallMethod() {
        let subject  = Subject<Void>()
        let testObserver = VoidObserver()
        subject.attach(testObserver, VoidObserver.callMe)
        assert(!testObserver.isCalled)
        subject.notify()
        assert(testObserver.isCalled)
    }
    
    func testCallMethodWithParametr() {
        let subject  = Subject<String>()
        let testObserver = StringObserver()
        subject.attach(testObserver, StringObserver.callMe)
        assert(!testObserver.isCalled)
        let string = "Hello!"
        subject.notify(string)
        assert(testObserver.isCalled)
        assert(testObserver.parametr == string)
    }
    
    func testCallMethodWithTuple() {
        let subject  = Subject<(String, Int)>()
        let testObserver = TupleObserver()
        subject.attach(testObserver, TupleObserver.callMe)
        assert(!testObserver.isCalled)
        let string = "Hello!"
        let int = 5
        subject.notify((string, 5))
        assert(testObserver.isCalled)
        assert(testObserver.stringParametr == string)
        assert(testObserver.intParametr == int)
    }
    
    func testUnsubscribeObserver() {
        DynamicObserver.callCount = 0
        
        let subject  = Subject<Void>()
        let testObserver = DynamicObserver()
        let observerRef = subject.attach(testObserver, DynamicObserver.callMe)
        assert(DynamicObserver.callCount == 0)
        subject.notify()
        assert(DynamicObserver.callCount == 1)
        subject.deatach(observerRef)
        subject.notify()
        assert(DynamicObserver.callCount == 1)
    }
    
    func testDestroyObserver() {
        DynamicObserver.callCount = 0
        
        let subject  = Subject<Void>()
        var testObserver: DynamicObserver? = DynamicObserver()
        subject.attach(testObserver!, DynamicObserver.callMe)
        assert(DynamicObserver.callCount == 0)
        subject.notify()
        assert(DynamicObserver.callCount == 1)
        testObserver = nil
        subject.notify()
        assert(DynamicObserver.callCount == 1)
    }
}

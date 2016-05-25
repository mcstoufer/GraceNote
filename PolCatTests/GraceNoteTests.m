//
//  GraceNoteTests.m
//  GraceNoteTests
//
//  Created by Martin Stoufer on 5/17/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PoliticalTweet.h"
#import "TweeterTableViewCell.h"
#import "PoliticalTweetStream.h"

@interface GraceNoteTests : XCTestCase

@end

@implementation GraceNoteTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/**
 *  @brief Test that a Tweet without State, or Party affiliations properly constructs a table
 *          view cell;
 */
- (void)testCellDefaults {
    PoliticalTweet *defaultTweet = [PoliticalTweet new];
    defaultTweet.text = @"An innocous message with no politically charged message.";
    PoliticalTweetStream *stream = [PoliticalTweetStream new];
    stream.tweets = @[defaultTweet];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [stream primaryImageForTweet:defaultTweet withCompletion:^(UIImage *image) {
        XCTAssertNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    XCTAssertTrue([[stream auxImageForTweet:defaultTweet] isEqual:[UIImage imageNamed:@"OtherParty"]]);
    XCTAssertTrue([[stream titleForTweetAtIndex:path.row] isEqualToString:defaultTweet.text]);
}

-(void)testState {
    PoliticalTweet *defaultTweet = [PoliticalTweet new];
    defaultTweet.text = @"California promises to be a big state.";
    PoliticalTweetStream *stream = [PoliticalTweetStream new];
    stream.tweets = @[defaultTweet];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [stream primaryImageForTweet:defaultTweet withCompletion:^(UIImage *image) {
        XCTAssertNotNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    XCTAssertTrue([[stream auxImageForTweet:defaultTweet] isEqual:[UIImage imageNamed:@"OtherParty"]]);
    XCTAssertTrue([[stream titleForTweetAtIndex:path.row] isEqualToString:defaultTweet.text]);
}

-(void)testPartyAffiliation
{
    PoliticalTweet *defaultTweet = [PoliticalTweet new];
    defaultTweet.text = @"Those Democrats better watch out!";
    PoliticalTweet *secondTweet = [PoliticalTweet new];
    secondTweet.text = @"Those Republicans better watch out!";
    PoliticalTweetStream *stream = [PoliticalTweetStream new];
    stream.tweets = @[defaultTweet, secondTweet];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [stream primaryImageForTweet:defaultTweet withCompletion:^(UIImage *image) {
        XCTAssertNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    UIImage *defaultImage = [stream auxImageForTweet:defaultTweet];
    XCTAssertTrue([defaultImage isEqual:[UIImage imageNamed:@"Democrat"]]);
    XCTAssertTrue([[stream titleForTweetAtIndex:path.row] isEqualToString:defaultTweet.text]);
    
    
    expectation = [self expectationWithDescription:@"Handler called"];
    path = [NSIndexPath indexPathForRow:1 inSection:0];
    [stream primaryImageForTweet:secondTweet withCompletion:^(UIImage *image) {
        XCTAssertNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    XCTAssertTrue([[stream auxImageForTweet:secondTweet] isEqual:[UIImage imageNamed:@"Republican"]]);
    XCTAssertTrue([[stream titleForTweetAtIndex:path.row] isEqualToString:secondTweet.text]);
}

-(void)testPartyName
{
    PoliticalTweet *defaultTweet = [PoliticalTweet new];
    defaultTweet.text = @"Bernie Sanders is the best thing since sliced bread!";
    PoliticalTweetStream *stream = [PoliticalTweetStream new];
    stream.tweets = @[defaultTweet];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [stream primaryImageForTweet:defaultTweet withCompletion:^(UIImage *image) {
        XCTAssertNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    UIImage *defaultImage = [stream auxImageForTweet:defaultTweet];
    XCTAssertTrue([defaultImage isEqual:[UIImage imageNamed:@"Democrat"]]);
    XCTAssertTrue([[stream titleForTweetAtIndex:path.row] isEqualToString:defaultTweet.text]);
}

-(void)testStateParty
{
    PoliticalTweet *defaultTweet = [PoliticalTweet new];
    defaultTweet.text = @"Those Democrats in California better watch out!";
    PoliticalTweetStream *stream = [PoliticalTweetStream new];
    stream.tweets = @[defaultTweet];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [stream primaryImageForTweet:defaultTweet withCompletion:^(UIImage *image) {
        XCTAssertNotNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    UIImage *defaultImage = [stream auxImageForTweet:defaultTweet];
    XCTAssertTrue([defaultImage isEqual:[UIImage imageNamed:@"Democrat"]]);
    XCTAssertTrue([[stream titleForTweetAtIndex:path.row] isEqualToString:defaultTweet.text]);
}
@end

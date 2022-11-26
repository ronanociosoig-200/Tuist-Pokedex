//
//  HNKDiskFetcherTests.m
//  Haneke
//
//  Created by Hermes Pique on 8/20/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <XCTest/XCTest.h>
#import "HNKDiskFetcher.h"
#import "UIImage+HanekeTestUtils.h"
#import "XCTestCase+HanekeTestUtils.h"

@interface HNKDiskFetcherTests : XCTestCase

@end

@implementation HNKDiskFetcherTests {
    HNKDiskFetcher *_sut;
    NSString *_directory;
}

- (void)setUp
{
    [super setUp];
    _directory = NSHomeDirectory();
    _directory = [_directory stringByAppendingPathComponent:@"io.haneke"];
    _directory = [_directory stringByAppendingPathComponent:NSStringFromClass(self.class)];
    [[NSFileManager defaultManager] createDirectoryAtPath:_directory withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)tearDown
{
    NSString *directory = NSHomeDirectory();
    directory = [directory stringByAppendingPathComponent:@"io.haneke"];
    [[NSFileManager defaultManager] removeItemAtPath:directory error:nil];
    [super tearDown];
}

- (void)testKey
{
    NSString *path = [_directory stringByAppendingPathComponent:self.name];
    _sut = [[HNKDiskFetcher alloc] initWithPath:path];

    XCTAssertEqualObjects(_sut.key, path, @"");
}

- (void)testFetchImage_Success
{
    NSString *path = [_directory stringByAppendingPathComponent:self.name];
    _sut = [[HNKDiskFetcher alloc] initWithPath:path];
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor greenColor] size:CGSizeMake(10, 20)];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];
    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageWithSuccess:^(UIImage *resultImage) {
        XCTAssertTrue([resultImage hnk_isEqualToImage:image], @"");
        [expectation fulfill];
    } failure:^(NSError *error) {
        XCTFail(@"Expected to succeed");
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFetchImage_Failure_NSFileReadNoSuchFileError
{
    NSString *path = [_directory stringByAppendingPathComponent:self.name];
    _sut = [[HNKDiskFetcher alloc] initWithPath:path];
    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageWithSuccess:^(UIImage *resultImage) {
        XCTFail(@"Expected to fail");
    } failure:^(NSError *error) {
        XCTAssertEqual(error.code, NSFileReadNoSuchFileError, @"");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFetchImage_Failure_HNKDiskFetcherInvalidDataError
{
    NSString *path = [_directory stringByAppendingPathComponent:self.name];
    _sut = [[HNKDiskFetcher alloc] initWithPath:path];
    NSData *data = [NSData data];
    [data writeToFile:path atomically:YES];
    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageWithSuccess:^(UIImage *resultImage) {
        XCTFail(@"Expected to fail");
    } failure:^(NSError *error) {
        XCTAssertEqualObjects(error.domain, HNKErrorDomain, @"");
        XCTAssertEqual(error.code, HNKErrorDiskFetcherInvalidData, @"");
        XCTAssertNotNil(error.localizedDescription, @"");
        XCTAssertEqualObjects(error.userInfo[NSFilePathErrorKey], path, @"");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testCancelFetch
{
    NSString *path = [_directory stringByAppendingPathComponent:self.name];
    _sut = [[HNKDiskFetcher alloc] initWithPath:path];
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor greenColor] size:CGSizeMake(10, 20)];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];

    [_sut fetchImageWithSuccess:^(UIImage *image) {
        XCTFail(@"Unexpected success");
    } failure:^(NSError *error) {
        XCTFail(@"Unexpected failure");
    }];

    [_sut cancelFetch];

    [self hnk_waitFor:0.1];
}

- (void)testCancelFetch_NoFetch
{
    NSString *path = [_directory stringByAppendingPathComponent:self.name];
    _sut = [[HNKDiskFetcher alloc] initWithPath:path];

    [_sut cancelFetch];
}

@end

//
//  HNKCacheTests.m
//  Haneke
//
//  Created by Hermes Pique on 11/02/14.
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
#import "HNKCache.h"
#import "UIImage+HanekeTestUtils.h"
#import "HNKCache+HanekeTestUtils.h"
#import "XCTestCase+HanekeTestUtils.h"
// #import <OCMock/OCMock.h>

@interface HNKCacheTests : XCTestCase

@end

@implementation HNKCacheTests {
    HNKCache *_sut;
}

- (void)setUp
{
    [super setUp];
    _sut = [[HNKCache alloc] initWithName:@"test"];
}

- (void)tearDown
{
    [_sut removeAllImages];
    [super tearDown];
}

- (void)testInitWithName
{
    HNKCache *cache = [[HNKCache alloc] initWithName:@"test"];
    XCTAssertNotNil(cache, @"");
}

- (void)testSharedCache
{
    HNKCache *cache1 = [HNKCache sharedCache];
    HNKCache *cache2 = [HNKCache sharedCache];
    XCTAssertEqualObjects(cache1, cache2, @"");
}

- (void)testRegisterFormat
{
    HNKCacheFormat *format = [[HNKCacheFormat alloc] initWithName:@"format"];
    [_sut registerFormat:format];
    XCTAssertTrue(format.diskSize == 0, @"");
}

- (void)testFetchImageForFetcher_OpaqueImage
{
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
    id fetcher = [HNKCache fetcherWithKey:@"1" image:image];
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageForFetcher:fetcher formatName:format.name success:^(UIImage *result) {
        CGSize resultSize = result.size;

        XCTAssertNotNil(result, @"");
        XCTAssertTrue(CGSizeEqualToSize(resultSize, format.size), @"");
        XCTAssertFalse(result.hnk_hasAlpha, @"");

        [expectation fulfill];
    } failure:^(NSError *error) {
        XCTFail(@"Expected success");
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFetchImageForFetcher_ImageWithAlpha
{
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor redColor] size:CGSizeMake(10, 10) opaque:NO];
    id fetcher = [HNKCache fetcherWithKey:@"1" image:image];
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageForFetcher:fetcher formatName:format.name success:^(UIImage *result) {
        CGSize resultSize = result.size;

        XCTAssertNotNil(result, @"");
        XCTAssertTrue(CGSizeEqualToSize(resultSize, format.size), @"");
        XCTAssertTrue(result.hnk_hasAlpha, @"");
        [expectation fulfill];

    } failure:^(NSError *error) {
        XCTFail(@"Expected success");
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFetchImageForFetcher_HNKScaleModeAspectFill
{
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor greenColor] size:CGSizeMake(1, 2)];
    id fetcher = [HNKCache fetcherWithKey:@"1" image:image];

    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(10, 10)];
    format.allowUpscaling = YES;
    format.scaleMode = HNKScaleModeAspectFill;
    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageForFetcher:fetcher formatName:format.name success:^(UIImage *result) {
        CGSize resultSize = result.size;

        XCTAssertNotNil(result, @"");
        XCTAssertTrue(CGSizeEqualToSize(resultSize, CGSizeMake(10, 20)), @"");
        [expectation fulfill];

    } failure:^(NSError *error) {
        XCTFail(@"Expected success");
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFetchImageForFetcher_HNKScaleModeFill
{
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
    id fetcher = [HNKCache fetcherWithKey:@"1" image:image];
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageForFetcher:fetcher formatName:format.name success:^(UIImage *result) {
        const CGSize resultSize = result.size;
        XCTAssertTrue(CGSizeEqualToSize(resultSize, format.size), @"");
        [expectation fulfill];
    } failure:^(NSError *error) {
        XCTFail(@"Expected success");

    }];
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFetchImageForFetcher_PreResizeBlock
{
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    UIImage *originalImage = [UIImage hnk_imageWithColor:[UIColor redColor] size:format.size];
    NSString *key = self.name;
    id fetcher = [HNKCache fetcherWithKey:key image:originalImage];
    UIImage *preResizeImage = [UIImage hnk_imageWithColor:[UIColor greenColor] size:format.size];

    format.preResizeBlock = ^UIImage* (NSString *givenKey, UIImage *givenImage) {
        XCTAssertEqualObjects(givenKey, key, @"");
        XCTAssertEqualObjects(givenImage, originalImage, @"");
        return preResizeImage;
    };

    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageForFetcher:fetcher formatName:format.name success:^(UIImage *result) {
        XCTAssertEqualObjects(result, preResizeImage, @"");
        [expectation fulfill];
    } failure:^(NSError *error) {
        XCTFail(@"Expected success");

    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFetchImageForFetcher_PostResizeBlock
{
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    UIImage *originalImage = [UIImage hnk_imageWithColor:[UIColor redColor] size:format.size];
    NSString *key = self.name;
    id fetcher = [HNKCache fetcherWithKey:key image:originalImage];
    UIImage *postResizeImage = [UIImage hnk_imageWithColor:[UIColor greenColor] size:format.size];

    format.postResizeBlock = ^UIImage* (NSString *givenKey, UIImage *givenImage) {
        XCTAssertEqualObjects(givenKey, key, @"");
        XCTAssertEqualObjects(givenImage, originalImage, @"");
        return postResizeImage;
    };

    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageForFetcher:fetcher formatName:format.name success:^(UIImage *result) {
        XCTAssertEqualObjects(result, postResizeImage, @"");
        [expectation fulfill];
    } failure:^(NSError *error) {
        XCTFail(@"Expected success");
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFetchImageForFetcher_MemoryCacheHit
{
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
    id<HNKFetcher> fetcher = [HNKCache fetcherWithKey:@"1" image:image];
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    NSString *formatName = format.name;
    [_sut setImage:image forKey:fetcher.key formatName:formatName];

    BOOL result = [_sut fetchImageForFetcher:fetcher formatName:format.name success:^(UIImage *result) {
        XCTAssertEqualObjects(result, image, @"");
    } failure:^(NSError *error) {
        XCTFail(@"Expected success");
    }];

    XCTAssertTrue(result, @"");
}

- (void)testFetchImageForFetcher_MemoryCacheMiss
{
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
    id<HNKFetcher> fetcher = [HNKCache fetcherWithKey:@"1" image:image];
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    NSString *formatName = format.name;

    BOOL result = [_sut fetchImageForFetcher:fetcher formatName:formatName success:nil failure:nil];

    XCTAssertFalse(result, @"");
}

- (void)testFetchImageForFetcher_PreResizeBlock_MemoryCacheMiss
{
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    UIImage *originalImage = [UIImage hnk_imageWithColor:[UIColor redColor] size:format.size];
    NSString *key = self.name;
    id<HNKFetcher> fetcher = [HNKCache fetcherWithKey:key image:originalImage];

    UIImage *preResizeImage = [UIImage hnk_imageWithColor:[UIColor greenColor] size:format.size];

    format.preResizeBlock = ^UIImage* (NSString *givenKey, UIImage *givenImage) {
        XCTAssertEqualObjects(givenKey, key, @"");
        XCTAssertEqualObjects(givenImage, originalImage, @"");
        return preResizeImage;
    };

    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    BOOL result = [_sut fetchImageForFetcher:fetcher formatName:format.name success:^(UIImage *result) {
        XCTAssertEqualObjects(result, preResizeImage, @"");
        [expectation fulfill];
    } failure:^(NSError *error) {
        XCTFail(@"Expected success");
    }];
    XCTAssertFalse(result, @"");

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFetchImageForFetcher_PostResizeBlock_MemoryCacheMiss
{
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    UIImage *originalImage = [UIImage hnk_imageWithColor:[UIColor redColor] size:format.size];
    NSString *key = self.name;
    id<HNKFetcher> fetcher = [HNKCache fetcherWithKey:key image:originalImage];

    UIImage *postResizeImage = [UIImage hnk_imageWithColor:[UIColor greenColor] size:format.size];

    format.preResizeBlock = ^UIImage* (NSString *givenKey, UIImage *givenImage) {
        XCTAssertEqualObjects(givenKey, key, @"");
        XCTAssertEqualObjects(givenImage, originalImage, @"");
        return postResizeImage;
    };

    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    BOOL result = [_sut fetchImageForFetcher:fetcher formatName:format.name success:^(UIImage *result) {
        XCTAssertEqualObjects(result, postResizeImage, @"");
        [expectation fulfill];
    } failure:^(NSError *error) {
        XCTFail(@"Expected success");
    }];

    XCTAssertFalse(result, @"");
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFetchImageForKey_MemoryCacheHit
{
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    NSString *formatName = format.name;
    NSString *key = self.name;
    [_sut setImage:image forKey:key formatName:formatName];

    BOOL result = [_sut fetchImageForKey:key formatName:formatName success:^(UIImage *result) {
        XCTAssertEqualObjects(result, image, @"");
    } failure:^(NSError *error) {
        XCTFail(@"Expected success");
    }];

    XCTAssertTrue(result, @"");
}

- (void)testFetchImageForKey_MemoryCacheMiss
{
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    NSString *formatName = format.name;
    NSString *key = self.name;

    BOOL result = [_sut fetchImageForKey:key formatName:formatName success:nil failure:nil];

    XCTAssertFalse(result, @"");
}

#pragma mark Removing images

- (void)testRemoveImagesOfFormatNamed_Existing
{
    HNKCacheFormat *format = [[HNKCacheFormat alloc] initWithName:@"format"];
    [_sut registerFormat:format];

    [_sut removeImagesOfFormatNamed:format.name];
    XCTAssertTrue(format.diskSize == 0, @"");
}

- (void)testRemoveImagesOfFormatNamed_Inexisting
{
    HNKCacheFormat *format = [[HNKCacheFormat alloc] initWithName:@"format"];
    [_sut removeImagesOfFormatNamed:format.name];
}

- (void)testRemoveImagesForKey_NoImagesNoFormats
{
    static NSString *key = @"test";
    [_sut removeImagesForKey:key];
}

- (void)testRemoveImagesForKey_One
{
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor whiteColor] size:CGSizeMake(2, 2)];
    NSString *key = self.name;
    [_sut setImage:image forKey:key formatName:format.name];

    [_sut removeImagesForKey:key];

    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageForKey:key formatName:format.name success:^(UIImage *image) {
        XCTFail(@"Expected failure");
    } failure:^(NSError *error) {
        XCTAssertEqual(error.code, HNKErrorImageNotFound, @"");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testRemoveImagesForKey_Two
{
    HNKCacheFormat *format1 = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    HNKCacheFormat *format2 = [_sut registerFormatWithSize:CGSizeMake(2, 2)];
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor whiteColor] size:CGSizeMake(2, 2)];
    NSString *key = self.name;
    [_sut setImage:image forKey:key formatName:format1.name];
    [_sut setImage:image forKey:key formatName:format2.name];

    [_sut removeImagesForKey:key];

    XCTestExpectation *expectation1 = [self expectationWithDescription:self.name];

    [_sut fetchImageForKey:key formatName:format1.name success:^(UIImage *image) {
        XCTFail(@"Expected failure");
    } failure:^(NSError *error) {
        XCTAssertEqual(error.code, HNKErrorImageNotFound, @"");
        [expectation1 fulfill];
    }];

    XCTestExpectation *expectation2 = [self expectationWithDescription:self.name];
    [_sut fetchImageForKey:key formatName:format2.name success:^(UIImage *image) {
        XCTFail(@"Expected failure");
    } failure:^(NSError *error) {
        XCTAssertEqual(error.code, HNKErrorImageNotFound, @"");
        [expectation2 fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testRemoveAllImages_OneFormat
{
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor whiteColor] size:CGSizeMake(2, 2)];
    static NSString *key = @"test";
    [_sut setImage:image forKey:key formatName:format.name];

    [_sut removeAllImages];

    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageForKey:key formatName:format.name success:^(UIImage *image) {
        XCTFail(@"Expected failure");
    } failure:^(NSError *error) {
        XCTAssertEqual(error.code, HNKErrorImageNotFound, @"");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testRemoveAllImages_TwoFormats
{
    HNKCacheFormat *format1 = [[HNKCacheFormat alloc] initWithName:@"format1"];
    format1.size = CGSizeMake(2, 2);
    [_sut registerFormat:format1];

    HNKCacheFormat *format2 = [[HNKCacheFormat alloc] initWithName:@"format2"];
    format2.size = CGSizeMake(10, 10);
    [_sut registerFormat:format2];

    UIImage *image = [UIImage hnk_imageWithColor:[UIColor whiteColor] size:CGSizeMake(20, 20)];
    static NSString *key = @"test";
    [_sut setImage:image forKey:key formatName:format1.name];
    [_sut setImage:image forKey:key formatName:format2.name];

    [_sut removeAllImages];

    XCTestExpectation *expectation1 = [self expectationWithDescription:self.name];

    [_sut fetchImageForKey:key formatName:format1.name success:^(UIImage *image) {
        XCTFail(@"Expected failure");
    } failure:^(NSError *error) {
        XCTAssertEqual(error.code, HNKErrorImageNotFound, @"");
        [expectation1 fulfill];
    }];

    XCTestExpectation *expectation2 = [self expectationWithDescription:self.name];

    [_sut fetchImageForKey:key formatName:format2.name success:^(UIImage *image) {
        XCTFail(@"Expected failure");
    } failure:^(NSError *error) {
        XCTAssertEqual(error.code, HNKErrorImageNotFound, @"");
        [expectation2 fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testSetImage_NilImage
{
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
    id<HNKFetcher> fetcher = [HNKCache fetcherWithKey:@"1" image:image];
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    NSString *formatName = format.name;
    [_sut setImage:image forKey:fetcher.key formatName:formatName];

    // Invalidate object in cache.
    [_sut setImage:nil forKey:fetcher.key formatName:formatName];

    BOOL result = [_sut fetchImageForKey:fetcher.key formatName:formatName success:nil failure:nil];
    XCTAssertFalse(result, @"");

    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageForKey:fetcher.key formatName:format.name success:^(UIImage *image) {
        XCTFail(@"Expected failure");
    } failure:^(NSError *error) {
        XCTAssertEqual(error.code, HNKErrorImageNotFound, @"");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

#pragma mark Notifications

- (void)testNotification_UIApplicationDidReceiveMemoryWarningNotification
{
    HNKCacheFormat *format = [_sut registerFormatWithSize:CGSizeMake(1, 1)];
    UIImage *image = [UIImage hnk_imageWithColor:[UIColor whiteColor] size:CGSizeMake(2, 2)];
    static NSString *key = @"test";
    [_sut setImage:image forKey:key formatName:format.name];

    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:nil];

    XCTestExpectation *expectation = [self expectationWithDescription:self.name];

    [_sut fetchImageForKey:key formatName:format.name success:^(UIImage *image) {
        XCTFail(@"Expected failure");
    } failure:^(NSError *error) {
        XCTAssertEqual(error.code, HNKErrorImageNotFound, @"");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

@end

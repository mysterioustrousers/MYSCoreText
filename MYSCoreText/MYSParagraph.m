//
//  MYSParagraph.m
//  MYSCoreText
//
//  Created by Adam Kirk on 8/17/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


#import "MYSParagraph_Private.h"
#import "MYSPrivate.h"


@interface MYSParagraph ()
@property (nonatomic, strong, readwrite) NSAttributedString *attributedString;
@end


@implementation MYSParagraph

- (id)initWithAttributedString:(NSAttributedString *)attributedString range:(NSRange)range
{
    self = [super init];   if (self) {
        _attributedString   = attributedString;
        _range              = range;
    }
    return self;
}


#pragma mark - Text

- (NSAttributedString *)attributedString
{
    return [_attributedString attributedSubstringFromRange:_range];
}

- (NSUInteger)indexOfFirstCharacter
{
    return MYSNSRangeStartIndex(_range);
}

- (NSUInteger)indexOfLastCharacter
{
    return NSMaxRange(_range);
}


@end

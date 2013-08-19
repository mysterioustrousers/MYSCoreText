//
//  MYSWord.m
//  MYSCoreText
//
//  Created by Adam Kirk on 8/17/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSWord_Private.h"
#import "MYSPrivate.h"


@interface MYSWord ()
@property (nonatomic, strong, readwrite) NSAttributedString *attributedString;
@end


@implementation MYSWord

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

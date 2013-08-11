//
//  MYSGlyph_Private.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/10/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSGlyph.h"

@interface MYSGlyph ()
@property (nonatomic, strong, readwrite) NSDictionary *attributes;
@property (nonatomic, assign, readwrite) NSUInteger   index;
@property (nonatomic, assign, readwrite) CGPoint      position;
@property (nonatomic, assign, readwrite) CGSize       advance;
- (id)initWithCGGlyph:(CGGlyph)glyph attributedString:(NSAttributedString *)attributedString;
@end

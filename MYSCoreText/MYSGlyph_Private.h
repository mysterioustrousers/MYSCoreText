//
//  MYSGlyph_Private.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/10/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSGlyph.h"

@interface MYSGlyph ()
@property (nonatomic, assign, readwrite) MYSRun            *run;
@property (nonatomic, strong, readwrite) NSDictionary      *attributes;
@property (nonatomic, assign, readwrite) NSUInteger        index;
@property (nonatomic, assign, readwrite) CGPoint           position;
@property (nonatomic, assign, readwrite) CGSize            advance;
@property (nonatomic, assign, readwrite) CGFloat           ascent;
@property (nonatomic, assign, readwrite) CGFloat           descent;
@property (nonatomic, assign, readwrite) CGFloat           leading;
@property (nonatomic, assign, readwrite) CGFloat           lineHeight;
@property (nonatomic, assign, readwrite) CGAffineTransform textMatrix;
- (id)initWithCGGlyph:(CGGlyph)glyph attributedString:(NSAttributedString *)attributedString;
@end

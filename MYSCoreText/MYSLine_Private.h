//
//  MYSLine_Private.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/7/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSLine.h"

@interface MYSLine ()
@property (nonatomic, copy,   readwrite) NSAttributedString *attributedString;
@property (nonatomic, assign, readwrite) CGPoint            origin;                 // TODO: use CTLineGetPenOffsetForFlush?
- (id)initWithCTLine:(CTLineRef)lineRef attributedString:(NSAttributedString *)attributedString;
@end
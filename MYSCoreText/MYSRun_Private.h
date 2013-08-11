//
//  MYSRun_Private.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/9/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSRun.h"

@interface MYSRun ()
@property (nonatomic, copy, readwrite) NSArray *glyphs;
- (id)initWithCTRun:(CTRunRef)runRef attributedString:(NSAttributedString *)attributedString;
@end
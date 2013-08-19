//
//  MYSParagraph_Private.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/17/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


#import "MYSParagraph.h"
#import "MYSFrame.h"


@interface MYSParagraph ()
@property (nonatomic, assign) MYSFrame *frame;
// the entire attributed string.
- (id)initWithAttributedString:(NSAttributedString *)attributedString range:(NSRange)range;
@end
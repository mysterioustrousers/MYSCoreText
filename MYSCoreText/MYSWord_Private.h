//
//  MYSWord_Private.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/17/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSWord.h"
#import "MYSLine.h"


@interface MYSWord ()
@property (nonatomic, assign) MYSLine *line;
// the entire attributed string.
- (id)initWithAttributedString:(NSAttributedString *)attributedString range:(NSRange)range;
@end
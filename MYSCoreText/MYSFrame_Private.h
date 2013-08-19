//
//  MYSFrame_Private.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/6/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSFrame.h"

@interface MYSFrame ()
@property (nonatomic, assign, readwrite) MYSFramesetter *framesetter;
- (id)initWithCTFrame:(CTFrameRef)frame attributedString:(NSAttributedString *)attributedString;
@end
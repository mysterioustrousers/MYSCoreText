//
//  MYSTypesetter-Private.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/6/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//
#import "MYSTypesetter.h"
#import "MYSFramesetter.h"


@interface MYSTypesetter ()
@property (nonatomic, assign, readwrite) MYSFramesetter *framesetter;
- (id)initWithCTTypesetter:(CTTypesetterRef)typesetterRef attributedString:(NSAttributedString *)attributedString;
@end
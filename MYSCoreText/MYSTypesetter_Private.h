//
//  MYSTypesetter-Private.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/6/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//
#import "MYSTypesetter.h"

@interface MYSTypesetter ()
- (id)initWithCTTypesetter:(CTTypesetterRef)typesetterRef attributedString:(NSAttributedString *)attributedString;
@end
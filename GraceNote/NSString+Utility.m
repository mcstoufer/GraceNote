//
//  NSString+Utility.m
//  permutate
//
//  Created by Martin Stoufer on 5/6/16.
//  Copyright © 2016 Martin Stoufer. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

-(NSMutableArray *)split
{
    NSMutableArray *wordArr = [NSMutableArray new];
    [self enumerateSubstringsInRange:[self rangeOfString:self]
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              [wordArr addObject:substring];
                          }];
    return wordArr;
}

-(NSMutableArray *)splitWords
{
    NSMutableArray *wordArr = [NSMutableArray new];
    [self enumerateSubstringsInRange:[self rangeOfString:self]
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              [wordArr addObject:substring];
                          }];
    return wordArr;
}
@end

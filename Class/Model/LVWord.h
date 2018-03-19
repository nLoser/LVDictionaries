//
//  LVWord.h
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVWord : NSObject

@end

@interface LVWordDetail : LVWord
@property (nonatomic) NSString * word;
@property (nonatomic) NSString * symbol;
@property (nonatomic) NSString * explian;
@property (nonatomic) int lookupNum;
@end

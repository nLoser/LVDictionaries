//
//  LVView.h
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LVWordDetail;

@interface LVView : UIView

@end

@interface LVWordDetailView : UIScrollView
@property (nonatomic) LVWordDetail * wordDetail;
@end

@interface LVHistoryCell : UITableViewCell
@property (nonatomic) LVWordDetail * wordDetail;
@end

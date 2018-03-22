//
//  LVView.m
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LVView.h"
#import "LVWord.h"
#import "Global.h"
#import "UIView+GetRect.h"
#import "NSString+LVAdd.h"

@implementation LVView

@end

@interface LVWordDetailView() {
    BOOL _load;
}
@property (nonatomic, strong) UILabel * wordLabel;
@property (nonatomic, strong) UILabel * symbolLabel;
@property (nonatomic, strong) UITextView * explainView;
@end

@implementation LVWordDetailView

- (void)setWordDetail:(LVWordDetail *)wordDetail {
    if (!_load) {
        [self addSubview:self.wordLabel];
        [self addSubview:self.symbolLabel];
        [self addSubview:self.explainView];
    }
    
    _wordDetail = wordDetail;
    
    self.wordLabel.text = wordDetail.word;
    self.symbolLabel.text = wordDetail.symbol;
    NSString * looknum = @"";
    if (wordDetail.lookupNum > 1) {
        looknum = [NSString stringWithFormat:@"(已查询%d次)",wordDetail.lookupNum];
    }
    
    NSString * string = [NSString stringWithFormat:@"%@%@",wordDetail.explian,looknum];
    CGFloat height = [string heightWithConstrainSize:CGSizeMake(self.lvWidth, CGFLOAT_MAX) attribute:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    height += 22;
    self.explainView.text = string;
    self.explainView.lvHeight = height;
    self.contentSize = CGSizeMake(self.lvWidth, 70+height+10);
}

- (UILabel *)wordLabel {
    if (!_wordLabel) {
        _wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.lvWidth, 43)];
        _wordLabel.textColor = Color2;
        _wordLabel.font = [UIFont boldSystemFontOfSize:38];
    }
    return _wordLabel;
}

- (UILabel *)symbolLabel {
    if (!_symbolLabel) {
        _symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _wordLabel.lvBottom+5, self.lvWidth, 30)];
        _symbolLabel.textColor = Color2;
        _symbolLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _symbolLabel;
}

- (UITextView *)explainView {
    if (!_explainView) {
        _explainView = [[UITextView alloc] initWithFrame:CGRectMake(0, _symbolLabel.lvBottom + 5, self.lvWidth, 0)];
        _explainView.textColor = Color2;
        _explainView.scrollEnabled = NO;
        _explainView.backgroundColor = [UIColor whiteColor];
        _explainView.font = [UIFont boldSystemFontOfSize:20];
        _explainView.showsVerticalScrollIndicator = NO;
        _explainView.showsHorizontalScrollIndicator = NO;
    }
    return _explainView;
}

@end

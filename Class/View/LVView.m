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

@implementation LVView

@end

@interface LVWordDetailView()
@property (nonatomic, strong) UILabel * wordLabel;
@property (nonatomic, strong) UILabel * symbolLabel;
@property (nonatomic, strong) UITextView * explainView;
@end

@implementation LVWordDetailView

- (void)setWordDetail:(LVWordDetail *)wordDetail {
    _wordDetail = wordDetail;
    
    [self addSubview:self.wordLabel];
    [self addSubview:self.symbolLabel];
    [self addSubview:self.explainView];
    
    self.wordLabel.text = wordDetail.word;
    self.symbolLabel.text = wordDetail.symbol;
    self.explainView.text = wordDetail.explian;
    
    CGFloat height = [wordDetail.explian boundingRectWithSize:CGSizeMake(self.lvWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} context:nil].size.height;
    self.explainView.lvHeight = height;
    self.contentSize = CGSizeMake(self.lvWidth, 70+height+10);
}

- (UILabel *)wordLabel {
    if (!_wordLabel) {
        _wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.lvWidth, 40)];
        _wordLabel.textColor = Color2;
        _wordLabel.font = [UIFont boldSystemFontOfSize:40];
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
        _explainView = [[UITextView alloc] initWithFrame:CGRectMake(0, _symbolLabel.lvBottom + 5, self.lvWidth, 40)];
        _explainView.textColor = Color2;
        _explainView.scrollEnabled = NO;
        _explainView.backgroundColor = BgColor;
        _explainView.font = [UIFont boldSystemFontOfSize:20];
    }
    return _explainView;
}

@end
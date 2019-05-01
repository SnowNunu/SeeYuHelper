//
//  NSMutableAttributedString+SYMoment.m
//  WeChat
//
//  Created by senba on 2018/1/22.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "NSMutableAttributedString+SYMoment.h"
#import "SYMomentHelper.h"
#import "SYEmoticonManager.h"
@implementation NSMutableAttributedString (SYMoment)

- (void)sy_regexContentWithWithEmojiImageFontSize:(CGFloat)fontSize{
    /// 高亮背景
    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 0;
    border.insets = UIEdgeInsetsMake(0, -1, 0, -1);
    border.fillColor = SYMomentTextHighlightBackgroundColor;
    
    /// 匹配链接
    NSArray<NSTextCheckingResult *> *linkUrlResults = [[SYMomentHelper regexLinkUrl] matchesInString:self.string options:kNilOptions range:self.yy_rangeOfAll];
    for (NSTextCheckingResult *link in linkUrlResults) {
        if (link.range.location == NSNotFound && link.range.length <= 1) continue;
        if ([self yy_attribute:YYTextHighlightAttributeName atIndex:link.range.location] == nil) {
            [self yy_setColor:SYMomentContentUrlTextColor range:link.range];
            /// 匹配userInfo
            /// 点击高亮
            YYTextHighlight *highlight = [YYTextHighlight new];
            // 将用户数据带出去
            highlight.userInfo = @{SYMomentLinkUrlKey:[self.string substringWithRange:link.range]};
            [highlight setBackgroundBorder:border];
            [self yy_setTextHighlight:highlight range:link.range];
        }
    }
    
    
    /// 匹配电话号码
    NSArray<NSTextCheckingResult *> *phoneResults = [[SYMomentHelper regexPhoneNumber] matchesInString:self.string options:kNilOptions range:self.string.rangeOfAll];
    
    for (NSTextCheckingResult *phone in phoneResults) {
        if (phone.range.location == NSNotFound && phone.range.length <= 1) continue;
        if ([self yy_attribute:YYTextHighlightAttributeName atIndex:phone.range.location] == nil) {
            [self yy_setColor:SYMomentContentUrlTextColor range:phone.range];
            /// 匹配userInfo
            /// 点击高亮
            YYTextHighlight *highlight = [YYTextHighlight new];
            // 将用户数据带出去
            highlight.userInfo = @{SYMomentPhoneNumberKey:[self.string substringWithRange:phone.range]};
            [highlight setBackgroundBorder:border];
            [self yy_setTextHighlight:highlight range:phone.range];
        }
    }
    //// 匹配表情
    NSArray<NSTextCheckingResult *> *emoticonResults = [[SYEmoticonManager regexEmoticon] matchesInString:self.string options:kNilOptions range:self.yy_rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([self yy_attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([self yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [self.string substringWithRange:range];
        NSString *imagePath = [SYEmoticonManager emoticonDic][emoString];
        UIImage *image = [SYEmoticonManager imageWithPath:imagePath];
        if (!image) continue;
        NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:fontSize];
        [self replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
}
@end

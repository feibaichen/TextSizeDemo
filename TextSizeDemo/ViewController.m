//
//  ViewController.m
//  TextSizeDemo
//
//  Created by Karl on 2018/6/11.
//  Copyright © 2018 Derek. All rights reserved.
//

#import "ViewController.h"
#import "NSString+size.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self text1];
    [self text2];

}

-(void)text1{
    NSString *str = @"这里需要给定文本框的宽度以及字体大小，就能计算出文本框需要多少高度,这时候再来设置文本框的大小就OK了。还有一种情况，文本内容少，不需要换行，但是需要计算文本会占用多少宽度例如：一排按钮，如果每个按钮的宽度一样，那按钮标题较长的按钮，跟其他按钮之间的空格看起来就小了，甚至出现“...”，这样很不美观。";
    
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineSpacing = 1;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:str
                                                                                       attributes:@{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    
   CGFloat hight = [self getTextHeightWithStr:str withWidth:[UIScreen mainScreen].bounds.size.width-40 withLineSpacing:1 withFont:17];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, [UIScreen mainScreen].bounds.size.width-40,
                                                            hight)];//计算差
    label2.attributedText = attributeString;
    label2.textAlignment = NSTextAlignmentLeft;
    label2.numberOfLines = 0;
    label2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:label2];
   
}
-(void)text2{
    
    
    NSString *str = @"这里需要给定文本框的宽度以及字体大小，就能计算出文本框需要多少高度,这时候再来设置文本框的大小就OK了。还有一种情况，文本内容少，不需要换行，但是需要计算文本会占用多少宽度例如：一排按钮，如果每个按钮的宽度一样，那按钮标题较长的按钮，跟其他按钮之间的空格看起来就小了，甚至出现“...”，这样很不美观。这里需要给定文本框的宽度以及字体大小，就能计算出文本框需要多少高度,这时候再来设置文本框的大小就OK了。还有一种情况，文本内容少，不需要换行，但是需要计算文本会占用多少";
    
    // 富文本格式
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.lineSpacing = 1.0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paraStyle}  range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:0.0] range:NSMakeRange(0, attributedString.length)];
    
    //富文本高度计算方法
    CGSize lblSize = [attributedString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    double describeheight = ceil(lblSize.height )  ;//为防止文字显示不全，采用向上取整函数获取最终文本高度
    
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, [UIScreen mainScreen].bounds.size.width-40,
                                                                describeheight)];//有误差
    label2.attributedText = attributedString;
    label2.textAlignment = NSTextAlignmentLeft;
    label2.numberOfLines = 0;
    label2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:label2];
}


-(CGFloat)getTextHeightWithStr:(NSString *)str
                     withWidth:(CGFloat)width
               withLineSpacing:(CGFloat)lineSpacing
                      withFont:(CGFloat)font
{
    if (!str || str.length == 0) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineSpacing = lineSpacing;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:str
                                                                                       attributes:@{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                context:nil];
    
    if ((rect.size.height - [UIFont systemFontOfSize:font].lineHeight)  <= lineSpacing){
        if ([self containChinese:str]){
            rect.size.height -= lineSpacing;
        }
    }
    return rect.size.height;
}
//判断是否包含中文
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}
@end

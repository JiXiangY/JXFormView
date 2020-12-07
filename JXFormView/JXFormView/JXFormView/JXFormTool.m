//
//  UIColor+level.m
//  JXFormView
//
//  Created by 于吉祥 on 2020/12/7.
//

#import "JXFormTool.h"

@implementation JXFormIndex
+ (JXFormIndex *)indexWithRow:(NSInteger)row column:(NSInteger)column
{
    JXFormIndex *model = [[JXFormIndex alloc]init];
    model.row = row;
    model.column = column;
    return model;
}

- (BOOL)isEqualRow:(NSInteger)row column:(NSInteger)column
{
    return self.row == row && self.column == column;
}

- (BOOL)isEqualFormIndex:(JXFormIndex *)otherIndex
{
    return self.row == otherIndex.row && self.column == otherIndex.column;
}



@end
@implementation JXFormTool

@end

@implementation JXFormCellModel

@end

@implementation JXFormLineModel

+ (JXFormLineModel *)createFormLineModelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColer:(UIColor *)lineColor  lineWidth:(CGFloat)lineWidth linewidthLevel:(NSInteger)linewidthLevel lineColorLevel:(NSInteger)lineColorLevel
{
    JXFormLineModel *model = [[JXFormLineModel alloc]init];
    model.startPoint = startPoint;
    model.endPoint  = endPoint;
    model.lineColor = lineColor;
    model.lineWidth = lineWidth;
    model.linewidthLevel = linewidthLevel;
    model.lineColorLevel = lineColorLevel;
    model.isDraw = YES;
    return model;
}

@end

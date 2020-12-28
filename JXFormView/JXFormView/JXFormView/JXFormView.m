//
//  JXFormView.m
//  SouFun
//
//  Created by 于吉祥 on 2020/12/3.
//  Copyright © 2020 房天下 Fang.com. All rights reserved.
//

#import "JXFormView.h"
typedef NS_ENUM(NSInteger, FormLineType) {
    LineVertical,  // 垂直
    LineHorizontal // 水平
};
typedef NS_ENUM(NSInteger, FormLinePosition) {
    LineTop,   ///< 上
    LineLeft,  ///< 左
    LineBottom,///< 下
    LineRight, ///< 右
};
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)
#define Tag 155158
#define layerTag 100000

@interface JXFormView()

@property (nonatomic,weak  ) id<JXFormViewDelegate> delegate;
@property (nonatomic,strong) UIView *lineBgView;
@property (nonatomic,assign) NSInteger rows;
@property (nonatomic,assign) NSInteger columns;
@end
@implementation JXFormView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (JXFormView *)drawListWithRect:(CGRect)rect numberOfRow:(NSInteger)rows numberOfcolumn:(NSInteger)columns  delegate:(id<JXFormViewDelegate>)delegate
{
    JXFormView *form = [[JXFormView alloc]initWithFrame:rect];

    form.rows = rows;
    form.columns = columns;
    form.delegate = delegate;
  
    return form;
}

- (void)layoutSubviews
{
    [self  createCellView];
    [self  drawLineView];
}

- (void)createCellView
{
    CGFloat x = 0;
    CGFloat y = 0;

    
    for (NSInteger i = 0; i < self.rows; i++) {
        for (NSInteger j = 0; j < self.columns; j++) {
            BOOL isCreate = YES;
            JXFormIndex *formIndex = [JXFormIndex indexWithRow:i column:j];
            //列宽
            CGFloat width = 0;
            if ([self.delegate respondsToSelector:@selector(formView:widthForFormIndex:)]) {
                width = [self.delegate formView:self widthForFormIndex:formIndex];
            }
            //行高
            CGFloat height = 0;
            if ([self.delegate respondsToSelector:@selector(formView:heightForFormIndex:)]) {
                height = [self.delegate formView:self heightForFormIndex:formIndex];
            }
            CGRect frame = (CGRect){x, y , width, height};
            if ([self.delegate respondsToSelector:@selector(mergeCellArrformView:)]) {
                NSMutableArray *mArr = [self.delegate mergeCellArrformView:self];
                for (NSDictionary *dic in mArr) {
                    JXFormIndex *startIndex = [dic objectForKey:@"start"];
                    JXFormIndex *endIndex = [dic objectForKey:@"end"];
                    if (formIndex.row>=startIndex.row && formIndex.row <= endIndex.row && formIndex.column>=startIndex.column && formIndex.column<=endIndex.column) {
                        if (formIndex.row == startIndex.row && formIndex.column == startIndex.column) {
                            //根据左上角坐标创建view
                            CGSize mergeSize = [self getMergeSizeWithStartIndex:startIndex endIndex:endIndex];
                            frame = (CGRect){x, y , mergeSize.width, mergeSize.height};
                            
                        }else{
                            //其他单元格包含但不是左上角不创建
                            isCreate = NO;
                        }
                        break;;
                    }
                }
               
            }
            if (isCreate == YES) {
                UIView *cellView;
                if ([self.delegate respondsToSelector:@selector(formView:cellViewFrame:forFormIndex:)]) {
                    cellView = [self.delegate formView:self cellViewFrame:frame forFormIndex:formIndex];
                }
                [self addSubview:cellView];
            }
           
          
            x = x + width;
            if (j == self.columns - 1) {
                x = 0;
                y = y + height;
            }
        }
    }
}

///根据起始点 获取 合并单元格的大小
- (CGSize)getMergeSizeWithStartIndex:(JXFormIndex *)startIndex endIndex:(JXFormIndex *)endIndex
{

    CGFloat sumHeight = 0;
    if (endIndex.row - startIndex.row == 0) {
        sumHeight = [self.delegate formView:self heightForFormIndex:[JXFormIndex indexWithRow:startIndex.row column:startIndex.column]];
    }else{
        for (int i = 0; i <= endIndex.row - startIndex.row; i++) {
            CGFloat height = 0;
            if ([self.delegate respondsToSelector:@selector(formView:heightForFormIndex:)]) {
                height = [self.delegate formView:self heightForFormIndex:[JXFormIndex indexWithRow:startIndex.row+i column:startIndex.column]];
            }
            sumHeight += height;
        }
    }
    
    
    CGFloat sumWidth = 0;
    if (endIndex.column - startIndex.column == 0) {
        sumWidth = [self.delegate formView:self widthForFormIndex:[JXFormIndex indexWithRow:startIndex.row column:startIndex.column]];
    }else{
        for (int i = 0; i <= endIndex.column - startIndex.column; i++) {
            CGFloat width = 0;
            if ([self.delegate respondsToSelector:@selector(formView:widthForFormIndex:)]) {
                width = [self.delegate formView:self widthForFormIndex:[JXFormIndex indexWithRow:startIndex.row column:startIndex.column+i]];
            }
            sumWidth += width;
        }
    }
    
    
    return CGSizeMake(sumWidth, sumHeight);
}


- (void)drawLineView
{
    //线数组
    CGFloat x = 0;
    CGFloat y = 0;
    NSMutableArray *lineVerArray = [NSMutableArray array];// 垂直线数组
    for (NSInteger i = 0; i < self.rows; i++) {
        NSMutableArray *lineRowsVerArray = [NSMutableArray array];// 垂直线行数组 从左向右排
        for (NSInteger j = 0; j < self.columns; j++) {
            JXFormIndex *formIndex = [JXFormIndex indexWithRow:i column:j];
            CGFloat width = 0;
            if ([self.delegate respondsToSelector:@selector(formView:widthForFormIndex:)]) {
                width = [self.delegate formView:self widthForFormIndex:formIndex];
            }
            CGFloat height = 0;
            if ([self.delegate respondsToSelector:@selector(formView:heightForFormIndex:)]) {
                height = [self.delegate formView:self heightForFormIndex:formIndex];
            }

            JXFormCellModel *CellModel ;
            if ([self.delegate respondsToSelector:@selector(formView:cellModelForFormIndex:)]) {
                CellModel = [self.delegate formView:self cellModelForFormIndex:formIndex];
            }
            //左竖线
            if (j == 0 && lineRowsVerArray.count == 0) {
                JXFormLineModel *leftlineVer = [JXFormLineModel createFormLineModelWithStartPoint:CGPointMake(x, y)
                                                                 endPoint:CGPointMake(x, y+height)
                                                                lineColer:CellModel.lineColer
                                                                lineWidth:CellModel.lineWidth
                                                                linewidthLevel:CellModel.linewidthLevel
                                                                lineColorLevel:CellModel.lineColorLevel];
                [lineRowsVerArray addObject:leftlineVer];
                leftlineVer.isDraw = [self judgeLineIsDrowWithFormIndex:formIndex FormLinePosition:LineLeft];
            }else{
                JXFormLineModel *lastLine = lineRowsVerArray.lastObject;
                if (lastLine.linewidthLevel < CellModel.linewidthLevel) {
                    lastLine.lineWidth = CellModel.lineWidth;
                    lastLine.lineWidth = CellModel.linewidthLevel;
                }
                if (lastLine.lineColorLevel < CellModel.lineColorLevel) {
                    lastLine.lineColor = CellModel.lineColer;
                    lastLine.lineColorLevel = CellModel.lineColorLevel;
                }
            }
            //右竖线
            JXFormLineModel *rightlineVer = [JXFormLineModel createFormLineModelWithStartPoint:CGPointMake(x+width, y)
                                                            endPoint:CGPointMake(x+width, y+height)
                                                            lineColer:CellModel.lineColer
                                                            lineWidth:CellModel.lineWidth
                                                            linewidthLevel:CellModel.linewidthLevel
                                                             lineColorLevel:CellModel.lineColorLevel];
            rightlineVer.isDraw = [self judgeLineIsDrowWithFormIndex:formIndex FormLinePosition:LineRight];
            
            [lineRowsVerArray addObject:rightlineVer];
            x = x + width;
            if (j == self.columns - 1) {
                x = 0;
                y = y + height;
            }
        }
        [lineVerArray addObject:lineRowsVerArray];
    }
    
    x = 0;
    y = 0;
    NSMutableArray *lineHorArray = [NSMutableArray array];// 横线数组
    for (NSInteger j = 0; j < self.columns; j++) {
        NSMutableArray *lineColumnHorArray = [NSMutableArray array];// 横线列数组 从上向下排
        for (NSInteger i = 0; i < self.rows; i++) {
            JXFormIndex *formIndex = [JXFormIndex indexWithRow:i column:j];
            // 线宽
            CGFloat width = 0;
            if ([self.delegate respondsToSelector:@selector(formView:widthForFormIndex:)]) {
                width = [self.delegate formView:self widthForFormIndex:formIndex];
            }
            CGFloat height = 0;
            if ([self.delegate respondsToSelector:@selector(formView:heightForFormIndex:)]) {
                height = [self.delegate formView:self heightForFormIndex:formIndex];
            }
            JXFormCellModel *CellModel ;
            if ([self.delegate respondsToSelector:@selector(formView:cellModelForFormIndex:)]) {
                CellModel = [self.delegate formView:self cellModelForFormIndex:formIndex];
            }
            //上横线
            if (i == 0 && lineColumnHorArray.count == 0) {
                JXFormLineModel *topLineHor = [JXFormLineModel createFormLineModelWithStartPoint:CGPointMake(x, y)
                                                                 endPoint:CGPointMake(x+width, y)
                                                                lineColer:CellModel.lineColer
                                                                lineWidth:CellModel.lineWidth
                                                                linewidthLevel:CellModel.linewidthLevel
                                                                lineColorLevel:CellModel.lineColorLevel];
                [lineColumnHorArray addObject:topLineHor];
                topLineHor.isDraw = [self judgeLineIsDrowWithFormIndex:formIndex FormLinePosition:LineTop];
            }else{
                JXFormLineModel *lastLine = lineColumnHorArray.lastObject;
                if (lastLine.linewidthLevel < CellModel.linewidthLevel) {
                    lastLine.lineWidth = CellModel.lineWidth;
                    lastLine.lineWidth = CellModel.linewidthLevel;
                }
                if (lastLine.lineColorLevel < CellModel.lineColorLevel) {
                    lastLine.lineColor = CellModel.lineColer;
                    lastLine.lineColorLevel = CellModel.lineColorLevel;
                }
            }
            //下横线
            JXFormLineModel *bottomlineHor = [JXFormLineModel createFormLineModelWithStartPoint:CGPointMake(x, y+height)
                                                            endPoint:CGPointMake(x+width, y+height)
                                                            lineColer:CellModel.lineColer
                                                            lineWidth:CellModel.lineWidth
                                                            linewidthLevel:CellModel.linewidthLevel
                                                             lineColorLevel:CellModel.lineColorLevel];
            [lineColumnHorArray addObject:bottomlineHor];
            bottomlineHor.isDraw = [self judgeLineIsDrowWithFormIndex:formIndex FormLinePosition:LineBottom];
            y = y + height;
            if (i == self.rows - 1) {
                y = 0;
                x = x + width;
            }
        }
        [lineHorArray addObject:lineColumnHorArray];
    }
    
    UIView *lineBgView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:lineBgView];
    lineBgView.userInteractionEnabled = NO;
    self.lineBgView = lineBgView;
    //开始画线
    //画竖线
    for (NSArray *rowVerArr in lineVerArray){
        for (JXFormLineModel *lineModel in rowVerArr) {
            if (lineModel.isDraw == NO) continue;
            [self drawLineWithFrame:CGRectMake(lineModel.startPoint.x, lineModel.startPoint.y, 1, lineModel.endPoint.y-lineModel.startPoint.y) lineType:LineVertical color:lineModel.lineColor lineWidth:lineModel.lineWidth];
        }
    }
    //画横线
    for (NSArray *columnsHorArr in lineHorArray){
        for (JXFormLineModel *lineModel in columnsHorArr) {
            if (lineModel.isDraw == NO) continue;
            [self drawLineWithFrame:CGRectMake(lineModel.startPoint.x, lineModel.startPoint.y, lineModel.endPoint.x-lineModel.startPoint.x, 1) lineType:LineHorizontal color:lineModel.lineColor lineWidth:lineModel.lineWidth];
        }
    }
}


- (BOOL)judgeLineIsDrowWithFormIndex:(JXFormIndex *)formIndex  FormLinePosition:(FormLinePosition)position
{
    if ([self.delegate respondsToSelector:@selector(mergeCellArrformView:)]) {
        NSMutableArray *mArr = [self.delegate mergeCellArrformView:self];
        for (NSDictionary *dic in mArr) {
            JXFormIndex *startIndex = [dic objectForKey:@"start"];
            JXFormIndex *endIndex = [dic objectForKey:@"end"];
            if (formIndex.row>=startIndex.row && formIndex.row <= endIndex.row && formIndex.column>=startIndex.column && formIndex.column<=endIndex.column) {
                switch (position) {
                    case LineTop:
                        if (formIndex.row == startIndex.row) {
                            return YES;
                        }
                        return NO;
                        break;
                  
                    case LineBottom:
                        if (formIndex.row == endIndex.row) {
                            return YES;
                        }
                        return NO;
                        break;
                    case LineLeft:
                        if (formIndex.column == startIndex.column) {
                            return YES;
                        }
                        return NO;
                        break;
                    case LineRight:
                        if (formIndex.column == endIndex.column) {
                            return YES;
                        }
                        return NO;
                        break;
                        
                    default:
                        break;
                }
                break;
            }
        }
    }
    return  YES;
}


- (void)drawLineWithFrame:(CGRect)frame lineType:(FormLineType)lineType color:(UIColor *)color lineWidth:(CGFloat)lineWidth {
    
    // 创建贝塞尔曲线
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    
    // 线宽
    linePath.lineWidth = lineWidth;
    
    // 起点
    [linePath moveToPoint:CGPointMake(0, 0)];
    
    // 重点：判断是水平方向还是垂直方向
    [linePath addLineToPoint: lineType == LineHorizontal ? CGPointMake(frame.size.width, 0) : CGPointMake(0, frame.size.height)];
    
    // 创建CAShapeLayer
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    // 颜色
    lineLayer.strokeColor = color.CGColor;
    // 宽度
    lineLayer.lineWidth = lineWidth;
    
    // frame
    lineLayer.frame = frame;
    
    // 路径
    lineLayer.path = linePath.CGPath;
    
    // 添加到layer上
    [self.lineBgView.layer addSublayer:lineLayer];
    
}

@end



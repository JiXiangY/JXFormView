//
//  JXFormTool.h
//  JXFormView
//
//  Created by 于吉祥 on 2020/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
struct FormIndex {
    int row;//行
    int column;//列
};
typedef struct CG_BOXABLE FormIndex FormIndex;
CG_INLINE FormIndex FormIndexMake(int row, int column)
{
    FormIndex index; index.row = row; index.column = column; return index;
}
@interface JXFormTool : NSObject

@end

@interface JXFormIndex: NSObject
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) NSInteger column;
+ (JXFormIndex *)indexWithRow:(NSInteger)row column:(NSInteger)column;
- (BOOL)isEqualRow:(NSInteger)row column:(NSInteger)column;
- (BOOL)isEqualFormIndex:(JXFormIndex *)otherIndex;

@end


@interface JXFormCellModel : NSObject
@property (nonatomic, strong) UIColor *lineColer;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) NSInteger linewidthLevel;///<等级 数字大的会覆盖小的
@property (nonatomic, assign) NSInteger lineColorLevel;///<等级 数字大的会覆盖小的
@property (nonatomic, strong) JXFormIndex *index;///<位置

@end

@interface JXFormLineModel : NSObject

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) NSInteger linewidthLevel;///<等级 数字大的会覆盖小的
@property (nonatomic, assign) NSInteger lineColorLevel;///<等级 数字大的会覆盖小的
@property (nonatomic, assign) BOOL isDraw;///<是否绘制

+ (JXFormLineModel *)createFormLineModelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColer:(UIColor *)lineColor  lineWidth:(CGFloat)lineWidth linewidthLevel:(NSInteger)linewidthLevel lineColorLevel:(NSInteger)lineColorLevel;
@end


NS_ASSUME_NONNULL_END

//
//  JXFormView.h
//  SouFun
//
//  Created by 于吉祥 on 2020/12/3.
//  Copyright © 2020 房天下 Fang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXFormTool.h"

@class JXFormView;
@protocol JXFormViewDelegate <NSObject>

/// 设置表格label属性
/// @param formView view
/// @param frame 用于设置的View的frame (可设置label button等 )
/// @param formIndex 表格位置
- (UIView *_Nullable)formView:(JXFormView *_Nullable)formView cellViewFrame:(CGRect)frame forFormIndex:(JXFormIndex *_Nullable)formIndex;

///单元格高度(一行要同高)
- (CGFloat)formView:(JXFormView *_Nullable)formView heightForFormIndex:(JXFormIndex *_Nullable)formIndex;
///单元格宽度(一列要同宽)
- (CGFloat)formView:(JXFormView *_Nullable)formView widthForFormIndex:(JXFormIndex *_Nullable)formIndex;

/// 设置单元格格式
- (JXFormCellModel *_Nullable)formView:(JXFormView *_Nullable)formView cellModelForFormIndex:(JXFormIndex *_Nullable)formIndex;


///合并单元格 数组格式
/// [{"start":JXFormIndex,"end":JXFormIndex},{"start":[JXFormIndex indexWithRow:i column:j],"end":[JXFormIndex indexWithRow:i column:j]}]
///start为左上角的单元格位置 end 为右下角 单元格位置
///合并的单元格 会根据左上角的位置来创建 赋值时需要注意
- (NSMutableArray *_Nullable)mergeCellArrformView:(JXFormView *_Nullable)formView;



@end

NS_ASSUME_NONNULL_BEGIN

@interface JXFormView : UIView


+ (JXFormView *)drawListWithRect:(CGRect)rect numberOfRow:(NSInteger)rows numberOfcolumn:(NSInteger)columns delegate:(id<JXFormViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END

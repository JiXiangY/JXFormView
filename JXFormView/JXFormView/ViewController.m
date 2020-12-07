//
//  ViewController.m
//  JXFormView
//
//  Created by 于吉祥 on 2020/12/7.
//

#import "ViewController.h"
#import "JXFormView.h"
#import "JXFormTool.h"
@interface ViewController ()<JXFormViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = @[@[@" ",@"列",@"",@"",@""],
    @[@"行",@"打款金额\n（元）",@"转出金额\n（元）",@"金融类型",@"交易时间"],
    @[@" ",@"25000.00",@" ",@"买方",@"2020-11-12"],
    @[@"",@" ",@"5000.00",@"卖方",@"2020-11-12"]];
    self.dataArr = [arr mutableCopy];
    JXFormView *v = [JXFormView drawListWithRect:CGRectMake(10, 100, self.view.bounds.size.width-10, 500) numberOfRow:4 numberOfcolumn:5 delegate:self];
    [self.view addSubview:v];
    
    //    + (JXFormView *)drawListWithRect:(CGRect)rect numberOfRow:(NSInteger)rows numberOfcolumn:(NSInteger)columns lineColor:(UIColor *)color lineWidth:(CGFloat)lineWidth delegate:(id<JXFormViewDelegate>)delegate;
    // Do any additional setup after loading the view.
}


- (JXFormCellModel * _Nullable)formView:(JXFormView * _Nullable)formView cellModelForFormIndex:(JXFormIndex * _Nullable)formIndex {
    JXFormCellModel *model = [[JXFormCellModel alloc]init];
    model.lineColer = UIColor.blackColor;
    model.lineWidth = 1;
    return model;
}

- (UIView * _Nullable)formView:(JXFormView * _Nullable)formView cellViewFrame:(CGRect)frame forFormIndex:(JXFormIndex * _Nullable)formIndex {
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = self.dataArr[formIndex.row][formIndex.column];
    label.textAlignment = NSTextAlignmentCenter;
    if(formIndex.row == 0){
        label.font = [UIFont boldSystemFontOfSize:13];
        label.numberOfLines = 2;
    }else{
        label.font = [UIFont systemFontOfSize:13];
    }
    if(formIndex.row == 0 || formIndex.row%2 == 0){
        label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    if ([formIndex isEqualRow:1 column:0]) {
        label.backgroundColor = UIColor.yellowColor;
    }
    if ([formIndex isEqualRow:0 column:1]) {
        label.backgroundColor = UIColor.redColor;
    }
    if ([formIndex isEqualRow:0 column:0]) {
        label.backgroundColor = UIColor.greenColor;
    }
    return label;
}

- (CGFloat)formView:(JXFormView * _Nullable)formView heightForFormIndex:(JXFormIndex * _Nullable)formIndex {
    if (formIndex.row == 0) {
        return 58;
    }
    return 48;
}

- (CGFloat)formView:(JXFormView * _Nullable)formView widthForFormIndex:(JXFormIndex * _Nullable)formIndex {
    return (self.view.frame.size.width-40)/[self.dataArr[formIndex.row] count];
}

- (NSMutableArray* _Nullable)mergeCellArrformView:(JXFormView * _Nullable)formView {
    NSArray *arr =@[
    @{@"start":[JXFormIndex indexWithRow:0 column:1],@"end":[JXFormIndex indexWithRow:0 column:4]},
    @{@"start":[JXFormIndex indexWithRow:1 column:0],@"end":[JXFormIndex indexWithRow:3 column:0]}
    ];
    return [arr mutableCopy];
}


@end

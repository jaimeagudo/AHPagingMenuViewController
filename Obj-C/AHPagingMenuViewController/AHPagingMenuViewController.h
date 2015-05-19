//
//  AHPagingMenuViewController.h
//  AHPagingMenuViewController
//
//  VERSION 1.0 - LICENSE MIT
//
//  Menu Slider Page! Enjoy
//  Obj-c Version
//
//  Created by André Henrique Silva on 01/04/15.
//  Bugs? Send -> andre.henrique@me.com  Thank you!
//  Copyright (c) 2015 André Henrique Silva. All rights reserved. http://andrehenrique.me =D
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

//Default values
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define NAV_HEIGHT  45.0 + [UIApplication sharedApplication].statusBarFrame.size.height
#define NAV_TITLE_SIZE 30
#define NAV_SPACE_VALUE 15
#define NAV_SCALE_MAX 1.0
#define NAV_SCALE_MIN 0.9
#define IS_PORTATE ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
#define SYSTEM_VERSION_LESS_THAN(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define CONTENT_HEIGHT self.view.frame.size.height - NAV_HEIGHT
#define NAV_BUTTON_SELECTED_COLOR [UIColor blackColor]
#define NAV_BUTTON_DISSECTED_COLOR [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
#define NAV_BUTTON_SELECTED_FONT [UIFont fontWithName:@"HelveticaNeue-Medium" size:16]
#define NAV_BUTTON_DISSECTED_FONT [UIFont fontWithName:@"HelveticaNeue" size:16]
#define VIEW_COLOR [UIColor whiteColor]
#define NAV_COLOR [UIColor whiteColor]


@protocol AHPagingMenuDelegate <NSObject>

@optional
/**
 *  Return the obj when finish
 *
 *  @param from NSInteger Position
 *  @param to   NSInteger Position
 */
- (void) AHPagingMenuDidChangeMenuPositionFrom:(NSInteger)from to: (NSInteger)to;
/**
 *  Return the obj when finish
 *
 *  @param from Controller_to
 *  @param to   Controller_From
 */
- (void) AHPagingMenuDidChangeMenuFrom:(id)from to: (id)to;

@end


@interface AHPagingMenuViewController : UIViewController

/**
 *  Bounce - Elastic Effect on View
 */
@property (nonatomic, getter=isBounce, readonly)                   BOOL bounce;

/**
 *  Fade Elements on bar
 */
@property (nonatomic, getter=isFade, readonly)                     BOOL fade;

/**
 * Transform Elements on bar
 */
@property (nonatomic, getter=isTransformScale, readonly)           BOOL transformScale;

/**
 *  Show Arrow Right and Left on bar
 */
@property (nonatomic, getter=isArrowShowing, readonly)            BOOL showArrow;

/**
 *  Use second font (Right and Left Elements)
 */
@property (nonatomic, getter=isChangeFont, readonly)              BOOL changeFont;

/**
 *  Bounce - Elastic Effect on View
 */
@property (nonatomic, getter=isChangeColor, readonly)             BOOL changeColor;

/**
*  Current controller
*/
@property (nonatomic, readonly)                                   NSInteger currentPage;

/**
 *  Main Color selected
 */
@property (nonatomic, readonly)                                   UIColor *selectedColor;

/**
 *  Second Color
 */
@property (nonatomic, readonly)                                   UIColor *dissectedColor;

/**
 *  Main Font
 */
@property (nonatomic, readonly)                                   UIFont *selectedFont;

/**
 *  Second Font
 */
@property (nonatomic, readonly)                                   UIFont *dissectedFont;

/**
 *  Scale Max
 */
@property (nonatomic, readonly)                                   CGFloat scaleMax;

/**
 *  Scale Min
 */
@property (nonatomic, readonly)                                   CGFloat scaleMin;

/**
 * Elements property
 */
@property (nonatomic, strong, readonly)                           NSMutableArray *viewControllers;

/**
 * Elements propertyes
 */
@property (nonatomic, strong, readonly)                           NSMutableArray *iconsMenu;

/**
 *  Delegate 
 */
@property (nonatomic)                                             NSObject<AHPagingMenuDelegate> *delegate;

/**
 *  Metodo init com parametros de execução da página - Position default
 *
 *  @param controllers Array with Controllers
 *  @param icons       Array with Title (UIImage or NSString)
 */
- (id) initWithControllers: (NSArray*) controllers andMenuItens: (NSArray*) icons;

/**
 *  Method init with property initial - Choose default controller
 *
 *  @param controllers Array with Controllers
 *  @param icons       Array with Title (UIImage or NSString)
 *  @param position    Position initial
 */
- (id) initWithControllers: (NSArray*) controllers andMenuItens: (NSArray*) icons andStartWith:(NSInteger)position;

/**
 *  Add new controller on views
 *
 *  @param controller New controller
 *  @param image      Icon
 */
-(void) addNewController:(UIViewController*)controller andTitleView: (id) title;

/**
 *  Go to view -> 0 - n
 *
 *  @param position position to show
 */
- (void) setPosition:(NSInteger) position animated:(BOOL) animated;

/**
 *  Go to Next View
 */
- (void) goNextView;

/**
 *  Go to Previeus View
 */
- (void) goPrevieusView;

/**
 *  Resert config elements bar
 */
-(void) resertNavBarConfig;

/**
 *  Bounce effect on container
 *
 *  @param bounce Boolean Value
 */
-(void) setBounce:(BOOL)bounce;

/**
 *  Fade effect on Transitions
 *
 *  @param fade Boolean Value
 */
-(void) setFade:(BOOL)fade;

/**
 *  Transfom effect on Transitions
 *
 *  @param transformScale Boolean Value
 */
-(void) setTransformScale:(BOOL) transformScale;

/**
 *  Show arrow on navigation
 *
 *  @param showArrow Boolean Value
 */
-(void) setShowArrow:(BOOL) showArrow;

/**
 *  Change Font Selected ⇌ Dissected on Transitions
 *
 *  @param changeFont Boolean Value
 */
-(void) setChangeFont:(BOOL) changeFont;

/**
 *  Change color  Selected ⇌ Dissected on Transitions
 *
 *  @param changeColor Boolean Value
 */
-(void) setChangeColor:(BOOL) changeColor;

/**
 *  Change Selected Color (main color)
 *
 *  @param selectedColor Selected Color
 */
-(void) setSelectedColor:(UIColor *)selectedColor;

/**
 *  Change Dissected Color
 *
 *  @param dissectedColor Dissected Color
 */
-(void) setDissectedColor:(UIColor *)dissectedColor;

/**
 *  Change selected font
 *
 *  @param selectedFont UIFont - Size default is 18!
 */
-(void) setSelectedFont:(UIFont *)selectedFont;

/**
 *  Change dissected font
 *
 *  @param dissectedFont UIFont - Size default is 18!
 */
-(void) setDissectedFont:(UIFont *)dissectedFont;

/**
 *  Content Background Color
 *
 *  @param backgroundColor   background Color
 */
-(void) setContentBackgroundColor:(UIColor*) backgroundColor;

/**
 *  Nav Background Color
 *
 *  @param backgroundColor background Color
 */
-(void) setNavBackgroundColor:(UIColor*)backgroundColor;

/**
 *  Nav Line color
 *
 *  @param backgroundColor line Color
 */
-(void) setNavLineBackgroundColor:(UIColor*)backgroundColor;

/**
 *  Change Scale
 *
 *  @param scaleMax Scale for main title
 *  @param scaleMin Scale for second title
 */
-(void) setScaleMax:(CGFloat)scaleMax andScaleMin:(CGFloat)scaleMin;


@end


@interface UIViewController (AHPagingMenuViewController)

/**
 *  Set AHPagingController
 *
 *  @param menuViewController AHPagingMenuViewController
 */
- (void)setAHPagingController:(AHPagingMenuViewController *)menuViewController;

/**
 *  Get the AHPagingMenuViewController in controllers
 *
 *  @return return controller
 */
- (AHPagingMenuViewController*) pagingMenuViewController;

@end


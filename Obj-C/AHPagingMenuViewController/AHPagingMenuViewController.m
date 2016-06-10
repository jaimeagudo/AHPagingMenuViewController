//
//  AHPagingMenuViewController.m
//  AHPagingMenuViewController
//
//  VERSION 1.0 - LICENSE MIT
//
//  Menu Slider Page! Enjoy
//  Obj-c Version
//
//  Created by André Henrique Silva - Bugs? Send -> andre.henrique@me.com on 01/04/15.
//  Copyright (c) 2015 André Henrique Silva. All rights reserved. http://andrehenrique.me =D


#import "AHPagingMenuViewController.h"


@interface AHPagingMenuViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIView *navLine;
@property (nonatomic, strong) UIScrollView *viewConteiner;
@property (nonatomic, strong) UIImageView *arrowRight;
@property (nonatomic, strong) UIImageView *arrowLeft;

@end

@implementation AHPagingMenuViewController

@synthesize delegate;

#pragma mark - inits

-(id) init
{
    return [self initWithControllers:[NSArray new] andMenuItens:[NSArray new] andStartWith:0];
}

-(id) initWithCoder: (NSCoder *) coder
{
    return [self initWithControllers:[NSArray new] andMenuItens:[NSArray new] andStartWith:0];
}

-(id) initWithControllers: (NSArray*) controllers andMenuItens: (NSArray*) icons;
{
    return [self initWithControllers:controllers andMenuItens:icons andStartWith:0];
}

-(id) initWithControllers: (NSArray*) controllers andMenuItens: (NSArray*) icons andStartWith:(NSInteger)position;
{
    self = [super init];
    if(self)
    {
        _bounce                = YES;
        _fade                  = YES;
        _showArrow             = YES;
        _transformScale        = NO;
        _changeFont            = YES;
        _changeColor           = YES;
        _selectedColor         = NAV_BUTTON_SELECTED_COLOR;
        _dissectedColor        = NAV_BUTTON_DISSECTED_COLOR;
        _selectedFont          = NAV_BUTTON_SELECTED_FONT;
        _dissectedFont         = NAV_BUTTON_DISSECTED_FONT;
        _currentPage           = position;
        _viewControllers       = [NSMutableArray new];
        _iconsMenu             = [NSMutableArray new];
        _scaleMax              = NAV_SCALE_MAX;
        _scaleMin              = NAV_SCALE_MIN;
        
        for (id controller in controllers) {
            
            if([controller isKindOfClass:UIViewController.class])
            {
                UIViewController *controller_element = (UIViewController*) controller;
                [controller_element setAHPagingController:self];
                [_viewControllers addObject:controller_element];
            }
            else
            {
                @throw [NSException exceptionWithName:@"ClassRequeredNotFoundException" reason:@"Not Allowed Class. Controller Please!" userInfo:nil];
            }
        }
        
        for (id icon in icons)
        {
            if([icon isKindOfClass:NSString.class])
            {
                UILabel *label = [UILabel new];
                [label setText:(NSString*)icon];
                [_iconsMenu addObject:label];
            }
            else if([icon isKindOfClass:UIImage.class])
            {
                UIImageView *image = [[UIImageView alloc] initWithImage:(UIImage*) icon];
                image.image = [image.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                image.contentMode = UIViewContentModeScaleAspectFill;
                [_iconsMenu addObject:image];
            }
            else
            {
                @throw [NSException exceptionWithName:@"ClassRequeredNotFoundException" reason:@"Not Allowed Class. NSString or UIImage Please!" userInfo:nil];
            }
        }
        
        if(_viewControllers.count != _iconsMenu.count)
        {
            @throw [NSException exceptionWithName:@"TitleAndControllersException" reason:@"Title and controllers not match" userInfo:nil];
        }
        
    }
    return self;
}

#pragma mark - Cycle Life

-(void) loadView
{
    [super loadView];
    [self.view setBackgroundColor:VIEW_COLOR];
    
    UIScrollView *viewConteiner = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [viewConteiner setDelegate:self];
    [viewConteiner setPagingEnabled:YES];
    [viewConteiner setBounces:_bounce];
    [viewConteiner setShowsHorizontalScrollIndicator:NO];
    [viewConteiner setShowsVerticalScrollIndicator:NO];
    [viewConteiner setContentSize:CGSizeMake(0,0)];
    [self.view addSubview:viewConteiner];
    self.viewConteiner = viewConteiner;
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectZero];
    [navView setBackgroundColor:NAV_COLOR];
    navView.clipsToBounds = YES;
    [self.view addSubview:navView];
    self.navView = navView;
    
    UIImageView *arrowRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowRight"]];
    arrowRight.userInteractionEnabled = YES;
    [arrowRight addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goNextView)]];
    arrowRight.image = [arrowRight.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.navView addSubview:arrowRight];
    self.arrowRight = arrowRight;
    
    UIImageView *arrowLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowLeft"]];
    [arrowLeft addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goPrevieusView)]];
    arrowLeft.userInteractionEnabled = YES;
    arrowLeft.image = [arrowLeft.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.navView addSubview:arrowLeft];
    self.arrowLeft = arrowLeft;
    
    UIView *navLine = [[UIView alloc] init];
    navLine.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    [self.view addSubview:navLine];
    self.navLine = navLine;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    NSInteger cont = 0;
    for (UIViewController *controller in  self.viewControllers)
    {
        [self includeControllerOnInterface:controller andIcon:[self.iconsMenu objectAtIndex:cont] withTag:cont];
        cont++;
    }
    
    [self.viewConteiner setContentOffset:CGPointMake(_currentPage * self.viewConteiner.frame.size.width, self.viewConteiner.contentOffset.y)];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self resertNavBarConfig];
}

-(void) viewDidLayoutSubviews
{
    //[super viewDidLayoutSubviews];
    [self.viewConteiner setFrame:CGRectMake(0, NAV_HEIGHT, self.view.frame.size.width, CONTENT_HEIGHT)];
    [self.viewConteiner setContentOffset:CGPointMake(_currentPage * self.viewConteiner.frame.size.width, self.viewConteiner.contentOffset.y)];
    [self.arrowLeft setCenter:CGPointMake( NAV_SPACE_VALUE, self.navView.center.y + ([UIApplication sharedApplication].statusBarFrame.size.height)/2.0)];
    [self.arrowRight setCenter:CGPointMake( self.view.frame.size.width - NAV_SPACE_VALUE , self.navView.center.y + ([UIApplication sharedApplication].statusBarFrame.size.height)/2.0)];
    [self.navView setFrame:CGRectMake(0, 0, self.view.frame.size.width, NAV_HEIGHT)];
    [self.navLine setFrame:CGRectMake(0.0f, self.navView.frame.size.height, self.navView.frame.size.width, 1.0f)];
    
    NSInteger count = 0;
    
    for (UIViewController *controller in  self.viewControllers)
    {
        [controller.view setFrame:CGRectMake(self.view.frame.size.width * count, 0, self.view.frame.size.width, CONTENT_HEIGHT)];
        
        UIView *titleView = [self.iconsMenu objectAtIndex:count];
        CGAffineTransform affine= titleView.transform;

        [titleView setTransform:CGAffineTransformMakeScale(1.0,1.0)];
        
        if([titleView isKindOfClass:UIImageView.class])
        {
            UIImageView *icon = (UIImageView*) titleView;
            [titleView setFrame:CGRectMake(50 *count, 0, ( icon.image ? (NAV_TITLE_SIZE * icon.image.size.width) / icon.image.size.height : NAV_TITLE_SIZE ) , NAV_TITLE_SIZE)];
        }
        else if([titleView isKindOfClass:UILabel.class])
        {
            [titleView sizeToFit];
        }
        
        if(_transformScale)[titleView setTransform:affine];
        
        CGFloat spacing  = (self.view.frame.size.width/2) - NAV_SPACE_VALUE - titleView.frame.size.width/2 - (_showArrow ? self.arrowLeft.image.size.width : 0);
        [titleView setCenter:CGPointMake(self.navView.center.x + ( spacing * count) - (_currentPage * spacing) , self.navView.center.y + ([UIApplication sharedApplication].statusBarFrame.size.height)/2.0)];
        
        count++;
    }
    
    [self.viewConteiner setContentSize:CGSizeMake(self.view.frame.size.width * count, CONTENT_HEIGHT)];
    
}


-(BOOL) shouldAutorotate
{
    return ( SYSTEM_VERSION_LESS_THAN(@"8.0") ? NO : YES );
}

#pragma mark - Methods Public

-(void) addNewController:(UIViewController*)controller andTitleView: (id) title
{
    
    [self.viewControllers addObject:controller];
    
    if([title isKindOfClass:NSString.class])
    {
        UILabel *label = [UILabel new];
        [label setText:(NSString*)title];
        [_iconsMenu addObject:label];
        [self includeControllerOnInterface:controller andIcon:label withTag:self.iconsMenu.count -1];
    }
    else if([title isKindOfClass:UIImage.class])
    {
        UIImageView *image = [[UIImageView alloc] initWithImage:(UIImage*) title];
        image.image = [image.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        image.contentMode = UIViewContentModeScaleAspectFill;
        [_iconsMenu addObject:image];
        [self includeControllerOnInterface:controller andIcon:image withTag:self.iconsMenu.count -1];
    }
    else
    {
        @throw [NSException exceptionWithName:@"ClassRequeredNotFoundException" reason:@"Not Allowed Class. NSString or UIImage Please!" userInfo:nil];
    }
    
    [self viewDidLayoutSubviews];
    [self resertNavBarConfig];
}

-(void) setPosition:(NSInteger) position animated:(BOOL) animated
{
    _currentPage           = position;
    [self.viewConteiner setContentOffset:CGPointMake(_currentPage * self.viewConteiner.frame.size.width, self.viewConteiner.contentOffset.y) animated:animated];
}

-(void) goNextView
{
    if(_currentPage < self.viewControllers.count) [self setPosition:_currentPage + 1 animated:YES];
}

-(void) goPrevieusView
{
    if(_currentPage > 0) [self setPosition:_currentPage - 1 animated:YES];
}

-(void) resertNavBarConfig
{
    NSInteger count = 0;
    for (UIView *titleView in _iconsMenu)
    {
        if([titleView isKindOfClass:UIImageView.class])
        {
            titleView.tintColor = (_changeColor ? (count == _currentPage ? _selectedColor: _dissectedColor) :  _selectedColor);
        }
        else if([titleView isKindOfClass:UILabel.class])
        {
            UILabel *titleText = (UILabel*) titleView;
            [titleText setTextColor:(_changeColor ? (count == _currentPage ? _selectedColor: _dissectedColor) :  _selectedColor)];
            [titleText setFont:( _changeFont ? ( count == _currentPage ? _selectedFont : _dissectedFont ) : _selectedFont)];
        }
        
        CGFloat transform = (_transformScale ? ( count == _currentPage ? _scaleMax: _scaleMin): _scaleMax);
        titleView.transform = CGAffineTransformMakeScale(transform,transform);
        count++;
    }
    
    [self.arrowLeft setAlpha:(_showArrow? (_currentPage == 0 ? 0.0 : 1.0) :0.0)];
    [self.arrowRight setAlpha:(_showArrow? (_currentPage == _viewControllers.count - 1 ? 0.0 : 1.0) :0.0)];
    [self.arrowLeft setTintColor:(_changeColor ? _dissectedColor :  _selectedColor)];
    [self.arrowRight setTintColor:(_changeColor ? _dissectedColor :  _selectedColor)];
    
}

#pragma mark - Methods Private

/**
 *  Include new controller on interface
 *
 *  @param controller New Controller
 *  @param image      Image Menu
 */
-(void) includeControllerOnInterface:(UIViewController*)controller andIcon: (UIView*) titleView withTag:(NSInteger)tag
{
    //controller
    controller.view.clipsToBounds = YES;
    [controller.view setFrame:CGRectMake(self.viewConteiner.contentSize.width, 0, self.view.frame.size.width, CONTENT_HEIGHT)];
    [self.viewConteiner setContentSize:CGSizeMake(self.view.frame.size.width + self.viewConteiner.contentSize.width, CONTENT_HEIGHT)];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [self.viewConteiner addSubview:controller.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnButton:)];
    [titleView addGestureRecognizer:tap];
    [titleView setUserInteractionEnabled:YES];
    titleView.tag = tag;
    [self.navView addSubview:titleView];
    
}

/**
 *  Touch button
 *
 *  @param sender sender
 */
-(void) tapOnButton:(id) sender
{
    if([sender view].tag != _currentPage)
    {
        CGRect frame = _viewConteiner.frame;
        frame.origin.x = frame.size.width *[sender view].tag;
        frame.origin.y = 0;
        [_viewConteiner scrollRectToVisible:frame animated:YES];
    }
    
}

/**
 *  Change Color with Porcent
 *
 *  @param fromColor Start Color
 *  @param toColor   Finish Color
 *  @param porcent   Porcent (0.0 - 1.0)
 *
 *  @return Color result
 */
- (UIColor*) changeColorFrom:(UIColor*)fromColor to:(UIColor*)toColor withPorcent:(CGFloat)porcent
{
    CGFloat redStart = 0.0;
    CGFloat greenStart = 0.0;
    CGFloat blueStart = 0.0;
    CGFloat alphaStart = 0.0;
    [fromColor getRed:&redStart green:&greenStart blue:&blueStart alpha:&alphaStart];
    
    CGFloat redFinish = 0.0;
    CGFloat greenFinish = 0.0;
    CGFloat blueFinish = 0.0;
    CGFloat alphaFinish = 0.0;
    [toColor getRed:&redFinish green:&greenFinish blue:&blueFinish alpha:&alphaFinish];
    
    return [UIColor colorWithRed:(redStart - ((redStart-redFinish) * porcent))
                           green:(greenStart - ((greenStart-greenFinish) * porcent))
                            blue:(blueStart - ((blueStart-blueFinish) * porcent))
                           alpha:(alphaStart - ((alphaStart-alphaFinish) * porcent))];
}

#pragma mark - Setters

-(void) setBounce:(BOOL)bounce
{
    [self.viewConteiner setBounces:bounce];
    _bounce = bounce;
}

-(void) setFade:(BOOL)fade
{
    _fade = fade;
}

-(void) setTransformScale:(BOOL) transformScale
{
    _transformScale = transformScale;
    
    if(self.isViewLoaded && self.view.window)
    {
        NSInteger count = 0;
        for (UIView *titleView in _iconsMenu)
        {
            CGFloat transform = (_transformScale ? ( count == _currentPage ? _scaleMax: _scaleMin): _scaleMax);
            [titleView setTransform:CGAffineTransformMakeScale(transform,transform)];
            count++;
        }
    }
}

-(void) setShowArrow:(BOOL) showArrow
{
    _showArrow = showArrow;
    
    if(self.isViewLoaded && self.view.window)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self.arrowLeft setAlpha:(_showArrow? (_currentPage == 0 ? 0.0 : 1.0) : 0.0)];
            [self.arrowRight setAlpha:(_showArrow? (_currentPage == _viewControllers.count - 1 ? 0.0 : 1.0) :0.0)];
            [self viewDidLayoutSubviews];
        }];
        
    }
}

-(void) setChangeFont:(BOOL) changeFont
{
    _changeFont = changeFont;
    
    if(self.isViewLoaded && self.view.window)
    {
        NSInteger count = 0;
        for (UIView *titleView in _iconsMenu)
        {
            if([titleView isKindOfClass:UILabel.class])
            {
                [(UILabel*) titleView setFont:( _changeFont ? ( count == _currentPage ? _selectedFont : _dissectedFont ) : _selectedFont)];
                [titleView sizeToFit];
            }
            
            count++;
        }
        
    }
}

-(void) setChangeColor:(BOOL) changeColor
{
    _changeColor = changeColor;
    
    if(self.isViewLoaded && self.view.window)
    {
        NSInteger count = 0;
        for (UIView *titleView in _iconsMenu)
        {
            if([titleView isKindOfClass:UIImageView.class])
            {
                titleView.tintColor = (_changeColor ? (count == _currentPage ? _selectedColor: _dissectedColor) :  _selectedColor);
            }
            else if([titleView isKindOfClass:UILabel.class])
            {
                [(UILabel*) titleView setTextColor:(_changeColor ? (count == _currentPage ? _selectedColor: _dissectedColor) :  _selectedColor)];
            }
            
            count++;
        }
        [self.arrowLeft setTintColor:(_changeColor ? _dissectedColor :  _selectedColor)];
        [self.arrowRight setTintColor:(_changeColor ? _dissectedColor :  _selectedColor)];
    }
}

-(void) setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    
    if(self.isViewLoaded && self.view.window)
    {
        NSInteger count = 0;
        for (UIView *titleView in _iconsMenu)
        {
            if([titleView isKindOfClass:UIImageView.class])
            {
                titleView.tintColor =  (_changeColor ? (count == _currentPage ? _selectedColor: _dissectedColor) :  _selectedColor);
            }
            else if([titleView isKindOfClass:UILabel.class])
            {
                [(UILabel*) titleView setTextColor: (_changeColor ? (count == _currentPage ? _selectedColor: _dissectedColor) :  _selectedColor)];
            }
            
            count++;
        }
        [self.arrowLeft setTintColor:(_changeColor ? _dissectedColor :  _selectedColor)];
        [self.arrowRight setTintColor:(_changeColor ? _dissectedColor :  _selectedColor)];
    }
}

-(void) setDissectedColor:(UIColor *)dissectedColor
{
    _dissectedColor = dissectedColor;
    
    if(self.isViewLoaded && self.view.window)
    {
        
        NSInteger count = 0;
        for (UIView *titleView in _iconsMenu)
        {
            if([titleView isKindOfClass:UIImageView.class])
            {
                titleView.tintColor =  (_changeColor ? (count == _currentPage ? _selectedColor: _dissectedColor) :  _selectedColor);
            }
            else if([titleView isKindOfClass:UILabel.class])
            {
                [(UILabel*) titleView setTextColor: (_changeColor ? (count == _currentPage ? _selectedColor: _dissectedColor) :  _selectedColor)];
            }
            
            count++;
        }
        [self.arrowLeft setTintColor:dissectedColor];
        [self.arrowRight setTintColor:dissectedColor];
    }
}

-(void) setSelectedFont:(UIFont *)selectedFont
{
    _selectedFont = selectedFont;
    
    if(self.isViewLoaded && self.view.window)
    {
        NSInteger count = 0;
        for (UIView *titleView in _iconsMenu)
        {
            if([titleView isKindOfClass:UILabel.class])
            {
                UILabel *titleText = (UILabel*) titleView;
                [titleText setFont:( _changeFont ? ( count == _currentPage ? _selectedFont : _dissectedFont ) : _selectedFont)];
                [titleText sizeToFit];
            }
            count++;
        }
    }
}

-(void) setDissectedFont:(UIFont *)dissectedFont
{
    _dissectedFont = dissectedFont;
    
    if(self.isViewLoaded && self.view.window)
    {
        NSInteger count = 0;
        for (UIView *titleView in _iconsMenu)
        {
            if([titleView isKindOfClass:UILabel.class] && count != _currentPage)
            {
                UILabel *titleText = (UILabel*) titleView;
                [titleText setFont:( _changeFont ? _dissectedFont : _selectedFont)];
            }
            count++;
        }
    }
}

-(void) setContentBackgroundColor:(UIColor*) backgroundColor
{
    [self.viewConteiner setBackgroundColor:backgroundColor];
}

-(void) setNavBackgroundColor:(UIColor*)backgroundColor
{
    [self.navView setBackgroundColor:backgroundColor];
}

-(void) setNavLineBackgroundColor:(UIColor*)backgroundColor
{
    [self.navLine setBackgroundColor:backgroundColor];
}


-(void) setScaleMax:(CGFloat)scaleMax andScaleMin:(CGFloat)scaleMin
{
    if(scaleMax < scaleMin || scaleMin < 0.0  || scaleMax < 0.0 ) return;
    
    _scaleMax = scaleMax;
    _scaleMin = scaleMin;
    
    if(self.isViewLoaded && self.view.window)
    {
        NSInteger count = 0;
        for (UIView *titleView in _iconsMenu)
        {
            CGFloat transform = (_transformScale ? ( count == _currentPage ? _scaleMax: _scaleMin): _scaleMax);
            [titleView setTransform:CGAffineTransformMakeScale(transform,transform)];
            
            if([titleView isKindOfClass:UILabel.class]) [(UILabel*) titleView sizeToFit];
            
            count++;
        }
        [self viewWillLayoutSubviews];
    }

}


#pragma mark - UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _viewConteiner)
    {
        CGFloat xPosition = scrollView.contentOffset.x;
        float fractionalPage = xPosition / scrollView.frame.size.width;
        NSInteger currentPage = lround(fractionalPage);
        
        if(fractionalPage == currentPage && currentPage != _currentPage) {
            
            _currentPage = currentPage;
            if(self.delegate)
            {
                if ([self.delegate respondsToSelector:@selector(pagingMenuDidChangeMenuPositionFrom:to:)])
                    [self.delegate pagingMenuDidChangeMenuPositionFrom:_currentPage to:currentPage];
                
                if ([self.delegate respondsToSelector:@selector(AHPagingMenuDidChangeMenuFrom:to:)])
                    [self.delegate AHPagingMenuDidChangeMenuFrom:[_viewControllers objectAtIndex:_currentPage] to: [_viewControllers objectAtIndex:currentPage]];
            }
        }
        
        CGFloat porcent = fabs(fractionalPage - currentPage)/0.5;
        
        if(_showArrow)
        {
            if(currentPage <= 0)
            {
                [self.arrowLeft setAlpha:0.0];
                [self.arrowRight setAlpha:1.0 - porcent];
            }
            else if(currentPage >= self.iconsMenu.count -1)
            {
                [self.arrowRight setAlpha:0.0];
                [self.arrowLeft setAlpha:1.0 - porcent];
            }
            else
            {
                [self.arrowLeft setAlpha:1.0 - porcent];
                [self.arrowRight setAlpha:1.0 - porcent];
            }
        }
        else
        {
            [self.arrowLeft setAlpha:0];
            [self.arrowRight setAlpha:0];
        }
        
        NSInteger count = 0;
        for (UIView *titleView in self.iconsMenu)
        {
            titleView.alpha = ( _fade ? (count <= (currentPage + 1) && count >= (currentPage - 1) ? 1.3 - porcent : 0.0 ) : (count <= _currentPage + 1 || count >= _currentPage -1? 1.0: 0.0));
            
            CGFloat spacing  = (self.view.frame.size.width/2) - NAV_SPACE_VALUE - titleView.frame.size.width/2 - (_showArrow ? self.arrowLeft.image.size.width : 0);
            [titleView setCenter:CGPointMake(self.navView.center.x + ( spacing * count) - (fractionalPage * spacing), self.navView.center.y + ([UIApplication sharedApplication].statusBarFrame.size.height)/2.0)];
            CGFloat distance_center = fabs(titleView.center.x - self.navView.center.x);
          
            if([titleView isKindOfClass:UIImageView.class])
            {
                if( distance_center < spacing)
                {
                    if(_changeColor) titleView.tintColor = [self changeColorFrom:_selectedColor to:_dissectedColor withPorcent:distance_center/spacing];
                }
                
            }
            else if([titleView isKindOfClass:UILabel.class])
            {
                UILabel *titleText = (UILabel*) titleView;
                
                if( distance_center < spacing)
                {
                    if(_changeColor)[titleText setTextColor:[self changeColorFrom:_selectedColor to:_dissectedColor withPorcent:distance_center/spacing]];
                    
                    if(_changeFont)
                    {
                        [titleText setFont:(distance_center < spacing/2.0 ? _selectedFont : _dissectedFont)];
                        [titleText sizeToFit];
                    }
                }
                
            }
            
            if(_transformScale && count <= (currentPage + 1) && count >= (currentPage - 1))
            {
                CGFloat transform = _scaleMax + ((_scaleMax - _scaleMin) *  - distance_center /spacing);
                titleView.transform = CGAffineTransformMakeScale(transform, transform);
            }
             
            count++;
        }
        
    }
    
}

 
@end

@implementation UIViewController (AHPagingMenuViewController)

static char AHPagingMenuViewControllerKey;

/**
 *  Set AHPagingController
 *
 *  @param menuViewController AHPagingMenuViewController
 */
- (void)setAHPagingController:(AHPagingMenuViewController *)menuViewController
{
    [self willChangeValueForKey:@"AHPagingMenuViewController"];
    objc_setAssociatedObject(self,
                             &AHPagingMenuViewControllerKey,
                             menuViewController,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"AHPagingMenuViewController"];
}


- (AHPagingMenuViewController *)pagingMenuViewController {
    id controller = objc_getAssociatedObject(self, &AHPagingMenuViewControllerKey);
    
    // because we can't ask the navigation controller to set to the pushed controller the revealSideViewController !
    if (!controller && self.navigationController) controller = self.navigationController.pagingMenuViewController;
    if (!controller && self.tabBarController) controller = self.tabBarController.pagingMenuViewController;
    return controller;
}

@end

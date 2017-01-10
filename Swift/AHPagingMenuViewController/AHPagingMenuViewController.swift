//
//  AHPagingMenuViewController.swift
//  VERSION 1.0 - LICENSE MIT
//
//  Menu Slider Page! Enjoy
//  Swift Version
//
//  Created by André Henrique Silva on 01/04/15.
//  Bugs? Send -> andre.henrique@me.com  Thank you!
//  Copyright (c) 2015 André Henrique Silva. All rights reserved. http://andrehenrique.me =D
//

import UIKit
import ObjectiveC

@objc protocol AHPagingMenuDelegate
{
    /**
     Change position number

     - parameter form: position initial
     - parameter to:   position final
     */
    @objc optional func AHPagingMenuDidChangeMenuPosition(_ form: NSInteger, to: NSInteger);

    /**
     Change position obj

     - parameter form: obj initial
     - parameter to:   obj final
     */
    @objc optional func AHPagingMenuDidChangeMenuFrom(_ form: AnyObject, to: AnyObject);
}


var AHPagingMenuViewControllerKey: UInt8 = 0
extension UIViewController {

    func setAHPagingController(_ menuViewController: AHPagingMenuViewController)
    {
        self.willChangeValue(forKey: "AHPagingMenuViewController")
        objc_setAssociatedObject(self,  &AHPagingMenuViewControllerKey, menuViewController, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        self.didChangeValue(forKey: "AHPagingMenuViewController")
    }

    func pagingMenuViewController() -> AHPagingMenuViewController
    {

        let controller = objc_getAssociatedObject(self, &AHPagingMenuViewControllerKey) as! AHPagingMenuViewController;
        return controller;
    }

}


class AHPagingMenuViewController: UIViewController, UIScrollViewDelegate
{

    //Privates
    internal var bounce:          Bool!
    internal var fade:            Bool!
    internal var transformScale:  Bool!
    internal var showArrow:       Bool!
    internal var changeFont:      Bool!
    internal var changeColor:     Bool!
    internal var currentPage:     NSInteger!
    internal var selectedColor:   UIColor!
    internal var dissectedColor:  UIColor!
    internal var selectedFont:    UIFont!
    internal var dissectedFont:   UIFont!
    internal var scaleMax:        CGFloat!
    internal var scaleMin:        CGFloat!
    internal var viewControllers: NSMutableArray?
    internal var iconsMenu:       NSMutableArray?
    internal var delegate:        AHPagingMenuDelegate?

    internal var NAV_SPACE_VALUE:  CGFloat = 15.0
    internal var NAV_HEIGHT:       CGFloat = 45.0 + (UIApplication.shared.statusBarFrame.size.height)
    internal var NAV_TITLE_SIZE:   CGFloat = 30.0

    //Publics
    fileprivate var navView:       UIView?
    fileprivate var navLine:       UIView?
    fileprivate var viewContainer: UIScrollView?
    fileprivate var arrowRight:    UIImageView?
    fileprivate var arrowLeft:     UIImageView?

    // MARK: inits

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        self.inicializeValues(NSArray(), iconsMenu: NSArray(),  position:   0)
    }

    init(controllers:NSArray, icons: NSArray)
    {
        super.init(nibName: nil, bundle: nil);
        self.inicializeValues(controllers, iconsMenu: icons , position: 0)
    }

    init( controllers:(NSArray), icons: (NSArray), position:(NSInteger))
    {
        super.init(nibName: nil, bundle: nil)
        self.inicializeValues(controllers, iconsMenu: icons, position: position)
    }

    // MARK: Cycle Life

    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.white;

        let viewConteiner                            = UIScrollView()
        viewConteiner.delegate                       = self
        viewConteiner.isPagingEnabled                  = true
        viewConteiner.showsHorizontalScrollIndicator = false
        viewConteiner.showsVerticalScrollIndicator   = false
        viewConteiner.contentSize                    = CGSize(width: 0,height: 0)
        self.view.addSubview(viewConteiner)
        self.viewContainer = viewConteiner

        let navView                                  = UIView()
        navView.backgroundColor                      = .black // .p2pBlack() //UIColor.white
        navView.clipsToBounds                        = true

//TODO swipe on navBar too
//        let tap = UITapGestureRecognizer(target:self, action:#selector(AHPagingMenuViewController.tapOnButton(_:)))
//        navView.addGestureRecognizer(tap)
//        navView.isUserInteractionEnabled = true;
//        navView.tag = -1


        self.view.addSubview(navView)
        self.navView                                 = navView

        let arrowRight = UIImageView(image: UIImage(named:"arrowRight"))
        arrowRight.isUserInteractionEnabled = true
        arrowRight.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(AHPagingMenuViewController.goNextView)))
        arrowRight.image = arrowRight.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.navView?.addSubview(arrowRight)
        self.arrowRight = arrowRight;

        let arrowLeft = UIImageView(image: UIImage(named:"arrowLeft"))
        arrowLeft.isUserInteractionEnabled = true
        arrowLeft.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(AHPagingMenuViewController.goPrevieusView)))
        arrowLeft.image = arrowLeft.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.navView?.addSubview(arrowLeft)
        self.arrowLeft = arrowLeft

        let navLine = UIView()
        navLine.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        self.view.addSubview(navLine)
        self.navLine = navLine

    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        var count = 0
        for controller in self.viewControllers!
        {
            self.includeControllerOnInterface(controller as! UIViewController, titleView: self.iconsMenu!.object(at: count) as! UIView, tag: count)
            count += 1
        }

        self.viewContainer?.setContentOffset(CGPoint(x: CGFloat(self.currentPage!) * self.viewContainer!.frame.size.width, y: self.viewContainer!.contentOffset.y), animated: false)

    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.resetNavBarConfig();
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()

        NAV_HEIGHT = 45.0 + UIApplication.shared.statusBarFrame.size.height
        self.viewContainer?.frame = CGRect(x: 0, y: NAV_HEIGHT, width: self.view.frame.size.width, height: self.view.frame.size.height - NAV_HEIGHT)
        self.viewContainer?.contentOffset = CGPoint(x: CGFloat(self.currentPage) * self.viewContainer!.frame.size.width, y: self.viewContainer!.contentOffset.y)
        self.arrowLeft?.center = CGPoint( x: NAV_SPACE_VALUE, y: self.navView!.center.y + (UIApplication.shared.statusBarFrame.size.height)/2.0)
        self.arrowRight?.center = CGPoint( x: self.view.frame.size.width - NAV_SPACE_VALUE , y: self.navView!.center.y + (UIApplication.shared.statusBarFrame.size.height)/2.0)
        self.navView?.frame = CGRect( x: 0, y: 0, width: self.view.frame.size.width, height: NAV_HEIGHT)
        self.navLine?.frame = CGRect( x: 0.0, y: self.navView!.frame.size.height, width: self.navView!.frame.size.width, height: 1.0)

        var count = 0;
        for controller in self.viewControllers! as NSArray as! [UIViewController]
        {
            controller.view.frame = CGRect(x: self.view.frame.size.width * CGFloat(count), y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - NAV_HEIGHT)

            let titleView = self.iconsMenu?.object(at: count) as! UIView
            let affine = titleView.transform
            titleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

            if(titleView.isKind(of: UIImageView.self))
            {
                let icon = titleView as! UIImageView;
                titleView.frame = CGRect( x: 50.0 * CGFloat(count), y: 0, width: ( icon.image != nil ? (NAV_TITLE_SIZE * icon.image!.size.width) / icon.image!.size.height : NAV_TITLE_SIZE ) , height: NAV_TITLE_SIZE)

            }
            else if(titleView.isKind(of: UILabel.self))
            {
                titleView.sizeToFit()
            }

            if(self.transformScale!)
            {
                titleView.transform = affine
            }


            let spacing  = (self.view.frame.size.width/2.0) - self.NAV_SPACE_VALUE - titleView.frame.size.width/2.0 - CGFloat( self.showArrow! ? self.arrowLeft!.image!.size.width : 0.0)
            titleView.center = CGPoint(x: self.navView!.center.x + (spacing * CGFloat(count)) - (CGFloat(self.currentPage) * spacing) , y: self.navView!.center.y + (UIApplication.shared.statusBarFrame.size.height)/2.0)
            count += 1
        }

        self.viewContainer?.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(count), height: self.view.frame.size.height - NAV_HEIGHT)

    }

    override var shouldAutorotate : Bool
    {
        return true;
    }

    // MARK: Methods Public

    internal func addNewController(_ controller:UIViewController, title: AnyObject)
    {
        self.viewControllers?.add(controller);

        if title.isKind(of: NSString.self)
        {
            let label = UILabel()
            label.text = title as? String;
            self.iconsMenu?.add(label);
            self.includeControllerOnInterface(controller, titleView: label, tag: self.iconsMenu!.count - 1)
        }
        else if title.isKind(of: UIImage.self)
        {
            let image = UIImageView(image: title as? UIImage)
            image.image = image.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            image.contentMode = UIViewContentMode.scaleAspectFill
            self.iconsMenu!.add(image)
            self.includeControllerOnInterface(controller, titleView: image, tag: self.iconsMenu!.count - 1)

        }
        else
        {
            NSException(name:NSExceptionName(rawValue: "ClassRequeredNotFoundException"), reason:"Not Allowed Class. NSString or UIImage Please!", userInfo:nil).raise()
        }

        self.viewDidLayoutSubviews()
        self.resetNavBarConfig();

    }

    internal func setPosition(_ position: NSInteger, animated:Bool)
    {
        self.currentPage = position
        self.viewContainer?.setContentOffset(CGPoint( x: CGFloat(self.currentPage!) * self.viewContainer!.frame.size.width, y: self.viewContainer!.contentOffset.y), animated: animated)
    }

    internal func goNextView()
    {
        if self.currentPage! < self.viewControllers!.count
        {
            self.setPosition(self.currentPage! + 1, animated: true)
        }

    }

    internal func goPrevieusView()
    {
        if self.currentPage > 0
        {
            self.setPosition(self.currentPage! - 1, animated: true)
        }
    }

    internal func resetNavBarConfig()
    {

        var count = 0;
        for titleView in self.iconsMenu! as NSArray as! [UIView]
        {

            if(titleView.isKind(of: UIImageView.self))
            {
                titleView.tintColor =  self.changeColor! ? (count == self.currentPage ? self.selectedColor: self.dissectedColor) :  self.selectedColor
            }
            else
            {
                if( titleView.isKind(of: UILabel.self))
                {
                    let titleText = titleView as! UILabel
                    titleText.textColor = self.changeColor! ? (count == self.currentPage ? self.selectedColor: self.dissectedColor) :  self.selectedColor
                    titleText.font =  self.changeFont! ? ( count == self.currentPage ? self.selectedFont : self.dissectedFont ) : self.selectedFont

                }

            }

            let transform = (self.transformScale! ? ( count == self.currentPage ? self.scaleMax: self.scaleMin): self.scaleMax)
            titleView.transform = CGAffineTransform(scaleX: transform!, y: transform!)

            count += 1
        }

        self.arrowLeft!.alpha = (self.showArrow! ? (self.currentPage == 0 ? 0.0 : 1.0) :0.0);
        self.arrowRight!.alpha = (self.showArrow! ?  (self.currentPage == self.viewControllers!.count - 1 ? 0.0 : 1.0) :0.0);
        self.arrowRight!.tintColor = (self.changeColor! ? self.dissectedColor : self.selectedColor)
        self.arrowLeft!.tintColor = (self.changeColor! ? self.dissectedColor : self.selectedColor)
    }

    // MARK: Methods Private

    fileprivate func inicializeValues(_ viewControllers: NSArray!, iconsMenu: NSArray!, position: NSInteger!)
    {

        let elementsController = NSMutableArray();

        for controller in viewControllers
        {

            if (controller as AnyObject).isKind(of: UIViewController.self)
            {
                let controller_element = controller as! UIViewController
                controller_element.setAHPagingController(self)
                elementsController.add(controller)
            }
            else
            {
                NSException(name:NSExceptionName(rawValue: "ClassRequeredNotFoundException"), reason:"Not Allowed Class. Controller Please", userInfo:nil).raise()
            }

        }


        let iconsController = NSMutableArray();
        for icon in iconsMenu
        {
            if (icon as AnyObject).isKind(of: NSString.self)
            {
                let label = UILabel()
                label.text = icon as? String
                iconsController.add(label)
            }
            else if (icon as AnyObject).isKind(of: NSAttributedString.self)
            {
                let label = UILabel()
                label.attributedText = icon as? NSAttributedString
                iconsController.add(label)
            }
            else if((icon as AnyObject).isKind(of: UIImage.self))
            {
                let imageView = UIImageView(image: icon as? UIImage)
                imageView.image = imageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                imageView.contentMode = UIViewContentMode.scaleAspectFill
                iconsController.add(imageView)
            }
            else
            {
                NSException(name:NSExceptionName(rawValue: "ClassRequeredNotFoundException"), reason:"Not Allowed Class. NSString, NSAttributedString or UIImage Please!", userInfo:nil).raise()
            }
        }

        if(iconsController.count != elementsController.count)
        {
            NSException(name:NSExceptionName(rawValue: "TitleAndControllersException"), reason:"Title and controllers not match", userInfo:nil).raise()
        }

        self.bounce                = true
        self.fade                  = true
        self.showArrow             = true
        self.transformScale        = true
        self.changeFont            = true
        self.changeColor           = true
        self.selectedColor         = UIColor.black
        self.dissectedColor        = UIColor(red: 0.0 , green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        self.selectedFont          = UIFont(name: "FontAwesome", size: 32) // UIFont(name: "HelveticaNeue", size: 16)!
        self.dissectedFont         = UIFont(name: "FontAwesome", size: 28) // UIFont(name: "HelveticaNeue-Medium", size: 16)!
        self.currentPage           = position
        self.viewControllers       = elementsController
        self.iconsMenu             = iconsController
        self.scaleMax              = 1.0
        self.scaleMin              = 0.9

    }

    fileprivate func includeControllerOnInterface(_ controller: UIViewController, titleView:UIView, tag:(NSInteger))
    {

        controller.view.clipsToBounds = true;
        controller.view.frame = CGRect(x: self.viewContainer!.contentSize.width, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height - NAV_HEIGHT)
        self.viewContainer?.contentSize = CGSize(width: self.view.frame.size.width + self.viewContainer!.contentSize.width, height: self.view.frame.size.height - NAV_HEIGHT)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
        self.viewContainer?.addSubview(controller.view)

        let tap = UITapGestureRecognizer(target:self, action:#selector(AHPagingMenuViewController.tapOnButton(_:)))
        titleView.addGestureRecognizer(tap)
        titleView.isUserInteractionEnabled = true;
        titleView.tag = tag
        self.navView?.addSubview(titleView);
    }

    func tapOnButton(_ sender: UITapGestureRecognizer)
    {
        if sender.view!.tag != self.currentPage
        {
            var frame = self.viewContainer!.frame
            frame.origin.y = 0;
            frame.origin.x = frame.size.width * CGFloat(sender.view!.tag)
            self.viewContainer?.scrollRectToVisible(frame, animated:true)
        }

    }

    fileprivate func changeColorFrom(_ fromColor: (UIColor), toColor: UIColor, porcent:(CGFloat)) ->UIColor
    {
        var redStart: CGFloat = 0
        var greenStart : CGFloat = 0
        var blueStart: CGFloat = 0
        var alphaStart : CGFloat = 0
        fromColor.getRed(&redStart, green: &greenStart, blue: &blueStart, alpha: &alphaStart)

        var redFinish: CGFloat = 0
        var greenFinish: CGFloat = 0
        var blueFinish: CGFloat = 0
        var alphaFinish: CGFloat = 0
        toColor.getRed(&redFinish, green: &greenFinish, blue: &blueFinish, alpha: &alphaFinish)

        return UIColor(red: (redStart - ((redStart-redFinish) * porcent)) , green: (greenStart - ((greenStart-greenFinish) * porcent)) , blue: (blueStart - ((blueStart-blueFinish) * porcent)) , alpha: (alphaStart - ((alphaStart-alphaFinish) * porcent)));
    }

    // MARK: Setters

    internal func setBounce(_ bounce: Bool)
    {
        self.viewContainer?.bounces = bounce;
        self.bounce = bounce;
    }

    internal func setFade(_ fade: Bool)
    {
        self.fade = fade;
    }

    internal func setTransformScale(_ transformScale: Bool)
    {
        self.transformScale = transformScale

        if (self.isViewLoaded && self.view.window != nil)
        {
            var count = 0
            for titleView in self.iconsMenu! as NSArray as! [UIView]
            {
                let transform = (self.transformScale! ? ( count == self.currentPage ? self.scaleMax: self.scaleMin): self.scaleMax);
                titleView.transform = CGAffineTransform(scaleX: transform!, y: transform!)
                count += 1
            }
        }
    }

    internal func setShowArrow(_ showArrow: Bool)
    {
        self.showArrow = showArrow;

        if (self.isViewLoaded && self.view.window != nil)
        {
            UIView .animate(withDuration: 0.3, animations: { () -> Void in
                self.arrowLeft?.alpha = (self.showArrow! ? (self.currentPage == 0 ? 0.0 : 1.0) : 0.0)
                self.arrowRight?.alpha = (self.showArrow! ? (self.currentPage == self.viewControllers!.count - 1 ? 0.0 : 1.0) :0.0)
                self.viewDidLayoutSubviews()
            })
        }
    }

    internal func setChangeFont(_ changeFont:Bool)
    {
        self.changeFont = changeFont

        if (self.isViewLoaded && self.view.window != nil)
        {
            var count = 0
            for titleView in self.iconsMenu! as NSArray as! [UIView]
            {
                if titleView.isKind(of: UILabel.self)
                {
                    let title = titleView as! UILabel
                    title.font = self.changeFont! ? ( count == self.currentPage ? self.selectedFont : self.dissectedFont ) : self.selectedFont
                    titleView.sizeToFit()
                }

                count += 1
            }
        }
    }

    internal func setChangeColor(_ changeColor: Bool)
    {
        self.changeColor = changeColor;
        if (self.isViewLoaded && self.view.window != nil)
        {
            var count = 0
            for titleView in self.iconsMenu! as NSArray as! [UIView]
            {
                if titleView.isKind(of: UIImageView.self)
                {
                    titleView.tintColor = self.changeColor! ? (count == self.currentPage ? self.selectedColor: self.dissectedColor) :  self.selectedColor
                }
                else if titleView.isKind(of: UILabel.self)
                {
                    let title = titleView as! UILabel
                    title.textColor = (self.changeColor! ? (count == self.currentPage ? self.selectedColor: self.dissectedColor) :  self.selectedColor)
                }

                count += 1
            }
            self.arrowLeft?.tintColor = (self.changeColor! ? self.dissectedColor :  self.selectedColor);
            self.arrowRight?.tintColor = (self.changeColor! ? self.dissectedColor :  self.selectedColor);
        }
    }

    internal func setSelectColor(_ selectedColor: UIColor)
    {
        self.selectedColor = selectedColor

        if (self.isViewLoaded && self.view.window != nil)
        {
            var count = 0
            for titleView in self.iconsMenu! as NSArray as! [UIView]
            {
                if titleView.isKind(of: UIImageView.self)
                {
                    titleView.tintColor = self.changeColor! ? (count == self.currentPage ? self.selectedColor: self.dissectedColor) :  self.selectedColor
                }
                else if titleView.isKind(of: UILabel.self)
                {
                    let title = titleView as! UILabel
                    title.textColor = (self.changeColor! ? (count == self.currentPage ? self.selectedColor: self.dissectedColor) :  self.selectedColor)
                }

                count += 1
            }
            self.arrowLeft?.tintColor = (self.changeColor! ? self.dissectedColor :  self.selectedColor);
            self.arrowRight?.tintColor = (self.changeColor! ? self.dissectedColor :  self.selectedColor);
        }
    }

    internal func setDissectColor(_ dissectedColor: UIColor)
    {
        self.dissectedColor = dissectedColor

        if (self.isViewLoaded && self.view.window != nil)
        {
            var count = 0
            for titleView in self.iconsMenu! as NSArray as! [UIView]
            {
                if titleView.isKind(of: UIImageView.self)
                {
                    titleView.tintColor = self.changeColor! ? (count == self.currentPage ? self.selectedColor: self.dissectedColor) :  self.selectedColor
                }
                else if titleView.isKind(of: UILabel.self)
                {
                    let title = titleView as! UILabel
                    title.textColor = (self.changeColor! ? (count == self.currentPage ? self.selectedColor: self.dissectedColor) :  self.selectedColor)
                }

                count += 1
            }
            self.arrowLeft?.tintColor = (self.changeColor! ? self.dissectedColor :  self.selectedColor);
            self.arrowRight?.tintColor = (self.changeColor! ? self.dissectedColor :  self.selectedColor);
        }
    }

    internal func setSelectFont(_ selectedFont: UIFont)
    {
        self.selectedFont = selectedFont

        if (self.isViewLoaded && self.view.window != nil)
        {
            var count = 0
            for titleView in self.iconsMenu! as NSArray as! [UIView]
            {
                if titleView.isKind(of: UILabel.self)
                {
                    let title = titleView as! UILabel
                    title.font = self.changeFont! ? ( count == self.currentPage ? self.selectedFont : self.dissectedFont ) : self.selectedFont
                    titleView.sizeToFit()
                }

                count += 1
            }
        }
    }

    internal func setDissectFont(_ dissectedFont: UIFont)
    {
        self.dissectedFont = selectedFont

        if (self.isViewLoaded && self.view.window != nil)
        {
            var count = 0
            for titleView in self.iconsMenu! as NSArray as! [UIView]
            {
                if titleView.isKind(of: UILabel.self)
                {
                    let title = titleView as! UILabel
                    title.font = self.changeFont! ? ( count == self.currentPage ? self.selectedFont : self.dissectedFont ) : self.selectedFont
                    titleView.sizeToFit()
                }

                count += 1
            }
        }
    }

    internal func setContentBackgroundColor(_ backgroundColor: UIColor)
    {
        self.viewContainer?.backgroundColor = backgroundColor
    }

    internal func setNavBackgroundColor(_ backgroundColor: UIColor)
    {
        self.navView?.backgroundColor = backgroundColor
    }

    internal func setNavLineBackgroundColor(_ backgroundColor: UIColor)
    {
        self.navLine?.backgroundColor = backgroundColor
    }

    internal func setScaleMax(_ scaleMax: CGFloat, scaleMin:CGFloat)
    {
        if scaleMax < scaleMin || scaleMin < 0.0  || scaleMax < 0.0
        {
            return;
        }

        self.scaleMax = scaleMax;
        self.scaleMin = scaleMin;

        if (self.isViewLoaded && self.transformScale == true && self.view.window != nil)
        {
            var count = 0
            for titleView in self.iconsMenu! as NSArray as! [UIView]
            {
                let transform = (self.transformScale! ? ( count == self.currentPage ? self.scaleMax: self.scaleMin): self.scaleMax);

                titleView.transform = CGAffineTransform(scaleX: transform!,y: transform!)

                if titleView.isKind(of: UILabel.self)
                {
                    titleView.sizeToFit()
                }

                count += 1
            }
        }

    }

    // MARK: UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {

        if scrollView == self.viewContainer
        {
            let xPosition = scrollView.contentOffset.x;
            let fractionalPage = Float(xPosition / scrollView.frame.size.width);
            let currentPage = Int(round(fractionalPage));

            if fractionalPage == Float(currentPage) && currentPage != self.currentPage
            {
                self.delegate?.AHPagingMenuDidChangeMenuPosition?(self.currentPage, to: currentPage)
                self.delegate?.AHPagingMenuDidChangeMenuFrom?(self.viewControllers!.object(at: self.currentPage) as AnyObject, to: self.viewControllers!.object(at: currentPage) as AnyObject)
                self.currentPage = currentPage;

            }

            let porcent = fabs(fractionalPage - Float(currentPage))/0.5;

            if self.showArrow!
            {
                if currentPage <= 0
                {
                    self.arrowLeft?.alpha = 0;
                    self.arrowRight?.alpha = 1.0 - CGFloat(porcent);
                }
                else if currentPage >= self.iconsMenu!.count - 1
                {
                    self.arrowLeft?.alpha = 1.0 - CGFloat(porcent);
                    self.arrowRight?.alpha = 0.0;
                }
                else
                {
                    self.arrowLeft?.alpha = 1.0 - CGFloat(porcent);
                    self.arrowRight?.alpha = 1.0 - CGFloat(porcent);
                }

            }
            else
            {
                self.arrowLeft?.alpha = 0;
                self.arrowRight?.alpha = 0;
            }

            var count = 0;
            for titleView in self.iconsMenu! as NSArray as! [UIView]
            {
                titleView.alpha = CGFloat (( self.fade! ? (count <= (currentPage + 1) && count >= (currentPage - 1) ? 1.3 - porcent : 0.0 ) : (count <= self.currentPage + 1 || count >= self.currentPage - 1 ? 1.0: 0.0)))

                let spacing  = (self.view.frame.size.width/2.0) - self.NAV_SPACE_VALUE - titleView.frame.size.width/2 - (self.showArrow! ? self.arrowLeft!.image!.size.width : 0.0)

                titleView.center = CGPoint(x: self.navView!.center.x + (spacing * CGFloat(count)) - (CGFloat(fractionalPage) * spacing), y: self.navView!.center.y + (UIApplication.shared.statusBarFrame.size.height/2.0))
                let distance_center = CGFloat(fabs(titleView.center.x - self.navView!.center.x))

                if titleView.isKind(of: UIImageView.self)
                {
                    if( distance_center < spacing)
                    {
                        if self.changeColor!
                        {
                            titleView.tintColor =  self.changeColorFrom(self.selectedColor, toColor: self.dissectedColor, porcent: distance_center/spacing)
                        }
                    }
                }
                else if titleView.isKind(of: UILabel.self)
                {
                    let titleText = titleView as! UILabel;

                    if( distance_center < spacing)
                    {
                        if self.changeColor!
                        {
                            titleText.textColor = self.changeColorFrom(self.selectedColor, toColor: self.dissectedColor, porcent: distance_center/spacing)
                        }

                        if self.changeFont!
                        {
                            titleText.font = (distance_center < spacing/2.0 ? self.selectedFont : self.dissectedFont)
                            titleText.sizeToFit()
                        }

                    }

                }

                if (self.transformScale! && count <= (currentPage + 1) && count >= (currentPage - 1))
                {
                    let transform = CGFloat(self.scaleMax! + ((self.scaleMax! - self.scaleMin!) * (-distance_center/spacing)))
                    titleView.transform = CGAffineTransform(scaleX: transform, y: transform);
                }

                count += 1;
            }

        }

    }

}

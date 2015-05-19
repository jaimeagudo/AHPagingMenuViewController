//
//  Example5ViewController.swift
//  Demo
//
//  Created by André Henrique Silva on 18/05/15.
//  Copyright (c) 2015 André Henrique Silva. All rights reserved.
//

import UIKit

class Example5ViewController: UIViewController {
    
    var current = 1;
    
    @IBAction func randonNavColor(sender: AnyObject) {
    
    }

    @IBAction func randNavColorMain(sender: AnyObject) {
        self.pagingMenuViewController().setChangeColor(!self.pagingMenuViewController().changeFont)
    }
 
    @IBAction func changeFont(sender: AnyObject) {
        self.pagingMenuViewController().setChangeFont(!self.pagingMenuViewController().changeFont)
    }

    @IBAction func changeFace(sender: AnyObject) {
        self.pagingMenuViewController().setFade(!self.pagingMenuViewController().fade)
    }
    
    @IBAction func changeTransform(sender: AnyObject)
    {
        self.pagingMenuViewController().setTransformScale(!self.pagingMenuViewController().transformScale);
    }
    
    @IBAction func changeArrow(sender: AnyObject)
    {
        self.pagingMenuViewController().setShowArrow(!self.pagingMenuViewController().showArrow)
    }
    
    @IBAction func goFirst(sender: AnyObject)
    {
        self.pagingMenuViewController().setPosition(0 , animated: true)
    
    }

    @IBAction func addController(sender: AnyObject)
    {
        var newController = ExampleViewController.new();
        newController.view.backgroundColor = self.getRandomColor();
        self.pagingMenuViewController().addNewController(newController, title: "New \(current)")
        self.pagingMenuViewController().setPosition(self.pagingMenuViewController().viewControllers!.count - 1, animated: true)
        self.current++;
    }
    
    @IBAction func goLast(sender: AnyObject)
    {
        self.pagingMenuViewController().setPosition(self.pagingMenuViewController().viewControllers!.count - 1, animated: true)
    
    }
    
    @IBAction func goNext(sender: AnyObject)
    {
        self.pagingMenuViewController().setPosition(self.pagingMenuViewController().currentPage + 1, animated: true)
    }
    
    @IBAction func goPrevius(sender: AnyObject)
    {
         self.pagingMenuViewController().setPosition(self.pagingMenuViewController().currentPage - 1, animated: true)
    }
    
    @IBAction func changeSecondFont(sender: AnyObject)
    {
        self.pagingMenuViewController().setDissectFont(UIFont(name: "Chalkduster", size: 16)!)
    }
    
    @IBAction func changeMainFont(sender: AnyObject)
    {
          self.pagingMenuViewController().setSelectFont(UIFont(name: "BradleyHandITCTT-Bold", size: 16)!)
    }
    
    @IBAction func randonNavTitleTransform(sender: AnyObject)
    {
        var scale = CGFloat(arc4random_uniform(10)) / 10.0
        self.pagingMenuViewController().setScaleMax(scale + 0.5, scaleMin: scale)
    }

    @IBAction func randonSecondColor(sender: AnyObject)
    {
        self.pagingMenuViewController().setDissectColor(self.getRandomColor())
    }
    
    @IBAction func randonFirstColor(sender: AnyObject)
    {
        self.pagingMenuViewController().setSelectColor(self.getRandomColor())
    }
    
    @IBAction func changeBounce(sender: AnyObject)
    {
        self.pagingMenuViewController().setBounce(!self.pagingMenuViewController().bounce)
    }
    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
}

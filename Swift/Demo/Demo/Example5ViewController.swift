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
    
    @IBAction func randonNavColor(_ sender: AnyObject) {
    
    }

    @IBAction func randNavColorMain(_ sender: AnyObject) {
        self.pagingMenuViewController().setChangeColor(!self.pagingMenuViewController().changeFont)
    }
 
    @IBAction func changeFont(_ sender: AnyObject) {
        self.pagingMenuViewController().setChangeFont(!self.pagingMenuViewController().changeFont)
    }

    @IBAction func changeFace(_ sender: AnyObject) {
        self.pagingMenuViewController().setFade(!self.pagingMenuViewController().fade)
    }
    
    @IBAction func changeTransform(_ sender: AnyObject)
    {
        self.pagingMenuViewController().setTransformScale(!self.pagingMenuViewController().transformScale);
    }
    
    @IBAction func changeArrow(_ sender: AnyObject)
    {
        self.pagingMenuViewController().setShowArrow(!self.pagingMenuViewController().showArrow)
    }
    
    @IBAction func goFirst(_ sender: AnyObject)
    {
        self.pagingMenuViewController().setPosition(0 , animated: true)
    
    }

    @IBAction func addController(_ sender: AnyObject)
    {
        let newController = ExampleViewController()
        newController.view.backgroundColor = self.getRandomColor();
        self.pagingMenuViewController().addNewController(newController, title: "New \(current)" as AnyObject)
        self.pagingMenuViewController().setPosition(self.pagingMenuViewController().viewControllers!.count - 1, animated: true)
        self.current += 1;
    }
    
    @IBAction func goLast(_ sender: AnyObject)
    {
        self.pagingMenuViewController().setPosition(self.pagingMenuViewController().viewControllers!.count - 1, animated: true)
    
    }
    
    @IBAction func goNext(_ sender: AnyObject)
    {
        self.pagingMenuViewController().setPosition(self.pagingMenuViewController().currentPage + 1, animated: true)
    }
    
    @IBAction func goPrevius(_ sender: AnyObject)
    {
         self.pagingMenuViewController().setPosition(self.pagingMenuViewController().currentPage - 1, animated: true)
    }
    
    @IBAction func changeSecondFont(_ sender: AnyObject)
    {
        let font = UIFont.init(name: "Chalkduster", size: CGFloat(16))
        self.pagingMenuViewController().setDissectFont(font!)

    }
    
    @IBAction func changeMainFont(_ sender: AnyObject)
    {
        let font = UIFont.init(name: "BradleyHandITCTT-Bold", size: CGFloat(16))
        self.pagingMenuViewController().setSelectFont(font!)
    }
    
    @IBAction func randonNavTitleTransform(_ sender: AnyObject)
    {
        let scale = CGFloat(arc4random_uniform(10)) / 10.0
        self.pagingMenuViewController().setScaleMax(scale + 0.5, scaleMin: scale)
    }

    @IBAction func randonSecondColor(_ sender: AnyObject)
    {
        self.pagingMenuViewController().setDissectColor(self.getRandomColor())
    }
    
    @IBAction func randonFirstColor(_ sender: AnyObject)
    {
        self.pagingMenuViewController().setSelectColor(self.getRandomColor())
    }
    
    @IBAction func changeBounce(_ sender: AnyObject)
    {
        self.pagingMenuViewController().setBounce(!self.pagingMenuViewController().bounce)
    }
    
    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
}

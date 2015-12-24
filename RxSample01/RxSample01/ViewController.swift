//
//  ViewController.swift
//  RxSample01
//
//  Created by KAZUYOSHI UENO on 2015/12/24.
//  Copyright © 2015年 KAZUYOSHI UENO. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    //
    // MARK: - Outlets -
    //
    @IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var textField01: UITextField!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var textField02: UITextField!
    @IBOutlet weak var dispatchBtn: UIButton!
    @IBOutlet weak var textField03: UITextField!
    //
    // MARK: - variables -
    //
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sample()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func sample() {
        
        // 基本的な振る舞い
        ["hello", "world"].toObservable().subscribeNext({ str -> Void in print(str) }).addDisposableTo(disposeBag)
        
        // UIButtnのタップ取得
        myButton.rx_tap.subscribeNext({ print("btn tapped") }).addDisposableTo(disposeBag)
        
        // UxTextFieldのフィルタリング、入力イベント取得
        textField01.rx_text.filter( { str -> Bool in str.characters.count >= 3 } )
            .subscribeNext({ str -> Void in print(str) })
        .addDisposableTo(disposeBag)
        
        // UISliderの変更イベント、値加工、TextFieldへのバインド
        slider.rx_value
            .map({ String($0) })
        .bindTo(textField02.rx_text)
        .addDisposableTo(disposeBag)
        
        // エラーの伝搬をしたい時も便利
        //  エラーの取り回しを例外を使わずに行うことができる
        //  / flatMap内でjust(値）を返せば成功値を伝搬させることができる
        //  / flatMapないでfailWith(NSError)を返せばエラーを伝搬させることができる
        dispatchBtn.rx_tap.flatMap { () -> Observable<String> in
            print("flat")
            if (self.textField03.text?.characters.count > 0) ?? false {
                return just(String(self.textField03.text))
            } else {
                return failWith(NSError(domain: "app error", code: -1, userInfo: nil))
            }
        }

        //.catchErrorJustReturn("5")

        .subscribe(
            onNext: { print("値は\($0)") },
            onError: { _ in print("") },
            onCompleted: nil,
            onDisposed: nil
        )
        .addDisposableTo(disposeBag)
    }

}


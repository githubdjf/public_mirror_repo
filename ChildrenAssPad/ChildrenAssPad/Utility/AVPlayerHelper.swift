//
//  AVPlayerHelper.swift
//  FirstEducation
//
//  Created by 李雪 on 2018/11/21.
//  Copyright © 2018年 yitai. All rights reserved.
//

import UIKit
import AVFoundation

enum PlayerStatus {
    case Non
    case LoadSongInfo
    case ReadyToPlay
    case Play
    case Pause
    case Finished
    case Replay
}



class AVPlayerHelper: NSObject {

    static let `default` = AVPlayerHelper()
    var avPlayer: AVPlayer?
    var status: PlayerStatus!

    let notifyChange = "notifyChange"

    var timeObsever: Any?

    var progress = 0.0
    var playTime: String?
    var playDuration: String?

    var isPlaying: Bool{

        //播放器播放状态
        get {
            return self.avPlayer?.rate == 1
        }
    }


    override init() {
        super.init()

    }


    //开始加载音频
    func loadAudio(audioUrl: String, isLocal: Bool = false) -> Void {

        var audioURL = URL.init(string: "")

        if !isLocal {
            audioURL = URL.init(string: audioUrl)

        }else{
            let audioPath = Bundle.main.path(forResource: audioUrl, ofType: ".mp3")
            audioURL = URL.init(fileURLWithPath: audioPath ?? "")
        }

        if let url = audioURL {

            let audioItem = AVPlayerItem.init(url: url)
            if avPlayer == nil {
                avPlayer = AVPlayer.init(playerItem: audioItem)

            } else {
                avPlayer?.replaceCurrentItem(with: audioItem)
            }
        }

        //给当前音频添加监控
        addObserver()

        //给状态赋值
        status = PlayerStatus.LoadSongInfo

        NotificationCenter.default.post(name: NSNotification.Name.init(notifyChange), object: nil)
    }

    //添加观察者
    func addObserver(){

        let curItem = self.avPlayer?.currentItem

        //观察播放结束时的状态
        NotificationCenter.default.addObserver(self, selector:#selector(playbackFinished) , name:Notification.Name.AVPlayerItemDidPlayToEndTime , object: curItem)

        //观察status 属性观察状态
        curItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)

        //观察进度
        timeObsever = avPlayer?.addPeriodicTimeObserver(forInterval: CMTime.init(value: CMTimeValue.init(1.0), timescale: CMTimeScale.init(1.0)), queue: DispatchQueue.main, using: {[weak self] (time) in

            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds((curItem?.duration)!)

            if let weakSelf = self {

                if total > 0 {
                    weakSelf.progress = current / total
                    weakSelf.playTime = String.init(format: "%.f", current)
                    weakSelf.playDuration = String.init(format: "%.2f", total)

                    print("weakSelf.playDuration \(String(describing: weakSelf.playDuration))")
                    print("weakSelf.playTime \(String(describing: weakSelf.playTime))")
                }
            }
        })


        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(becomeDeth), name:UIApplication.willResignActiveNotification, object: nil)
    }

    //移除观察者
    func removeObserver(){

        let curItem = avPlayer?.currentItem
        curItem?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)

        if let _ = timeObsever {

            avPlayer?.removeTimeObserver(timeObsever!)
            timeObsever = nil
        }
    }


    //MARK:播放完毕
    @objc func playbackFinished(){

        self.status = PlayerStatus.Finished
        NotificationCenter.default.post(name: Notification.Name.init(notifyChange), object: nil)
        print("播放完毕")

    }


    //MARK: 开始播放
    func startPlay() {

        if (self.status == PlayerStatus.Pause || self.status == PlayerStatus.Replay) {
            self.status = PlayerStatus.Play
            NotificationCenter.default.post(name: Notification.Name.init(notifyChange), object: nil)
        }

        avPlayer?.play()

        print("正在播放")
    }


    //MARK: 暂停播放
    func pausePlay() {

        if let player = avPlayer {

            print("暂停播放")

            self.status = PlayerStatus.Pause
            player.pause()
            NotificationCenter.default.post(name: Notification.Name.init(notifyChange), object: nil)
        }
    }

    //MARK: 重新播放
    func replay() {

        print("重新播放")

        let curItem = avPlayer?.currentItem
        curItem?.seek(to: CMTime.init(value: CMTimeValue.init(1.0), timescale: CMTimeScale.init(1.0)), completionHandler: {[weak self] (finished) in

            if let weakSelf = self {

                weakSelf.status = PlayerStatus.Replay
                NotificationCenter.default.post(name: Notification.Name.init(weakSelf.notifyChange), object: nil)

                weakSelf.startPlay()
            }

        })
    }


    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "status" {

            if let status = avPlayer?.status{
                switch status {
                case .unknown:
                    print("未知状态，不能播放")
                    break
                case .readyToPlay:
                    self.status = PlayerStatus.ReadyToPlay
                    print("准备完毕，可以播放")
                    startPlay()
                    break
                case .failed:
                    print("出现错误")

                }

                NotificationCenter.default.post(name: Notification.Name.init(notifyChange), object: nil)

            }
        }
    }

    //进入前台
    @objc func becomeActive() {

        startPlay()

    }

    //进入后台
    @objc func becomeDeth(){

        pausePlay()
    }

    deinit {
        print("AVPlayerHelper释放了")
        removeObserver()
    }

}

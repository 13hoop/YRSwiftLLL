//
//  Audio.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/9/23.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation
import AVFoundation



/**************************************************************
 |                         audio server                        |
 **************************************************************/
final class YRAudioService: NSObject {

    struct AudioRecord {
        static let shortestDuration: NSTimeInterval = 1.0
        static let longestDuration: NSTimeInterval = 60
    }


    static let defaultService = YRAudioService()

    var checkRecordTimeoutTimer: NSTimer?
    var recordTimeoutAction: (() -> Void)?
    
    var shouldIgnoreStart = false

    var audioFileURL: NSURL?
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVPlayer?
    var onlineAudioPlayer: AVPlayer?

    
//    var audioPlayCurrentTime: NSTimeInterval {
//        if let audioPlayer = audioPlayer {
//            return audioPlayer.currentItem
//        }
//        return 0
//    }
    var audioOnlinePlayCurrentTime: CMTime {
        if let audioOnlinePlayItem = onlineAudioPlayer?.currentItem {
            return audioOnlinePlayItem.currentTime()
        }
        return CMTime()
    }
    
    let queue = dispatch_queue_create("YRAudioService", DISPATCH_QUEUE_SERIAL)

    func yr_beginRecordWithFileURL(fileURL: NSURL, audioDelegate: AVAudioRecorderDelegate) {

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        } catch let error {
            print("beginRecordWithFileURL set category failed: \(error)")
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("action error : \(error)")
        }

        do {
            yr_proposeToAuth(.Microphone, agreed: {

                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
                } catch let error {
                    print(error)
                }

                self.yr_prepareRecordWithFileURL(fileURL, audioRecordDelegate: audioDelegate)

                if let audioRecorder = self.audioRecorder {
                    print(" - 🎙️🎙️🎙️accessed  and  beging ing ing ... ...🎙️🎙️🎙️ - ")
                    if audioRecorder.recording {
                        audioRecorder.stop()

                        // timer end

                    }else {
                        if !self.shouldIgnoreStart {
                            audioRecorder.record()
                            print(" － 0️⃣ －> audio record did start ")
                        }
                    }
                }
            }, rejected: {
                if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate,
                    viewController = appDelegate.window?.rootViewController {
                        viewController.cannotAllowedToAcessMicro()
                }
            })
        }
    }
    func yr_endRecord() {
        if let audioRecorder = self.audioRecorder {
            if audioRecorder.recording {
                audioRecorder.stop()
            }
        }
        
        dispatch_async(queue) {
            let _ = try? AVAudioSession.sharedInstance().setActive(false, withOptions: .NotifyOthersOnDeactivation)
        }
        
        // timer end
        self.checkRecordTimeoutTimer?.invalidate()
        self.checkRecordTimeoutTimer = nil
    }
    func yr_prepareRecordWithFileURL(fileURL: NSURL, audioRecordDelegate: AVAudioRecorderDelegate) {

        audioFileURL = fileURL
        let recordConfig: [String : AnyObject] = [
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVEncoderAudioQualityKey : AVAudioQuality.High.rawValue,
            AVEncoderBitRateKey : 64000,
            AVNumberOfChannelsKey : 2,
            AVSampleRateKey : 44100.0 ]

        print(fileURL)

        do {
            let audioRecorder = try AVAudioRecorder(URL: fileURL, settings: recordConfig)
            audioRecorder.delegate = audioRecordDelegate
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord() // write or overwite the file

            self.audioRecorder = audioRecorder

        } catch let error {
            self.audioRecorder = nil
            print("prepare AVAudioRecorder error: \(error)")
        }
    }


    func startCheckRecordTimeoutTimer() {

        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.checkRecordTimeout(_:)), userInfo: nil, repeats: true)

        checkRecordTimeoutTimer = timer

        timer.fire()
    }
    func checkRecordTimeout(timer: NSTimer) {

        if audioRecorder?.currentTime >  AudioRecord.longestDuration {
            endRecord()
            recordTimeoutAction?()
            recordTimeoutAction = nil
        }
    }

    func endRecord() {
        if let audioRecorder = self.audioRecorder {
            if audioRecorder.recording {
                audioRecorder.stop()
            }
        }
        self.checkRecordTimeoutTimer?.invalidate()
        self.checkRecordTimeoutTimer = nil
    }
}











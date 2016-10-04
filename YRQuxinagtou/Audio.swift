//
//  Audio.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/9/23.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation
import AVFoundation
import AVOSCloudIM


/**************************************************************
 |                         audio server                        |
 **************************************************************/
final class YRAudioService: NSObject {

    struct AudioRecord {
        static let shortestDuration: NSTimeInterval = 1.0
        static let longestDuration: NSTimeInterval = 60
    }

    static let defaultService = YRAudioService()

    // record
    var checkRecordTimeoutTimer: NSTimer?
    var recordTimeoutAction: (() -> Void)?
    
    var shouldIgnoreStart = false
    
    var audioFileURL: NSURL?
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var onlineAudioPlayer: AVAudioPlayer?

    
//    var audioPlayCurrentTime: CMTime {
//        if let audioPlayer = audioPlayer {
//            return audioPlayer.currentTime()
//        }
//        return CMTime()
//    }
//    var audioOnlinePlayCurrentTime: CMTime {
//        if let audioOnlinePlayItem = onlineAudioPlayer?.currentItem {
//            return audioOnlinePlayItem.currentTime()
//        }
//        return CMTime()
//    }
    
    let queue = dispatch_queue_create("YRAudioService", DISPATCH_QUEUE_SERIAL)

    func yr_beginRecordWithFileURL(fileURL: NSURL, audioDelegate: AVAudioRecorderDelegate) {

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        } catch let error {
            print("beginRecordWithFileURL set category failed: \(error)")
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(false, withOptions: .NotifyOthersOnDeactivation)
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
                        print(" is audioRecorder.recording ing ing ing .... ")
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
        
        do {
            try AVAudioSession.sharedInstance().setActive(false, withOptions: .NotifyOthersOnDeactivation)
        }catch {
            print(" set active false error \(error)")
        }
    
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
            self.audioRecorder = audioRecorder

            print(" -----------------------")
            print(self.audioRecorder)
            print(" -----------------------")

            self.audioRecorder!.delegate = audioRecordDelegate
            self.audioRecorder!.meteringEnabled = true
            self.audioRecorder!.prepareToRecord() // write or overwite the file

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
        recordTimeoutAction?()
//        print(" ...  ing  \(audioPlayer?.currentTime)  ing  ... ")
//        if audioRecorder?.currentTime >  AudioRecord.longestDuration {
//            endRecord()
//            recordTimeoutAction = nil
//        }
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
    
    // play
    var playbackTimer: NSTimer? {
        didSet {
            if let oldPlaybackTimer = oldValue {
                oldPlaybackTimer.invalidate()
            }
        }
    }
    
    func yr_playMessage(message msg: AVIMAudioMessage, begin time: NSTimeInterval, delegate: AVAudioPlayerDelegate, success callBack: ()-> Void) {
        
        if let audioFile = msg.file.url {
            do {
                
                guard let url = NSURL(string: audioFile) else {
                    return
                }
                
                let player = try AVAudioPlayer(contentsOfURL: url)
                self.audioPlayer = player
                self.audioPlayer?.delegate = delegate
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.currentTime = time
                
                if self.audioPlayer!.play() {
                    print(" 💤💤  begin play...  💤💤")
                    callBack()
                }else {
                    print(" download audio .... ")
                }
            }catch {
            
            }
        }
    }
}

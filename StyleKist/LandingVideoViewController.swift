//
//  LandingVideoViewController.swift
//  StyleKist
//
//  Created by Svyatoshenko "Megal" Misha on 2016-10-10.
//  Copyright © 2016年 Svyatoshenko "Megal" Misha. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

@IBDesignable
class LandingVideoViewController: AVPlayerViewController {

	@IBInspectable
	var video: String = "landing_video.mp4"

	deinit {
		unsingNotifications()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		//Not affecting background music playing
		do {
			let audiosession = AVAudioSession.sharedInstance();
			try audiosession.setCategory(AVAudioSessionCategoryAmbient)
			try audiosession.setActive(true)
		}
		catch {
			NSLog(error.localizedDescription);
		}

		//Set up player
		let videoPath = Bundle.main.path(forResource: video, ofType: nil)!
		let movieURL = URL(fileURLWithPath: videoPath)
		let avAsset = AVAsset(url: movieURL);

		let avPlayerItem = AVPlayerItem(asset: avAsset);
		self.player = AVPlayer(playerItem: avPlayerItem);

		self.showsPlaybackControls = false;

		//Config player
		self.player?.seek(to: kCMTimeZero);
		self.player?.volume = 0.0;

		signNotifications()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated);

		self.player?.play();
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated);

		self.player?.pause();
	}


// MARK: NotificationCenter sign

	func signNotifications() {
		let nc = NotificationCenter.default
		nc.addObserver(
			self,
			selector: #selector(playerItemDidReachEnd),
			name: .AVPlayerItemDidPlayToEndTime,
			object: self.player?.currentItem)

	}

	func unsingNotifications() {
		NotificationCenter.default.removeObserver(self)
	}


// MARK: AVPlayer routine notifications

	func playerItemDidReachEnd() {
		self.player?.currentItem?.seek(to: kCMTimeZero)
	}

	func playerStartPlaying() {
		self.player?.play();
	}

}

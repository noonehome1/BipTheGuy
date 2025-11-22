//
//  ContentView.swift
//  BipTheGuy
//
//  Created by Paul Wagstaff on 2025-11-21.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var isFullSize : Bool = true
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var bipImage = Image("clown")
    
    var body: some View {
        VStack {
            Spacer()
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(isFullSize ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundName: "punchSound")
                    isFullSize = false
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
                        isFullSize = true
                    }
                }
            Spacer()
            PhotosPicker(selection: $selectedPhoto) {
                Label("Photo Library", systemImage:  "photo.on.rectangle.angled.fill")
            }
            .onChange(of: selectedPhoto) {
                Task {
                    guard let selectedImage = try? await selectedPhoto?.loadTransferable(type: Image.self) else {
                        print("😡 ERROR: Could not load Image from loadTransferable")
                        return
                    }
                    bipImage = selectedImage
                }
            }
        }
        .padding()
    }
    
    func playSound(soundName: String) {
        if (audioPlayer != nil && audioPlayer.isPlaying) {
            audioPlayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer")
        }
    }
    
}

#Preview {
    ContentView()
}

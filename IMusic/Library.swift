//
//  Library.swift
//  IMusic
//
//  Created by Kirill Manvelov on 18.08.2020.
//  Copyright © 2020 Kirill Manvelov. All rights reserved.
//

import SwiftUI
import URLImage

struct Library: View {
    
    @State var tracks = UserDefaults.standard.savedTracks()
    @State var isTapped: Bool = false
    @State var trackToRemove: SearchViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20){
                        Button(action: {
                            self.tabBarDelegate?.maximazeTrackDetailsView(viewModel: self.tracks[0])
                        }, label: {
                            Image(systemName: "play.fill")
                        })
                            .frame(width: geometry.size.width/2 - 10, height: 50)
                            .accentColor(Color.init(#colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)))
                            .background(Color.init(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                            .cornerRadius(10)
                        Button(action: {
                            self.tracks = UserDefaults.standard.savedTracks()
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width/2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                                .cornerRadius(10)
                        })
                    }
                }
                .padding()
                .frame(height: 50)
                Divider().padding(.leading).padding(.trailing)
                List{
                    ForEach(tracks){ track in
                        LibraryCell(track: track).gesture(
                            LongPressGesture()
                                .onEnded({ (_) in
                            self.isTapped = true
                            self.trackToRemove = track
                                }).simultaneously(with: TapGesture().onEnded({ (_) in
                                    self.tabBarDelegate?.maximazeTrackDetailsView(viewModel: track)
                                })))
                    }.onDelete(perform: delete)
                }
            }.actionSheet(isPresented: $isTapped, content: { () -> ActionSheet in
                ActionSheet(title: Text("Are you sure?"),
                            buttons: [ .destructive(Text("Delete"), action: {
                                self.delete(track: self.trackToRemove)
                            }), .cancel()
                ])
            })
                
                .navigationBarTitle(Text("Library"))
        }
    }
    
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: UserDefaults.favouriteTracksKey)
        }
    }
    
    func delete(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        if let myIndex = index {
            tracks.remove(at: myIndex)
            if let data = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
                let defaults = UserDefaults.standard
                defaults.set(data, forKey: UserDefaults.favouriteTracksKey)
            }
        }
        
    }
}

struct LibraryCell: View {
    var track: SearchViewModel.Cell
    var body: some View {
        HStack {
            URLImage(URL(string: track.iconUrlString ?? "")!).frame(width: 60, height: 60).cornerRadius(2)
            VStack(alignment: .leading) {
                Text("\(track.trackName)")
                Text("\(track.artistName)")
            }
            
        }
        
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

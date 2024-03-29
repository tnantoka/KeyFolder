//
//  EntryListView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct EntryListPage: View {
  @EnvironmentObject private var store: Store
  @State private var previwingId = ""
  @State private var isPreviwing = false
  @State private var isEditing = false
  @State private var isPickingPhotos = false
  @State private var isPickingFiles = false
  @State private var isDeleting = false
  @State private var isShowingMenu = false
  @Binding var isLocked: Bool

  let folder: Folder

  var body: some View {
    let entries = store.entries.filter { entry in
      entry.folder.id == folder.id
    }.sorted { $0.name < $1.name }
    VStack {
      List(entries, id: \.id) { entry in
        Button(
          action: {
            previwingId = entry.id
            isPreviwing = true
          },
          label: {
            HStack {
              Button {
                store.select(entry: entry, isSelected: !entry.isSelected)
              } label: {
                if entry.isSelected {
                  Image(systemName: "checkmark.circle")
                } else {
                  Image(systemName: entry.icon)
                }
              }
              .buttonStyle(PlainButtonStyle())
              .frame(width: 32)
              Text(entry.name)
            }
          }
        )
      }
      .listStyle(PlainListStyle())
      AdBanner(isLocked: $isLocked)
    }
    .navigationBarTitle("Entries", displayMode: .inline)
    .navigationBarItems(
      trailing: HStack {
        if entries.first(where: { folder in folder.isSelected }) == nil {
          Button(
            action: {
              isShowingMenu = true
            },
            label: {
              Image(systemName: "plus")
            }
          )
          .actionSheet(isPresented: $isShowingMenu) {
            ActionSheet(
              title: Text("Menu"),
              buttons: [
                .default(Text("From photo library")) {
                  isPickingPhotos = true
                },
                .default(Text("From files")) {
                  isPickingFiles = true
                },
                .cancel(Text("Cancel")),
              ]
            )
          }
        } else {
          Button(
            action: {
              isEditing = true
            },
            label: {
              Image(systemName: "pencil")
            }
          )
          Button(
            action: {
              isDeleting = true
            },
            label: {
              Image(systemName: "trash")
            }
          )
        }
      }
    )
    .fullScreenCover(isPresented: $isPreviwing) {
      QuickLook(entries: entries, isPresented: $isPreviwing, initialEntryId: $previwingId)
    }
    .sheet(isPresented: $isEditing) {
      let entry = entries.first { entry in entry.isSelected }
      EntryForm(
        isShowing: $isEditing,
        name: entry?.name ?? "",
        folderId: entry?.folder.id ?? ""
      )
    }
    .sheet(isPresented: $isPickingPhotos) {
      ImagePicker(
        isPresented: $isPickingPhotos,
        onPickImage: {
          image
          in
          store.addEntry(folder: folder, image: image)
        },
        onPickMovie: { url in
          store.addEntry(folder: folder, movieURL: url)
        }
      )
    }
    .sheet(isPresented: $isPickingFiles) {
      DocumentPicker(
        onPickImage: { url in
          store.addEntry(folder: folder, imageURL: url)
        },
        onPickMovie: { url in
          store.addEntry(folder: folder, movieURL: url)
        }
      )
    }
    .alert(isPresented: $isDeleting) {
      Alert(
        title: Text("Delete"),
        message: Text("Are you sure?"),
        primaryButton: .destructive(Text("Delete")) {
          if let entry = entries.first(where: { entry in entry.isSelected }) {
            store.delete(entry: entry)
          }
        },
        secondaryButton: .cancel(Text("Cancel"))
      )
    }
    .onReceive(
      NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    ) { _ in
      previwingId = ""
      isPreviwing = false
      isEditing = false
      isPickingPhotos = false
      isPickingFiles = false
      isDeleting = false
      isShowingMenu = false
    }
    .opacity(isLocked ? 0 : 1)
  }
}

struct EntryListPage_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      EntryListPage(isLocked: .constant(false), folder: Folder(name: "example"))
        .environmentObject(Store())
    }
  }
}

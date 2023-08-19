//
//  FolderListView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct FolderListView: View {
  @EnvironmentObject private var store: Store

  @State private var isShowingMenu = false
  @State private var isShowingLicenses = false
  @State private var isChangingPasscode = false
  @State private var isCreating = false
  @State private var isEditing = false
  @State private var isDeleting = false

  @Binding var isLocked: Bool

  var body: some View {
    VStack {
      List(store.folders.sorted { $0.name < $1.name }, id: \.id) { folder in
        NavigationLink {
          EntryListView(isLocked: $isLocked, folder: folder)
        } label: {
          HStack {
            Button {
              store.select(folder: folder, isSelected: !folder.isSelected)
            } label: {
              if folder.isSelected {
                Image(systemName: "checkmark.circle")
              } else {
                Image(systemName: "folder")
              }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 32)
            Text(folder.name)
          }
        }
      }
      .listStyle(PlainListStyle())
      AdBannerView()
    }
    .navigationBarTitle("Folders", displayMode: .inline)
    .navigationBarItems(
      leading: Button(
        action: {
          isShowingMenu = true
        },
        label: {
          Image(systemName: "gearshape")
        }
      )
      .padding(.leading, 6)
      .actionSheet(isPresented: $isShowingMenu) {
        ActionSheet(
          title: Text("Menu"),
          buttons: [
            .default(Text("Change passcode")) {
              isChangingPasscode = true
            },
            .default(Text("Acknowledgements")) {
              isShowingLicenses = true
            },
            .cancel(Text("Cancel")),
          ])
      },
      trailing: HStack {
        if store.folders.first(where: { folder in folder.isSelected }) == nil {
          Button(
            action: {
              isCreating = true
            },
            label: {
              Image(systemName: "plus")
            })
        } else {
          Button(
            action: {
              isEditing = true
            },
            label: {
              Image(systemName: "pencil")
            })
          Button(
            action: {
              isDeleting = true
            },
            label: {
              Image(systemName: "trash")
            })
        }
      }
    )
    .alert(isPresented: $isDeleting) {
      Alert(
        title: Text("Delete"),
        message: Text("Are you sure?"),
        primaryButton: .destructive(Text("Delete")) {
          if let folder = store.folders.first(where: { folder in folder.isSelected }) {
            store.delete(folder: folder)
          }
        }, secondaryButton: .cancel(Text("Cancel")))
    }
    .sheet(isPresented: $isCreating) {
      CreateFolderPage(isShowing: $isCreating)
    }
    .sheet(isPresented: $isEditing) {
      UpdateFolderPage(
        isShowing: $isEditing,
        name: store.folders.first { folder in folder.isSelected }?.name ?? ""
      )
    }
    .sheet(isPresented: $isChangingPasscode) {
      ChangePasscodePage(isShowing: $isChangingPasscode)
    }
    .sheet(isPresented: $isShowingLicenses) {
      LicensesView(isShowing: $isShowingLicenses)
    }
    .onReceive(
      NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    ) { _ in
      isShowingMenu = false
      isShowingLicenses = false
      isChangingPasscode = false
      isCreating = false
      isEditing = false
      isDeleting = false
    }
    .opacity(isLocked ? 0 : 1)
  }
}

struct FolderListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      FolderListView(isLocked: .constant(false))
    }
  }
}

//
//  UpdateTagView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/10/25.
//

import SwiftUI

struct UpdateTagView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var mainViewModel: MainViewModel

    @State var tag: Tag
    @State private var updatedName: String
    @State private var selectedColor: Color.TagColor

    init(mainViewModel: MainViewModel, tag: Tag) {
        self.mainViewModel = mainViewModel
        _tag = State(initialValue: tag)
        _updatedName = State(initialValue: tag.name)
        _selectedColor = State(initialValue: Color.TagColor(rawValue: tag.color) ?? .color1)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tag Name")) {
                    TextField("Enter tag name", text: $updatedName)
                }

                Section(header: Text("Tag Color")) {
                    Picker("Select Color", selection: $selectedColor) {
                        ForEach(Color.TagColor.allCases, id: \.self) { color in
                            HStack {
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 20, height: 20)
                                Text(color.rawValue)
                            }
                            .tag(color)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            .navigationBarTitle("Update Tag", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    Task {
                        await mainViewModel.updateTag(tagId: tag.id, newName: updatedName, newColor: selectedColor.rawValue)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(updatedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            )
        }
    }
}

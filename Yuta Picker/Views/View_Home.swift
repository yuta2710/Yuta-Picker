//
//  View_Home.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI
import ModalView
import AlertToast

struct HomeView: View {
    @EnvironmentObject private var authenticationContextProvider: AuthenticationContextProvider
    @EnvironmentObject private var colourInfoContextProvider: ColourInfoContextProvider
    @Environment(\.presentationMode) var presentationMode
    
    
    @GestureState private var isLongPressColor: Bool = false
    
    @StateObject private var libraryVM: LibraryViewViewModel = LibraryViewViewModel()
    
    @State private var isOpen: Bool = false
    @State private var isOpenCreateNewWorkspaceDialog: Bool = false
    @State private var isOpenAddColorToLibraryModalForm: Bool = false
    @State private var currentHexColorLongGesture: String = ""
    @State private var selection: String?
    @State private var paletteLoadingState: LoadingState<String> = .none
    @State private var isOpenAlertToast: Bool = false
    @State private var isCompleteEvent: Bool = false
    @State private var alertToastConfiguration: AlertToastConfiguration?
    @State private var isOpenAlertDeleteConfirmation: Bool = false
    @State private var currentLibrarySelected: Library?
    
    var body: some View {
        NavigationView {
            ZStack {
                Text("")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text("YutaPicker")
                                    .font(.title.bold())
                                Button(action: {
                                    self.isOpenCreateNewWorkspaceDialog.toggle()
                                }, label: {
                                    Image(systemName: "plus")
                                        .bold()
                                        .foregroundColor(.black)
                                })
                            }
                        }
                    }
                //                Color("TertiaryBackground")
                //                    .edgesIgnoringSafeArea(.all)
                //                Circle()
                //                    .frame(width: 400, height: 400)
                //                    .offset(x: 150, y: -200)
                //                    .foregroundColor(Color.cyan.opacity(0.5))
                //                    .blur(radius: 25)
                //                Circle()
                //                    .frame(width: 300, height: 300)
                //                    .offset(x: -100, y: -125)
                //                    .foregroundColor(Color("PinkGradient2").opacity(0.5))
                //                    .blur(radius: 25)
                
                VStack {
                    Text("Palette")
                        .font(.title.bold())
                        .offset(y: 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0))
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 16.0) {
                            // Create new color button
                            Button(action: {
                                self.isOpen.toggle()
                            }) {
                                Image(systemName: "plus")
                                    .frame(width: 50, height: 50)
                                    .background(Color.black)
                                    .foregroundStyle(LinearGradient(colors: [Color("PinkGradient1"), Color("PinkGradient2")], startPoint: .top, endPoint: .bottom))
                                    .overlay(
                                        Circle()
                                            .stroke(LinearGradient(colors: [Color.red, Color.blue], startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 5.0))
                                    )
                                    .cornerRadius(25.0)
                            }
                            
                            //// Display list of current user colors
                            if let paletteIds = authenticationContextProvider.currentAccount?.paletteIds {
                                ForEach(paletteIds.sorted(by: { TimeInterval($0.value)! > TimeInterval($1.value)! }), id: \.key) { key, value in
                                    NavigationLink(destination: ColorAttributeDetailsView(hexCode: key.uppercased())) {
                                        let uiColor = Color(hex: "#\(key)")!
                                        Circle()
                                            .fill(uiColor)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(25.0)
                                            .shadow(color: uiColor, radius: 3, x: 0.0, y: 0.0)
                                    }
                                    .simultaneousGesture(
                                        LongPressGesture(minimumDuration: 0.5)
                                            .updating($isLongPressColor) { currentState, gestureState, transaction in
                                                gestureState = currentState
                                                DispatchQueue.main.async {
                                                    self.currentHexColorLongGesture = key
                                                }
                                            }
                                            .onEnded { _ in
                                                // Handle long press gesture
                                            }
                                    )
                                    .contextMenu {
                                        Button(action: {
                                            self.isOpenAddColorToLibraryModalForm.toggle()
                                        }) {
                                            Label("Add this color to workspace",
                                                  systemImage: "rectangle.stack.badge.plus"
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(24)
                    }
                    
                    //// Display all library of current account
                    ScrollView (.vertical) {
                        if let ownerId = authenticationContextProvider.currentAccount?.id {
                            ForEach(libraryVM.currentAccountLibraries.sorted {
                                $0.modifiedAt > $1.modifiedAt || $0.createdAt > $1.createdAt
                            }, id: \.id) { library in
                                CardLibrary(
                                    isOpenAlertDeleteConfirmation: $isOpenAlertDeleteConfirmation,
                                    currentLibrarySelected: $currentLibrarySelected,
                                    library: library)
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                }
            }
        }
        .onAppear() {
            Log.proposeLogWarning("User cannot be null")
            DispatchQueue.main.async {
                self.updateUIAfterCRUD {}
            }
        }
        
        .sheet(isPresented: $isOpen, content: {
            ColorPickerView(
                isOpen: $isOpen,
                alertToastConfiguration: $alertToastConfiguration,
                isOpenAlertToast: $isOpenAlertToast,
                isCompleteEvent: $isCompleteEvent)
            .environmentObject(authenticationContextProvider)
        })
        
        .sheet(isPresented: $isOpenAddColorToLibraryModalForm, content: {
            ModalPresenter {
                List(
                    libraryVM.currentAccountLibraries.sorted {$0.modifiedAt > $1.modifiedAt || $0.createdAt > $1.createdAt},
                    id: \.id,
                    selection: $selection) { library in
                        Button(action: {
                            libraryVM.addColorToCurrentLibrary(libraryId: library.id, hexData: currentHexColorLongGesture) {
                                DispatchQueue.main.async {
                                    self.isOpenAddColorToLibraryModalForm.toggle()
                                    
                                    self.setupToast(config: AlertToastConfiguration(
                                        displayMode: .hud,
                                        type: .complete(.green),
                                        title: "Success!",
                                        subtitle: "The new color has been added to this library successfully."))
                                    
                                    self.updateUIAfterCRUD {}
                                }
                            }
                        }, label: {
                            Text(library.name)
                                .font(.caption)
                                .foregroundColor(.black)
                        })
                    }
            }
            .alert(isPresented: $libraryVM.isDisplayAlert) {
                Alert(title: Text(libraryVM.alertTitle), message: Text(libraryVM.alertMessage), dismissButton: .cancel())
            }
        })
        .alert("Create new library", isPresented: $isOpenCreateNewWorkspaceDialog){
            TextField("Name of library", text: $libraryVM.name)
            SolidButton(
                title: "Add new library",
                hasIcon: false,
                iconFromAppleSystem: false,
                action: {
                    if let currentAccount = authenticationContextProvider.currentAccount {
                        // Create new library
                        libraryVM.createNewLibrary(
                            account: currentAccount,
                            data: Library(
                                id: UUID().uuidString,
                                name: libraryVM.name,
                                colors: [],
                                ownerId: currentAccount.id,
                                createdAt: Date().timeIntervalSince1970,
                                modifiedAt: Date().timeIntervalSince1970))
                        {
                            DispatchQueue.main.async {
                                self.setupToast(config: AlertToastConfiguration(
                                    displayMode: .hud,
                                    type: .complete(.green),
                                    title: "Success!",
                                    subtitle: "You have successfully created new library"))
                                self.updateUIAfterCRUD {}
//                                authenticationContextProvider.fetchCurrentAccount(){}
                                
                            }
                        }
                    }
                })
            Button("Cancel", role: .cancel){}
            
            
        } message: {
            Text("Please enter the name of library")
        }
        .alert(isPresented: $isOpenAlertDeleteConfirmation) {
            Alert(
                title: Text("Confirmation"),
                message: Text("Are you sure delete this library?"),
                primaryButton: .default(Text("OK")) {
                    // Dismiss the alert when OK button is tapped
                    if
                        let currentLibrarySelected = currentLibrarySelected {
                        libraryVM.deleteCurrentLibrary(libId: currentLibrarySelected.id) {
                            DispatchQueue.main.async {
                                self.setupToast(config: AlertToastConfiguration(
                                    displayMode: .hud,
                                    type: .complete(.green),
                                    title: "Success!",
                                    subtitle: "You have successfully remove this library"))
                                self.updateUIAfterCRUD {}
                            }
                        }
                    }
                },
                secondaryButton: .cancel(Text("Cancel")) {
                    // Dismiss the alert when Cancel button is tapped
                    isOpenAlertDeleteConfirmation = false
                }
            )
        }
        .toast(isPresenting: $isOpenAlertToast, alert: {
            if let alertToastConfiguration = alertToastConfiguration {
                AlertToast(
                    displayMode: alertToastConfiguration.displayMode,
                    type: alertToastConfiguration.type,
                    title: alertToastConfiguration.title,
                    subTitle: alertToastConfiguration.subtitle
                )
                
            }else {
                AlertToast(
                    displayMode: .alert,
                    type: .regular,
                    title: "N/A",
                    subTitle: "N/A"
                )
            }
        })
    }
    
    func updateUIAfterCRUD(completion: @escaping () -> Void) {
        authenticationContextProvider.fetchCurrentAccount {
            if let ownerId = authenticationContextProvider.currentAccount?.id {
                libraryVM.fetchAllLibrariesByAccountId(ownerId: ownerId) {
                    completion()
                }
            }
        }
    }

    func setupToast(config: AlertToastConfiguration){
        withAnimation(.easeInOut){
            self.isOpenAlertToast.toggle()
        }
        self.alertToastConfiguration = config
        self.isCompleteEvent = true
    }
}


#Preview {
    HomeView()
        .environmentObject(AuthenticationContextProvider())
        .environmentObject(ColourInfoContextProvider())
}




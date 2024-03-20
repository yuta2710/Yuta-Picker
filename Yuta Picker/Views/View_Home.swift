//
//  View_Home.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI
import ModalView
import AlertToast

struct ConfirmDialogWithTextField: View {
    @Binding var isShown: Bool
    @State private var textFieldText = ""
    
    var body: some View {
        VStack {
            Text("Enter Text")
            TextField("Type here", text: $textFieldText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("Cancel") {
                    self.isShown = false
                }
                .padding()
                
                Spacer()
                
                Button("Confirm") {
                    // Handle confirm action here, using textFieldText
                    self.isShown = false
                }
                .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct HomeView: View {
    @EnvironmentObject private var authenticationContextProvider: AuthenticationContextProvider
    @EnvironmentObject private var colourInfoContextProvider: ColourInfoContextProvider
    
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
    
    @GestureState private var isLongPressColor: Bool = false
    
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
//                                Spacer()
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
                    //                    GradientText(title: "Palette", colors: [Color.cyan, Color.orange])
                    //                        .font(.title.bold())
                    //                        .offset(y: 16)
                    //                        .frame(maxWidth: .infinity, alignment: .leading)
                    //                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0))
                    
                    Text("Palette")
                        .font(.title.bold())
                        .offset(y: 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0))
                    
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 16.0) {
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
                            
                            if let paletteIds = authenticationContextProvider.currentAccount?.paletteIds {
                                ForEach(paletteIds.sorted(by: { TimeInterval($0.value)! > TimeInterval($1.value)! }), id: \.key) { key, value in
                                    NavigationLink(destination: ColorAttributeDetailsView(hexCode: key.uppercased())) {
                                        let uiColor = Color(hex: "#\(key)")!
                                        Circle()
                                            .fill(uiColor)
                                            .frame(width: 50, height: 50) // Adjust the size as needed
                                            .cornerRadius(25.0) // Adjust the corner radius as needed
                                            .shadow(color: uiColor, radius: 8, x: 0.0, y: 0.0)
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
                                            Label("Add this color to workspace", systemImage: "rectangle.stack.badge.plus")
                                        }
                                    }
                                }
                            }
                        }
                        .padding(24)
                    }
                    
                

                    
                    ScrollView (.vertical) {
                        if let ownerId = authenticationContextProvider.currentAccount?.id {
                            ForEach(libraryVM.currentAccountLibraries.sorted {
                                $0.modifiedAt > $1.modifiedAt || $0.createdAt > $1.createdAt 
                            }, id: \.id) { library in
                                CardLibrary(library: library)
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
                //                if self.isCompleteEvent {
                //                    self.alertToastConfiguration = nil
                //                    withAnimation(.easeInOut){
                //                        self.isCompleteEvent = false
                //                    }
                //                }
                authenticationContextProvider.fetchCurrentAccount {
                    Log.proposeLogInfo("Dit con me no \(authenticationContextProvider.currentAccount?.id)")
                    
                    if let ownerId = authenticationContextProvider.currentAccount?.id {
                        Log.proposeLogInfo("Account ID: \(ownerId)")
                        libraryVM.fetchAllLibrariesByAccountId(ownerId: ownerId){
                            
                        }
                    }
                }
                
            }
            
            
        }
        
        .sheet(isPresented: $isOpen, content: {
            ColorPickerView(
                isOpen: $isOpen,
                alertToastConfiguration: $alertToastConfiguration,
                isOpenAlertToast: $isOpenAlertToast,
                isCompleteEvent: $isCompleteEvent) // Added binding alert toast to this view
            .environmentObject(authenticationContextProvider)
        })
        
        .sheet(isPresented: $isOpenAddColorToLibraryModalForm, content: {
            ModalPresenter {
                List(libraryVM.currentAccountLibraries.sorted {$0.modifiedAt > $1.modifiedAt || $0.createdAt > $1.createdAt}, id: \.id, selection: $selection) { library in
                    Button(action: {
                        libraryVM.addColorToCurrentLibrary(libraryId: library.id, hexData: currentHexColorLongGesture) {
                            DispatchQueue.main.async {
                                self.isOpenAddColorToLibraryModalForm.toggle()
                                
                                withAnimation(.easeInOut){
                                    self.isOpenAlertToast.toggle()
                                }
                                
                                self.alertToastConfiguration = AlertToastConfiguration(
                                    displayMode: .banner(.pop),
                                    type: .complete(.green),
                                    title: "Successfully",
                                    subtitle: "Added to current library successfully")
                                self.isCompleteEvent = true
                                
                                authenticationContextProvider.fetchCurrentAccount {
                                    if let ownerId = authenticationContextProvider.currentAccount?.id {
                                        libraryVM.fetchAllLibrariesByAccountId(ownerId: ownerId){
                                            
                                        }
                                    }
                                }
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
            SolidButton(title: "Add new library", hasIcon: false, iconFromAppleSystem: false, action: {
                if let currentAccount = authenticationContextProvider.currentAccount {
                    // Create new library
                    libraryVM.createNewLibrary(
                        account: currentAccount,
                        data: Library(id: UUID().uuidString, 
                                      name: libraryVM.name,
                                      colors: [],
                                      ownerId: currentAccount.id,
                                      createdAt: Date().timeIntervalSince1970,
                                      modifiedAt: Date().timeIntervalSince1970)) {
                        
                                          Log.proposeLogInfo("Dit me \(currentAccount.name)")
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut){
                                self.isOpenAlertToast.toggle()
                            }
                            
                            self.alertToastConfiguration = AlertToastConfiguration(
                                displayMode: .hud,
                                type: .complete(.green),
                                title: "Created library successfully",
                                subtitle: "You can add new color to this library")
                            self.isCompleteEvent = true
                            authenticationContextProvider.fetchCurrentAccount(){
                                
                            }
                        }
                    }
                }
            })
            Button("Cancel", role: .cancel){}
            
            
        } message: {
            Text("Please enter the name of library")
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
    
}


#Preview {
    HomeView()
        .environmentObject(AuthenticationContextProvider())
        .environmentObject(ColourInfoContextProvider())
    //    ContentView()
    
}

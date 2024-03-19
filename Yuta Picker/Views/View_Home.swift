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
    
    @GestureState private var isLongPressColor: Bool = false
    
    @State private var alertToastConfiguration: AlertToastConfiguration?
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Text("")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            ZStack {
                                HStack {
                                    Text("YutaPicker")
                                        .font(.title.bold())
                                    //                                        .gradientTextColor(
                                    //                                            colors: [
                                    //                                                Color("PinkGradient1"),
                                    //                                                Color("PinkGradient2")
                                    //                                            ]
                                    //                                        )
                                    Spacer()
                                    Button(action: {
                                        self.isOpenCreateNewWorkspaceDialog.toggle()
                                    }, label: {
                                        Image(systemName: "plus")
                                            .bold()
                                        //                                            .foregroundColor(.white)
                                            .foregroundColor(.black)
                                    })
                                }
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
                    //                        .foregroundColor(Color("PrimaryBackground"))
                        .font(.title.bold())
                        .offset(y: 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0))
                    
                    
                    ScrollView (.horizontal) {
                        HStack (spacing: 16.0) {
                            Button(
                                action: {
                                    self.isOpen.toggle()
                                },
                                label: {
                                    Image(systemName: "plus")
                                        .frame(width: 50, height: 50)
                                        .background(.black)
                                    
                                        .foregroundStyle(.linearGradient(colors: [Color("PinkGradient1"), Color("PinkGradient2")], startPoint: .top, endPoint: .bottom))
                                        .overlay (
                                            Circle()
                                                .stroke(LinearGradient(
                                                    colors: [Color.red, Color.blue],
                                                    startPoint: .top,
                                                    endPoint: .bottom), style: StrokeStyle(lineWidth: 5.0))
                                        )
                                        .cornerRadius(25.0)
                                    
                                })
                            
                            if let palleteIds = authenticationContextProvider.currentAccount?.paletteIds {
                                ForEach(palleteIds, id: \.self) { palleteHex in
                                    
                                    NavigationLink{
                                        ColorAttributeDetailsView(hexCode: palleteHex.uppercased())
                                        
                                    }label: {
                                        let uiColor = Color.init(hex: "#\(palleteHex)")!
                                        Color(uiColor)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8.0)
                                            .shadow(color: uiColor, radius: 8, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 0.0)
                                            .gesture (
                                                LongPressGesture(minimumDuration: 0.5)
                                                    .updating($isLongPressColor){ currentState, gestureState, transaction in
                                                        gestureState = currentState
                                                        DispatchQueue.main.async {
                                                            self.currentHexColorLongGesture = palleteHex
                                                        }
                                                    }
                                                    .onEnded { value in
                                                        //
                                                    }
                                                
                                            )
                                            .contextMenu(ContextMenu(menuItems: {
                                                Button(action: {
                                                    // Handle action for "New Album" here
                                                    self.isOpenAddColorToLibraryModalForm.toggle()
                                                }) {
                                                    Label("Add this color to workspace", systemImage: "rectangle.stack.badge.plus")
                                                }
                                                
                                            }))
                                    }
//                                    LoadingWrapperView(loadingState: paletteLoadingState) {
//                                        Button("Perform Loading Operation") {
//                                            paletteLoadingState = .loading
//                                        }.buttonStyle(.borderedProminent)
//                                    } loadingContent: {
//                                        ProgressView("Loading...")
//                                    } successContent: { hex in
//                                        Text()
//                                    } failureContent: { error in
//                                        Text(error.localizedDescription)
//                                            .foregroundStyle(.red)
//                                    }
                                    
                                    
                                }
                            }
                        }
                        .padding()
                        
                    }
                    
                    ScrollView (.vertical) {
                        if let ownerId = authenticationContextProvider.currentAccount?.id {
                            
                            ForEach(libraryVM.currentAccountLibraries.sorted{$0.createdAt > $1.createdAt}, id: \.id) { library in
                                CardLibrary(library: library)
                            }
                            
                        }
                        
                        
                    }
//                    .onAppear() {
//                        if let ownerId = authenticationContextProvider.currentAccount?.id {
//                            libraryVM.fetchAllLibrariesByAccountId(ownerId: ownerId){
//                                
//                            }
//                        }
//                        
//                    }
                    
                    Button(action: {
                        isOpenAlertToast.toggle()
                    }, label: {
                        /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                    })
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
                    if let ownerId = authenticationContextProvider.currentAccount?.id {
                        Log.proposeLogInfo("Account ID: \(ownerId)")
                        libraryVM.fetchAllLibrariesByAccountId(ownerId: ownerId){
                            
                        }
                    }
                }
            }
        }
        
        .sheet(isPresented: $isOpen, content: {
            ColorPickerView(isOpen: $isOpen) // Added binding alert toast to this view 
                .environmentObject(authenticationContextProvider)
        })
        
        .sheet(isPresented: $isOpenAddColorToLibraryModalForm, content: {
            ModalPresenter {
                List(libraryVM.currentAccountLibraries, id: \.id, selection: $selection) { library in
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
                                    title: "Added to current library successfully",
                                    subtitle: nil)
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
                    })
                }
            }
        })
        .alert("Create new library", isPresented: $isOpenCreateNewWorkspaceDialog){
            TextField("Name of library", text: $libraryVM.name)
            SolidButton(title: "Add new library", hasIcon: false, iconFromAppleSystem: false, action: {
                if let currentAccount = authenticationContextProvider.currentAccount {
                    // Create new library
                    libraryVM.createNewLibrary(account: currentAccount, data: Library(id: UUID().uuidString, name: libraryVM.name, colors: [], ownerId: currentAccount.id, createdAt: Date().timeIntervalSince1970, modifiedAt: Date().timeIntervalSince1970)) {
                       
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut){
                                self.isOpenAlertToast.toggle()
                            }
                            
                            self.alertToastConfiguration = AlertToastConfiguration(
                                displayMode: .banner(.slide),
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

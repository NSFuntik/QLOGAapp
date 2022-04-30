//
//  ProviderSearchView.swift
//  QLOGA
//
//  Created by Dmitry Mikhailov on 3/4/22.
//

import SwiftUI

struct ProviderSearchView: View {

    init() {
        UITableView.appearance().backgroundColor = UIColor.white
        UITableView.appearance().separatorColor = UIColor(named: "AccentColor")?.withAlphaComponent(0.6)
        UITableView.appearance().sectionIndexColor = UIColor(named: "AccentColor")?.withAlphaComponent(0.6)
//        self._selectedButton = selectedButton
        selectedButton = SelectionViewModel.shared.selection ?? 0
    }
    @State var selectStore = SelectionViewModel.shared
    @State var selectedButton: Int
    @State var isLimited = true

    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollViewReader { proxy in

                        HStack {
                            ForEach(Services) { service in
                                Button {
                                    selectedButton = service.id
                                    selectStore.currentRow = selectedButton
                                    withAnimation {
                                        proxy.scrollTo(service.id, anchor: .center)
                                    }
                                } label: {
                                    VStack {
                                        Image(service.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(10)
                                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(selectedButton == service.id ? Color.accentColor : Color.lightGray.opacity(0.6),
                                                            lineWidth: selectedButton == service.id ? 2.0 : 1.5)
                                            ).padding(.bottom, -3).padding(.top, 1)
                                        Text(service.name)
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 15.0, weight: .light, design: .rounded))
                                            .padding(.bottom, 5)
                                    }
                                    .frame(maxHeight: 90)
                                    .padding(.horizontal, 10)
                                    .tag(service.id)
                                }
                            }
                        }.padding(.leading, 20)

                        //                    .onChange(of: selectedButton)  { _ in
                        ////
                        //                    }

                    }.padding(.top, 10).padding(.horizontal, -30)
//                        .task({
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                withAnimation {
//                                    proxy.scrollTo(selectedButton, anchor: .center)
//                                }
//                            }
//                        })
                }
                VStack {
                    HStack {
                        Text("Description")
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.leading)
                            .font(Font.system(size: 20, weight: .medium, design: .rounded))
                        Spacer()
                    }.padding(.vertical, 5)
                    Text(Services[$selectStore.selection.wrappedValue ?? selectedButton].description ?? descr)
                        .foregroundColor(Color.black.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 14, weight: .light, design: .rounded))
                        .lineLimit(isLimited ? 4 : 10)
                    HStack {
                        Text(isLimited ? "Show more" : "Show less")
                            .foregroundColor(Color.accentColor)
                            .multilineTextAlignment(.leading)
                            .font(Font.system(size: 13, weight: .light, design: .rounded))
                            .padding(.top, -5)
                            .onTapGesture {
                                isLimited.toggle()
                            }
                        Spacer()
                    }
                }.padding(.bottom, 20)
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(Array(Services[$selectStore.selection.wrappedValue ?? selectedButton].services), id: \.self) { type in
                            Section {
                                DisclosureGroup {
                                    VStack(spacing: 10) {
                                        Text("Internal and external drain and sewer repair, including unblocking and cleaning and replacing drains, sewers and pipes.Internal and external drain and sewer repair, including unblocking and cleaning and replacing drains, sewers and pipes.")
                                            .foregroundColor(Color.secondary.opacity(0.7))
                                            .multilineTextAlignment(.leading)
                                            .font(Font.system(size: 15, weight: .regular, design: .rounded))
                                            .lineLimit(5)
                                            .padding(10)
                                        HStack(alignment: .center) {
                                            Spacer()
                                            NavigationLink(destination: SelectedServiceDetailView(serviceType: .Kitchen)) {
                                                HStack {
                                                    Text("Details")
                                                        .lineLimit(1)
                                                        .font(.system(size: 20, weight: .regular, design: .default))
                                                        .foregroundColor(.infoBlue)
                                                        .frame(width: 100, height: 40)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 25)
                                                                .stroke(Color.infoBlue, lineWidth: 4)
                                                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                                                .background(RoundedRectangle(cornerRadius: 25).fill(Color.white)))
                                                        .padding(1)
                                                        .frame(width: 100, height: 40)
                                                }
                                            }
                                            Spacer()
                                            NavigationLink(destination: ProvidersView(service: Services[$selectStore.selection.wrappedValue ?? selectedButton])) {
                                                HStack {
                                                    Text("Show providers")
                                                        .withDoneButtonStyles(backColor: .Green, accentColor: .white, isWide: false, width: 200, height: 40, isShadowOn: false).padding(1)

                                                }.frame(width: 200, height: 45)
                                            }
                                            Spacer()
                                        }
                                    }.frame(width: UIScreen.main.bounds.width - 40, alignment: .center)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text(type.title)
                                                    .foregroundColor(Color.black.opacity(0.9))
                                                    .multilineTextAlignment(.leading)
                                                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                                                    .lineLimit(1)
                                                    .padding(.leading, 10)
                                                Spacer()
                                            }
                                            Spacer()
                                            HStack {
                                                Text("Time norm: " + type.timeNorm.description + " min/room")
                                                    .foregroundColor(Color.secondary.opacity(0.7))
                                                    .multilineTextAlignment(.leading)
                                                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                                                    .lineLimit(1)
                                                    .padding(.leading, 10)
                                                Spacer()
                                            }
                                        }
                                    }.padding(5).frame(height: 40)
                                }
                                Divider().padding(.horizontal, -10).padding(.leading, 25)
                            }
                        }
                    }
                    .padding(10).padding(.bottom, -10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary
                            .opacity(0.7), lineWidth: 1).padding(1))
                    Spacer(minLength: 50)
                }
            }.padding(.horizontal, 20)
        }//.animation(.easeInOut(duration: 0.5), value: selectedButton).transition(.slide).animation(.easeInOut(duration: 0.5), value: selectStore.selection)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Provider Search")
    }
}

//extension ProviderSearchView {
//    private var ServicesScrollView: some View {
//
//
//    }
//}

struct ProviderSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProviderSearchView().previewDevice("iPhone 6s").navigationTitle("Provider Search")
        }
    }
}

let descr = "Residential cleaning services for all parts of your home. With tasks covering dishwashing, cleaning bathrooms, waste removal, furniture cleaning, window cleaning...Residential cleaning services for all parts of your home. With tasks covering dishwashing, cleaning bathrooms, waste removal, furniture cleaning, window cleaning, deep cleans, disinfecting, laundry and ironing, and other general cleaning tasks in the home.\nResidential cleaning services for all parts of your home. With tasks covering dishwashing, cleaning bathrooms, waste removal, furniture cleaning, window cleaning, deep cleans, disinfecting, laundry and ironing, and other general cleaning tasks in the home"

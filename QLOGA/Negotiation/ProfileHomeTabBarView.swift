//
//  EntryProfileView.swift
//  QLOGA
//
//  Created by Dmitry Mikhailov on 4/6/22.
//

import SwiftUI
import Combine


enum HomeTab: Int {
    case orders, requests, search, favourites
    var title: String {
        switch self {
            case .orders:
                return "Orders"
            case .requests:
                return  "Open Requests"
            case .search:
                return "Provider Search"
            case .favourites:
                return "Favourite providers"
        }
    }
}
class TabController: ObservableObject {
    public var objectWillChange = PassthroughSubject<Void, Never>()
    @Published var activeTab: HomeTab = .orders {
        willSet {
            objectWillChange.send()
        }
    }
    static let shared = TabController()
    func open(_ tab: HomeTab) {
        activeTab = tab
    }
}
struct ProfileHomeTabBarView: View {
    @State var provider: Provider = testProvider
    @Binding var actorType: ActorsEnum
    @State var customer: Customer = testCustomer
    @StateObject var tabController: TabController
    @State var isFiltersPresented = false
    @State var tab: HomeTab = .orders
    @ObservedObject var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    switch tabController.activeTab {
                        case .orders:
                            EnrolledProfileView(actorType: $actorType)
                                .navigationTitle("\(tabController.activeTab.title)").navigationBarTitleDisplayMode(.inline)
                        case .requests:
                            CstRequestsTabView(provider: $provider, customer: $customer)
                                .navigationTitle("Open Requests").navigationBarTitleDisplayMode(.inline)
                        case .search:
                            if actorType == .CUSTOMER {
                                ProviderSearchView()
                                    .navigationTitle("Provider Search").navigationBarTitleDisplayMode(.inline)
                            } else {
                                CustomerSearchView()
                                    .navigationTitle("Provider Search").navigationBarTitleDisplayMode(.inline)
                            }
                        case .favourites:
                            FavoritesTabView(actorType: $actorType)
                                .navigationTitle("Favorite \(actorType == .CUSTOMER ? "Providers" : "Customers")")
                                .navigationBarTitleDisplayMode(.inline)
                    }
                    Spacer()
                    ZStack {
                        HStack {
                            if actorType == .CUSTOMER {
                                TabBarIcon(tabController: tabController, assignedPage: .orders, width: geometry.size.width/4, height: geometry.size.height/28, systemIconName: "OrdersTabIcon", tabName: "Today")
                                TabBarIcon(tabController: tabController, assignedPage: .requests, width: geometry.size.width/4, height: geometry.size.height/28, systemIconName: "RequestsTabIcon", tabName: "Requests")
                                TabBarIcon(tabController: tabController, assignedPage: .search, width: geometry.size.width/4, height: geometry.size.height/28, systemIconName: "SearchTabIcon", tabName: "Search")
                                TabBarIcon(tabController: tabController, assignedPage: .favourites, width: geometry.size.width/4, height: geometry.size.height/28, systemIconName: "FavouritesTabIcon", tabName: "Favourites")
                            } else if actorType == .PROVIDER {
                                TabBarIcon(tabController: tabController, assignedPage: .orders, width: geometry.size.width/3, height: geometry.size.height/27, systemIconName: "OrdersTabIcon", tabName: "Today")
                                TabBarIcon(tabController: tabController, assignedPage: .search, width: geometry.size.width/3, height: geometry.size.height/27, systemIconName: "SearchTabIcon", tabName: "Search")
                                TabBarIcon(tabController: tabController, assignedPage: .favourites, width: geometry.size.width/3, height: geometry.size.height/28, systemIconName: "FavouritesTabIcon", tabName: "Favourites")
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height/8.5)
                        .background(.white.opacity(0.8))
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if actorType == .PROVIDER {
                        NavigationLink(destination: GoogleMapView(providers: .constant(
                            Customers.map({$0.address})),
                                                                  pickedAddress: .constant(Address(postcode: "", town: "", street: "",
                                                                                                   locationManager.latitude, locationManager.longitude)))) {
                            Image("MapIcon")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.accentColor)
                                .frame(width: 30, height: 30, alignment: .trailing)
                                .padding(5)
                        }
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack(alignment: .center) {
                        Button {
                            isFiltersPresented = true
                        } label: {
                            Image("FilterIcon")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.accentColor)
                                .frame(width: 30, height: 30, alignment: .trailing)
                                .padding(5)
                        }
                        NavigationLink(destination: ProfileSetupView(actorType: $actorType, customer: $customer, provider: $provider).environmentObject(tabController)) {
                            Image(actorType != .CUSTOMER ? "ProviderProfileIcon" : "CustomerProfileIcon")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(actorType == .CUSTOMER ? .accentColor : .infoBlue)
                                .frame(width: 30, height: 30, alignment: .trailing)
                                .padding(5)
                        }
                    }
                }
            }
        }
        .environmentObject(tabController)
        .sheet(isPresented: $isFiltersPresented) { ProvidersFilterView().cornerRadius(35) }
        .navigationViewStyle(.stack)
    }
}


struct EntryProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHomeTabBarView(actorType: .constant( .CUSTOMER), tabController: .init())
            .previewDevice("iPhone 6s")
    }
}

struct TabBarIcon: View {
    @StateObject var tabController: TabController
    let assignedPage: HomeTab
    let width, height: CGFloat
    let systemIconName, tabName: String
    var body: some View {
        VStack {
            Image(systemIconName)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text(tabName)
                .font(.footnote)
            Spacer()
        }
        .padding(.horizontal, -4)
        .onTapGesture {
            tabController.activeTab = assignedPage
        }
        .foregroundColor(tabController.activeTab == assignedPage ? .accentColor : .gray)
    }
}

//
//  TodayTabView.swift
//  QLOGA
//
//  Created by Dmitry Mikhailov on 4/18/22.
//

import SwiftUI
import Combine

var PrvQuotes: [OrderContent] = []
var CstInquires: [OrderContent] = []

struct TodayListTabView: View {
    @Binding var provider: Provider
    @Binding var customer: Customer
    @Binding var actorType: ActorsEnum
    @EnvironmentObject var tabController: TabController
    @ObservedObject var ordersController: OrdersViewModel
    @State var orders = Orders
    var body: some View {
        ScrollView {
            VStack(spacing: -22) {

//                ForEach((actorType != .CUSTOMER ? Orders + PrvInquires : Orders + CstQuotes).indices, id: \.self) { orderId in
//                    VStack {
                        //.padding(.leading, 20)
                if actorType == .CUSTOMER {
                    if  !CstInquires.isEmpty {
                        InquiryListTabView(provider: $provider, customer: $customer, actorType: $actorType, ordersController: ordersController)
                    }
                    QuotesListTabView(provider: $provider, customer: $customer, actorType: $actorType, ordersController: ordersController)
                }
                if  actorType == .PROVIDER {
                    if  !PrvQuotes.isEmpty {
                        QuotesListTabView(provider: $provider, customer: $customer, actorType: $actorType, ordersController: ordersController)
                    }
                    InquiryListTabView(provider: $provider, customer: $customer, actorType: $actorType, ordersController: ordersController)
                }
                PrvOrdersListTabView(provider: $provider, customer: $customer, ordersController: ordersController, actorType: $actorType)

//                        TodayListCell(order: (actorType != .CUSTOMER ? Orders + PrvInquires + PrvQuotes: Orders + CstQuotes + CstInquires)[orderId], customer: $customer, actorType: $actorType).padding(.horizontal, 10)

//                    }
//                }
                Spacer()
            }.padding(.top, 15).listStyle(.grouped)
        }.background(Color.white.opacity(0.7))
//        .onAppear {
//            orders = actorType != .CUSTOMER ? Orders + Inquires : Orders + Quotes
//        }
    }
}

struct TodayListTabViewListTabView_Previews: PreviewProvider {
    static var previews: some View {
        TodayListTabView(provider: .constant(testProvider), customer: .constant(testCustomer), actorType:  .constant(.PROVIDER), ordersController: OrdersViewModel.shared)
    }
}


struct TodayListCell: View {
    typealias Int = CategoryType.ID
    @State var catID: CategoryType.ID = 0
    @State var order: OrderContent
//    var statusColors: [Color]
//    "#FEE4E1","Visit Callout Charge requested"
//    "c2": "#FFB3AB"
    @Binding var customer: Customer
    @State var tags: Set<String> = []
    @Binding var actorType: ActorsEnum

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            NavigationLink(destination: OrderDetailView(actorType: $actorType, orderType: .Order, order: $order)) {
                VStack(alignment: .leading, spacing: 10) {
                    VStack {

                        HStack {
                            Text(order.statusRecord.status.display)
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .foregroundColor(.black).padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 10))
                            Spacer()

                        }
                        Divider().background(Color.lightGray)//.padding(.top, -5)

                    }
                    .background(LinearGradient(gradient: Gradient(colors: [Color(hex: order.statusRecord.status.colors[0])!, Color(hex: order.statusRecord.status.colors[1])!]), startPoint: .leading, endPoint: .trailing))
                        .padding([.top, .horizontal], -15)
                        HStack {
                            if order.dayPlans.count > 0 {
                                Text("\(order.dayPlans.count + 1) Visits")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    .foregroundColor(.secondary)
                            } else {
                                Text("\(getString(from: order.serviceDate, "MM-DD-YYYY HH:mm"))")
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            Text(poundsFormatter.string(from: order.amount as NSNumber)!)//order.services.map({$0.qty * $0.cost}).reduce(0, +) as NSNumber)!)
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                        }
                    if order.dayPlans.count > 0 {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(alignment: .center, spacing: 0) {
                                Text("First Visit: \(order.dayPlans.last!.day) \(order.dayPlans.first!.visit1.time!)")
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                    .foregroundColor(.black)

                                Spacer()
                            }
                            HStack(alignment: .center, spacing: 0) {
                                Text("Last Visit:  \(order.dayPlans.last!.day) \(order.dayPlans.last!.visit2.time!)")
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                    .foregroundColor(.black)
                                Spacer()

                            }
                        }
                    }
                }
            }.zIndex(0)
            if actorType == .PROVIDER {

                NavigationLink(destination: GoogleMapView(providers: .constant([]), pickedAddress: $order.addr.defaultAddress)) {

                    HStack(alignment: .top, spacing: 5) {
                        Image("MapSymbol")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit().aspectRatio(contentMode: .fit)
                            .foregroundColor(.accentColor)
                            .frame(width: 20, height: 20, alignment: .center)

                        Text(order.addr.total ?? "")
                            .lineLimit(3)
                            .foregroundColor(Color.secondary.opacity(0.8))
                            .font(Font.system(size: 15,
                                              weight: .regular,
                                              design: .rounded))
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        Spacer()

                    }.padding(.vertical, 10).frame(idealHeight: 30, maxHeight: 45)
                }
            } else {
                HStack(alignment: .top, spacing: 5) {
                    Text(order.addr.total ?? "")
                        .lineLimit(3)
                        .foregroundColor(Color.secondary.opacity(0.8))
                        .font(Font.system(size: 15,
                                          weight: .regular,
                                          design: .rounded))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    Spacer()

                }.padding(.vertical, 5).frame(idealHeight: 20, maxHeight: 40)
            }
            HStack {

                RemovableTagListView(selected: $catID, isRemovable: .constant(false),
                                     categoriesVM: CategoriesViewModel.shared,
                                     tags:
                                        Binding { Set(getCategoriesFor(order: order).frequency.map({ category, count in
                    return " \(category.title): \(count)"
                }))} set: { tags in
                    self.tags = tags
                }, fontSize: 21.5).padding(1)
            }
            .scaleEffect(0.78).offset(x: -40)

            .disabled(true)


        }.padding(15).background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 13))
            .overlay(RoundedRectangle(cornerRadius: 13).stroke(lineWidth: 1).fill(Color.lightGray))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

                    $order.wrappedValue = $order.wrappedValue
                }
            }
    }

    func getCategoriesFor(order: OrderContent) -> [CategoryType] {
        var categories: [CategoryType] = []
        let qServiceIDDict = qServiceID
        order.services.forEach { s in
            qServiceIDDict.keys.compactMap { qId in
                if qId == s.qserviceId {
                    categories.append(qServiceID[qId]!)
                }
            }
        }
        return categories
    }
}

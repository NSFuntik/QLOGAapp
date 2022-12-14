//
//  ContentView.swift
//  QLOGA
//
//  Created by Dmitry Mikhailov on 3/4/22.
//

import Combine
import SwiftUI

struct IntroView: View {
	@State var address: String = "Enter new address"
//	@State var address: String = "EH2 2ER Edinburgh Princes Street 09"
	@State var selectedButton: Int = CategoryType.Cleaning.id
	@State var isSearchEnabled = false
	@State var actorType: ActorsEnum = .CUSTOMER
	var body: some View {
		NavigationView {
			ZStack {

				VStack(alignment: .center, spacing: 5) {
					AddressSearchBarView
					HStack(alignment: .center, spacing: 0) {
						ServicesScrollView
							.padding([.top])
							.ignoresSafeArea(.all, edges: .bottom)
						//						.offset(x: 10)
						//						.background(
						//							RoundedRectangle(cornerRadius: 16, style: .circular)

						//								.padding([.horizontal, .bottom], -10)
						//								.padding(.trailing, -20)
						//								.padding(.top, 5)
						//								.ignoresSafeArea(.all, edges: .bottom)
						//								.foregroundColor(address != "Enter new address" ? Color.accentColor.opacity(0.2) : .white)).offset(x: 10).zIndex(1)

						Spacer(minLength: 50)
						ZStack {
							ProfileChooserView
								.frame(width: .infinity, alignment: .trailing)
								.padding(.bottom, 20)
							VStack {
								Spacer()
								NavigationLink(destination: ActorTypePickerView().navigationBarHidden(true)) {
									Label {
										Text("Skip to Execution")
											.foregroundColor(.accentColor.opacity(0.75))
											.font(.system(size: 15, weight: .light, design: .rounded))
											.lineLimit(1)

									} icon: {
										Image(systemName: "hare")
											.foregroundColor(.accentColor.opacity(0.75))
											.font(.system(size: 15, weight: .regular, design: .rounded))
									}
								}.background(Color.clear)
									.padding(.vertical, 2.5)
							}
						}
					}
				}.padding(.top, 10).padding(.horizontal, 20)

			}
				.navigationBarTitle("").navigationBarHidden(true)
		}.environment(\.colorScheme, .light)
	}

}

extension IntroView {
	private var AddressSearchBarView: some View {
		NavigationLink(destination: AddressSearchView(address: $address, actorType: .CUSTOMER)) {
			HStack(alignment: .center, spacing: 15, content: {
				Image("SearchIcon")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 24.0, height: 24.0, alignment: .center)
					.padding(.horizontal, 5)
				ZStack {
					Text(address == "" || address == "Enter new address" ? "Enter new address" : "")
						.foregroundColor(.lightGray.opacity(0.6))
						.font(.system(size: 16, weight: .regular, design: .rounded))
						.minimumScaleFactor(0.7).lineLimit(1)
					Text(address).lineLimit(1)
						.foregroundColor(address == "Enter new address" ? .lightGray.opacity(0.6) : Color("Orange").opacity(1))
						.font(.system(size: 16, weight: .regular, design: .rounded))
						.minimumScaleFactor(0.7)
				}
				Spacer()
			}).padding(10)
				.overlay(RoundedRectangle(cornerRadius: 10)
					.stroke(address == "Enter new address" || address == "" ? Color.lightGray.opacity(0.6) : Color("Orange")
						.opacity(0.8), lineWidth: 1))
		}
	}

	private var ServicesScrollView: some View {
		ScrollView(.vertical, showsIndicators: false) {
			ForEach(Services) { service in
				Button {
					selectedButton = service.id
				} label: {
					VStack {
						Image(service.image)
							.resizable()
							.renderingMode(.original)
							.aspectRatio(contentMode: .fit)
							.padding(10)
							.background(Color.white)
							.clipShape(RoundedRectangle(cornerRadius: 10))
							.overlay(
								RoundedRectangle(cornerRadius: 10)
									.stroke(selectedButton == service.id ? Color.accentColor : Color.lightGray.opacity(0.6),
											lineWidth: selectedButton == service.id ? 2.0 : 1.5)
							).padding(.bottom, -3).padding(.top, 2)
						Text(service.name)
							.foregroundColor(Color.black)
							.font(.system(size: 12.0, weight: .light, design: .rounded))
					}.padding([.bottom, .horizontal], 1)
						.frame(maxWidth: 70)
				}
			}
		}
	}

	private var ProfileChooserView: some View {
		GeometryReader { geometry in

			VStack(alignment: .trailing, spacing: 15) {
				
				NavigationLink(destination: EnrollmentInfoView(actorType: .CUSTOMER)) {
					VStack(alignment: .center, spacing: 10) {
						Image("CustomerIntro")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.padding([.horizontal, .top], 5)
						Text("Request")
							.foregroundColor(.black)
							.font(.system(size: 16, weight: .medium,
										  design: .rounded))
					}.padding(.bottom, 10).padding(.horizontal, 25)
						.overlay(
							RoundedRectangle(cornerRadius: 16)
								.stroke(Color.lightGray.opacity(0.5), lineWidth: 1))
				}
//				.background(ZStack {
//					RoundedRectangle(cornerRadius: 16, style: .continuous).padding(.leading,-24)
//
//						.padding(.bottom, -7.75)
//						.foregroundColor(address != "Enter new address" ? Color.accentColor.opacity(0.2) : .white)
//						.zIndex(1)
//						.clipShape(Rectangle().offset(x: -10, y: 20))
//					RoundedRectangle(cornerRadius: 16, style: .continuous).padding(.horizontal,-10)
//						.padding(.bottom, -7.5)
//						.foregroundColor(Color.white)
//						.zIndex(1)

//				})
				NavigationLink(destination: ProviderSearchView()) {
					VStack(alignment: .center, spacing: 10) {
						Image("ProviderSearchIntro")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.padding([.horizontal, .top], 5)

						Text("Provider search")
							.foregroundColor(.black)
							.font(.system(size: 16, weight: .medium, design: .rounded))
							.lineLimit(1)
							.padding(.horizontal, -20)
					}.padding(.bottom, 10).padding(.horizontal, 25)
						.background(RoundedRectangle(cornerRadius: 16, style: .circular).foregroundColor(
							Color.white))
						.overlay(RoundedRectangle(cornerRadius: 16)
							.stroke(address == "Enter new address" ? Color.lightGray.opacity(0.5) : Color.accentColor.opacity(0.6) ))
				}
//				.background(HStack {
//					RoundedRectangle(cornerRadius: 16, style: .circular)
//					.foregroundColor(address != "Enter new address" ? Color.accentColor.opacity(0.2) : .white)
//					.frame(width: UIScreen.main.bounds.width / 1.3, height: 210, alignment: .leading).padding(.trailing, 40)
//					Spacer()
//				})
				NavigationLink(destination: EnrollmentInfoView(actorType: .PROVIDER)) {
					VStack(alignment: .center, spacing: 10) {
						Image("BecomeProviderIntro")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.padding([.horizontal, .top], 5)

						Text("Become a provider")
							.foregroundColor(.black)
							.font(.system(size: 16, weight: .medium, design: .rounded))
							.lineLimit(1)
							.padding(.horizontal, -20)
					}.padding(.bottom, 10).padding(.horizontal, 25)
						.overlay(
							RoundedRectangle(cornerRadius: 16)
								.stroke(Color.lightGray.opacity(0.5), lineWidth: 1)

						)
				}
//				.background(ZStack {
//					RoundedRectangle(cornerRadius: 16, style: .continuous).padding(.leading,-24)
//
//						.padding(.top, -7.75)
//						.foregroundColor(address != "Enter new address" ? Color.accentColor.opacity(0.2) : .white)
//						.zIndex(1)
//						.clipShape(Rectangle().offset(x: -10, y: -20))
//					RoundedRectangle(cornerRadius: 16, style: .continuous).padding(.horizontal,-10)
//						.padding(.top, -7.5)
//						.foregroundColor(Color.white)
//						.zIndex(1)
//
//				})

			}.frame(maxWidth: geometry.size.width).padding([.top], 20)

		}.frame(maxWidth: .infinity)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		IntroView()
			.previewLayout(.device)


	}
}

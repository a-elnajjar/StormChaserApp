//
//  PostView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-05-05.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
	
	
	private func loadCurrentLocation() async {
		let lat = latitude
		let lon = longitude
		let resolved = await resolveLocation(latitude: lat, longitude: lon)
		locationTitle = resolved.title
		await weatherVM?.fetchWeather(country: resolved.countryCode, latitude: lat, longitude: lon)
	}
}

#Preview {
    PostView()
}

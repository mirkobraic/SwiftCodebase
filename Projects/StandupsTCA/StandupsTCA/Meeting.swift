//
//  Meeting.swift
//  StandupsTCA
//
//  Created by Mirko Braić on 07.03.2024..
//

import SwiftUI

struct MeetingView: View {
  let meeting: Meeting
  let standup: Standup

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Divider()
          .padding(.bottom)
        Text("Attendees")
          .font(.headline)
        ForEach(self.standup.attendees) { attendee in
          Text(attendee.name)
        }
        Text("Transcript")
          .font(.headline)
          .padding(.top)
        Text(self.meeting.transcript)
      }
    }
    .navigationTitle(Text(self.meeting.date, style: .date))
    .padding()
  }
}

#Preview {
    MeetingView(meeting: Meeting(id: UUID(), date: Date(), transcript: "Lorem ipsum psusum"), standup: .mock)
}

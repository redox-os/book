# Chat

The best way to communicate with the Redox team is on Matrix Chat, to join our chat, you must request an invitation in the [Join Requests room](https://matrix.to/#/#redox-join:matrix.org) (this room acts as a guard against spam and bots)

When your invitation is sent, you will receive a notification on Matrix.

After you accept the invitation, you can open the [Redox Matrix space](https://matrix.to/#/#redox:matrix.org) and see the rooms that are available.

These rooms are English-only, we cannot offer support in other languages because the maintainers will not be able to verify the correctness of your responses. But if you post translator-generated messages, we will do our best to understand them.

## About Matrix

[Matrix](https://en.wikipedia.org/wiki/Matrix_(protocol)) is an open chat protocol and has several different [clients](https://matrix.org/ecosystem/clients/). [Element](https://element.io/) is a commonly used choice, it works on web browsers, Linux, MacOSX, Windows, Android and iOS.

If you have problems with Element, read the [Troubleshooting Element](#troubleshooting-element) section or try [Fractal](https://gitlab.gnome.org/World/fractal).

## Redox Use of Matrix

We follow the [Rust Code Of Conduct](https://www.rust-lang.org/policies/code-of-conduct) as rules of the chat rooms.

### Threads

- If you want to have a big discussion in our Matrix space you should use a thread.
- A thread is a list of messages, like a forum topic.
- A thread is linked to the original message, but displayed to the side to help improve the visibility of new questions in the main message area.

Not all Matrix clients support threads, so if you are not able to see threads in your client, try a different client.

If you are unable to use a client that supports threads, let us know when you ask a question, and we will try to accommodate you as best we can.

- To start a thread on Element, hover your mouse cursor over the desired message and click on the button with the message icon (a rectangular speech bubble).
- To see all threads in a room click on the top-right button with a message icon.

We mostly use Element threads but there are other Matrix clients with threads support, like nheko.

## The Redox Space

All rooms available on the Redox space:

- [#redox-join:matrix.org](https://matrix.to/#/#redox-join:matrix.org) - A room to be invited to Redox space.
- [#redox-announcements:matrix.org](https://matrix.to/#/#redox-announcements:matrix.org) - A room for important announcements.
- [#redox-general:matrix.org](https://matrix.to/#/#redox-general:matrix.org) - A room for Redox-related discussions (questions, suggestions, porting, etc).
- [#redox-dev:matrix.org](https://matrix.to/#/#redox-dev:matrix.org) - A room for the development, here you can talk about anything development-related (code, proposals, achievements, styling, bugs, etc).
- [#redox-rfcs:matrix.org](https://matrix.to/#/#redox-rfcs:matrix.org) - A room for system architecture design discussions and brainstorming for RFCs.
- [#redox-support:matrix.org](https://matrix.to/#/#redox-support:matrix.org) - A room for testing and building support (problems, errors, questions).
- [#redox-mrs:matrix.org](https://matrix.to/#/#redox-mrs:matrix.org) - A room to send all ready merge requests without conflicts  (if you have a ready MR to merge, send there).
- [#redox-gitlab:matrix.org](https://matrix.to/#/#redox-gitlab:matrix.org) - A room to send new GitLab accounts for approval.
- [#redox-soc:matrix.org](https://matrix.to/#/#redox-soc:matrix.org) - A room for the Redox Summer Of Code program.
- [#redox-board:matrix.org](https://matrix.to/#/#redox-board:matrix.org) - A room for meetings of the Board of Directors.
- [#redox-voip:matrix.org](https://matrix.to/#/#redox-voip:matrix.org) - A room for voice chat discussions.
- [#redox-random:matrix.org](https://matrix.to/#/#redox-random:matrix.org) - A room for off-topic discussions.

### Troubleshooting Element

- Threads on Element have some bugs, typically marking messages as still unread, even after you have read them.

- Element in the web browser does not show new messages in a thread as part of its new message count. It only shows a green or red dot over the Threads icon on the lower left of the display. A red dot means that the message is a reply to you. Click the Threads icon to see which rooms have new thread messages.

- To display all threads in a room on Element in the web browser, click on the Threads icon on the top right of the display.

- If the Threads button on the top right has a dot, you may have unread messages on some thread, but this could be wrong.

- If a thread has a dot to the right, you have unread messages in that thread. Click on the thread to read it.

- When entering a room where you have previously received replies in a thread, you may hear a notification bell, even though there is no new message.

- Due to bugs, a thread you have previously read can show a dot and possibly count as unread messages. Click on the thread and make sure you have read it, and  to clear it. If it is still not cleared, click on the "Thread options" `...` button on the top right and select "Show in room". This will often clear it.

You can also mark an entire room as "Read" by mousing over the room name and selecting "Mark as read" from the "Room options" `...` button.

- After doing the steps above, if you still have problems, try reloading the page.

- Element uses a cache, but clearing the cache sometimes causes problems, if you have encrypted rooms, like DM rooms, save your encryption keys before clearing your cache or you may lose the room history.

Read the Element documentation to learn more about encryption keys.

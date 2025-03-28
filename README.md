# ServerAssistant
IOS app to help servers wait on tables
# Overview
ServerAssistant is an IOS app made to streamline the tedious side of serving in a restaurant by using voice transcription, AI order processing, and table management features. 
# Features
 - Voice Transcription: Utilizes Deepgram AI to accurately capture customer orders.
 - AI Order Processing: Formats orders into clean, shorthand format, commonly used on restaurant order tickets.
 - Order History Tracking: Maintains a record of orders for each table, allowning easy access and modification.
# Requirements
- macOS device
- [Xcode](https://developer.apple.com/xcode/) installed (latest version recommended)
- Internet connection (to use Deepgram and OpenAI APIs)
- An Apple Developer Account (free or paid)
# Setup 
1. Clone the repository:
~~~
git clone https://github.com/tristanClaye/ServerAssistant.git
~~~
3. Navigate to the IOS folder
~~~
cd ServerAssistant/IOS
~~~
4. Open with Xcode:
Double-click the ServerAssistant.xcodeproj file to launch in Xcode.
5. Click the **"Signing & Capabilities"** tab.
6. Under "Team", select your **Apple ID / Developer Team** from the dropdown.
    - If none appear, go to `Xcode > Settings > Accounts`, and sign in with your Apple ID first.
7. Ensure "Automatically manage signing" is checked.
8. In the top center of your screen, ensure iphone 16 simulator is selected.
9. Build and Run:
Select target device or simulator and press Cmd+R to build and run the application.
# Usage
1.	Launching the App:
Upon opening, the splash screen introduces the ServerAssistant.
	- When prompted to allow microphone access, press accept.
3.	Creating a New Table:
   	 - Tap on “+ New Table”.
	 - Enter the table number and number of guests and press the "+ Add Table" button.
	 - If the table number already exists, an error message will be displayed.
4.	Reopening an Existing Table:
	 - Select “Reopen Table” to view and manage active tables.
	 - Choose the desired table and press the "Open" button to access its dashboard.
5.	Recording Orders:
   	 - In the dashboard, use the “Start Recording” button to begin capturing orders via voice.
	 - Press “Stop Recording” to end and save the transcript.
6.	Viewing Order History:
The dashboard displays a transcript box containing the history of orders taken for the selected table.
# Note
ServerAssistant is an actively evolving project.
I plan to continue adding features and improvements, including:
 - Smart table timers and reminders (refills, check-ins, etc.)
 - Ability to edit recorded orders.
 - UI improvements.

If you have feedback, suggestions, or want to collaborate — feel free to reach out: trisclaye@gmail.com

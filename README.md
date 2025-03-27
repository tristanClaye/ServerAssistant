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
5. Build and Run:
Select target device or simulator and press Cmd+R to build and run the application.
#Usage
1.	Launching the App:
Upon opening, the splash screen introduces the ServerAssistant.
2.	Creating a New Table:
	•	Tap on “+ New Table”.
	•	Enter the table number and number of guests.
	•	If the table number already exists, an error message will be displayed.
3.	Reopening an Existing Table:
	•	Select “Reopen Table” to view and manage active tables.
	•	Choose the desired table to access its dashboard.
4.	Recording Orders:
	•	In the dashboard, use the “Start Recording” button to begin capturing orders via voice.
	•	Press “Stop Recording” to end and save the transcript.
	5.	Viewing Order History:
The dashboard displays a transcript box containing the history of orders taken for the selected table.


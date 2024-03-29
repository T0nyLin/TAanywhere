# Project's Title
**_TAanywhere_**

# Table of Contents
| Sections | Subsections |
| - | - |
| Project Descriptions | Our Motivation |
| | Our Aim |
| | Our Techstack |
| | |
| Software Development Process | Planning |
| | Designing |
| | Implementing |


# Project Descriptions
**Our Motivation:**  
When you’re stuck with a burning question in one of your modules, and you have spent tons of time on it, your current alternatives are friends, peers, seniors, teaching assistants and perhaps the professor teaching the module. 

Many may have reached the point where either these alternatives don’t know the answer, or it’s inconvenient to ask them, and the teaching assistants and professor are too busy to reply to your long-winded question. The question is also too module-specific for Google to help you out, or you need a more interactive dialogue to solve all the doubts you have been stacking up. Also, since you’re somewhere in the campus, you’re sure that someone around you has taken this module and may have all the answers that you needed, but you don’t know who they are. 

So what if you had a way to find someone around you who can help you out of the rabbit hole? 

**Our Aim:**  
We hope to design a mobile application called **_TAanywhere_** to address the issues mentioned in the previous point. **_TAanywhere_** is an innovative app that aims to provide students with access to affordable mentoring services. The app aims to connect students with experienced students who are willing to meet them at campus venues. We emphasize the importance of physical meetups because we believe that in-person teaching is best suited to our motivation, as mentors and mentees can focus on the discussion, free from external disruptions and network issues. To ensure the safety of both mentors and mentees, we plan to restrict the application to work only within the campus, similar to the **_NUSNextBus_** app. The app offers quick meet with instant alert features, similar to SCDF’s **_myResponder_** app, enabling students to find suitable mentors quickly and easily. Payment is made through the app.

**Our Techstack:** 
1. Flutter:
Flutter Is an open-source UI software development kit. It is a tool that allows engineers to create different applications using one programming language and one codebase. Flutter is a valuable modern tool used to create stunning cross-platform applications that render native code on each device and OS. Flutter is compatible with Android, iOS, Linux, macOs, Windows, etc.
\
\
In our case, we want to develop a mobile application that can be deployed on various platforms. For simplicity, we start off with Android, and ideally we will extend to other operating system soon. While choosing the technology used for development, we notice that Flutter is a popular choice among mobile application developers, and hence we choose to employ this SDK as one of our main development tools.
\
\
The first challenge faced by a beginner in Flutter will be the installment process to the local device. We have put a lot of effort to install Flutter in our local devices and completed various settings to ensure our Flutter works properly.
\
\
Another major challenge faced by people who are not familiar in Flutter is the lack of existing examples. As a relatively new toolkit, it is challenging to find online resources or discussions regarding its syntax, especially if the issue is uncommon and specific to certain project. Most of the time, the flutter's official documentation only provide simple and limited example, which is not helpful when dealing with complex usage.

2. Dart:
Dart is a client-optimized language for developing fast apps on any platform. Its goal is to offer the most productive programming language for multi-platform development, paired with a flexible execution runtime platform for app frameworks.
\
\
Dart also forms the foundation of Flutter. Dart provides the language and runtimes that power Flutter apps, but Dart also supports many core developer tasks like formatting, analyzing, and testing code. 
\
\
Therefore, since we are using Flutter, we also need to learn and use Dart in writing the main codes. Fortunately, Dart is similar to another language, Java, which we are relatively familiar with. Despite unfamiliar with Dart at first, we can sense its semantic using experience in Java and eventually come in handy.

3. Android Studio
Android Studio is the official Integrated Development Environment (IDE) for Android app development. Based on the powerful code editor and developer tools from IntelliJ IDEA , Android Studio offers even more features that enhance the productivity when building Android apps. It is also one of the requirement for developing Android apps using Flutter.
\
\
As we are using another Integrated Development Environment (IDE) that we are more familiar with (Visual Studio Code), we mainly don't use Android Studio as an IDE. Instead, it provides the mobile emulator that can reflect the live change of our application, which is very useful in development process.

4. Github
GitHub, is an Internet hosting service for software development and version control using Git. It provides the distributed version control of Git plus access control, bug tracking, software feature requests, task management, continuous integration, and wikis for every project. It is commonly used to host open source software development projects.
\
\
As this project has two developers, it is extremely crucial to have an effective and efficient version control method to combine and share our works. Github has helped us a lot as we can easily get and share the latest version of each others' progress using simple and short command. We can also trackback to previous version of each file in Github to recover our progress in case of some unexpected error in the latest version. 

5. Firebase:
Firebase is a Backend-as-a-Service (BaaS) app development platform that provides hosted backend services such as a realtime database, cloud storage, authentication, crash reporting, machine learning, remote configuration, and hosting for static files. It supports Flutter as a plugin and we can use most of the functionality of Firebase in our Flutter project.
\
\
We have used Firebase in several parts of our project. An example is the user email authentication via Firebase, where the email and password registered by the user will be stored in the database of Firebase and be used for login authentication purpose. We also plan to use Firebase's database to store some users' information, and use Firebase's cloud function for one-time-pass (OTP) authentication.

6. Google Maps Platform API:
Google Maps Platform API is a service provided by Google to create real world and real time experiences with dynamic maps, routes & places. With Google Maps API, we can display interactive maps and customize them how you want on the website or mobile apps.
\
\
We can show the live locations of users in the map using Google Maps Platform API. Ideally, we can even implement a map interface similar to the popular mobile game Pokemon Go, where each “pokemon” around the user is replaced with different questions posted by other users.
\
\
However, one thing to take note is the Google Maps Platform API is not a free service. We use the service by registering for three months free trial in Google Cloud Console using our Google account. Within the trial period, we are able to utilize a certain amount of free credit (USD$300, which is around SGD$400) for their services. Therefore, we need to be careful and keep monitoring the remaining balance while using the map service.


## Software Development Process
**Planning:**  
Our project's motivation starts from the common problem most of the students will face: Who can help me when I'm facing academic problem? Inspired by other existing apps such as **_NUSNextBus_** and SCDF’s **_myResponder_**, we decide to combine their advantages and apply to our project.

Our idea starts from "Making an apps so that every NUS students can post their questions, and others can browse to help". This mode is similar to **_Carousell_**'s page where users can browse different items in a screen and see if they want to buy anything. This concept has been implemented as our **Browse Screen**, which is the first screen users will be interacted with after then login the apps. 

The **Browse Screen** shows all the questions posted by users, who are also known as "mentees". Users can browse the questions in **Browse Screen** and decide to help the mentees to solve their questions, these users who help others are known as "mentors". Furthermore, the mentors can search for questions that are specific to a certain course (a new term replacing "module") by entering the course code in a search bar. This feature can help them narrow down their target from a large question bank.

Now we have done the designing of our core feature. Intuitively, our next challenge will be, how should the users post their question? It leads us to our second screen - **Camera Screen**, where users can upload their question along with some descriptions to seek for assistance from others. To upload an image of the question, users can choose between capturing photo with native camera or get it from the device's photo gallery. After choosing an image, users can add descriptions about the question, e.g. pain point of the question and course code (if applicable), and also the location to meet up. These questions will be shown in **Browse Screen** eventually.

Until here, the apps are only managing the interaction between user and our system. Once a mentor decide to help a mentee with his or her question, the apps need to serve as a bridge between the mentor and mentee. Therefore, there are more new and challenging considerations.

First of all, when a mentor decide to help a mentee, we need to reserve the question to that mentor so that other users can't choose to be the mentor anymore. We choose to employ this first-come-first-serve mechanism because we don't want to form conflict between mentors as the result of fighting for the question. This is similar to the rider-hailing apps where the customers are assigned to only one driver who accepts the request first.

While providing convenience to the mentor by reserving the mentee for he or she, we also need to ensure that the mentee will receive the assistance as intended. As such, the reservation has a time limit, which means the mentor need to arrive to the designated location by the mentee within the time limit. The question will be reopened to other users if the mentor fail to meet the mentee within the time limit.

For sure, if the mentoring is profitable, there will be more users who are willing to help. But at the same time, we don't want to cost too much financial burden to the mentee. As a result, we decide to set a standard price around SGD$4 as the hourly rate for the mentoring session, as we deem that this should be sufficient to have a decent meal around the campus. This price only serves as a reference when the mentee post the question, but the final decision still depends on the discussion between both the mentor and the mentee. To assist, we will set an in-apps timer for the users to record the time once they start the mentoring session, and we will implement a random generated qrcode for users for e-payment purpose.

Until here, a full routine of mentoring session from uploading questions, matching mentors and mentees, processing the mentoring session to completing the session with payment, is considered completed. This is the main service of our mobile apps, and we will have other functionalities to assist this service.

One of the assistive functionality is the **Map Screen**, where the users can check their live locations in the map. Ideally, we can implement a map interface similar to the popular mobile game **_Pokemon Go_**, where each "pokemon" around the user is replaced with different questions posted by other users.

We also want a **Profile Screen** to record user details, such as mentor ranking, rating given by other users, current taking courses, and courses prefer to teach. We plan to integrate these informations with more gamification features to provide more fun and inclusive user experience. It also serves as an important showcase of the user to other users.

Last but not least, considering that our project will success in NUS, we are preparing to apply this idea to other university in Singapore, or even overseas. For this purpose, as the courses and campus map belongs to a certain university, we will need to categorize our users based on their university. Therefore, the users are required to register an account using their school email, which we will verify by One-Time-Pass (OTP) to the email.

**Designing:**  
*13 May 2023 - 18 May 2023*  
With the complete ideas, the next step will be creating a prototype to visualize the mobile application's interface. We have many good choices such as Google Slides, Canvas, and Figma, and our final decision is an application called **JustInMind**. With a lot of useful functions provided, we have drafted various screens and simulates the user interactions. Unfortunately, we didn't manage to delve into more details before our free trial ends. Ultimately, we have taken a recording of the simple prototype as referral and start building the apps.

**Implementing:**  
*8 May 2023 - 12 May 2023*  
We start learning the framework (Flutter) and the programming language (Dart) online. It takes about a week to learn the basic concept and syntax required, and to install the software requirements in our devices. We also set up our github repository for the project, and start learning about git to perform version control.


*10 May 2023*  
We have created the our first poster and video for the lift off event. The poster includes a basic introduction, simple features, theme and techstack. The one minute long video is about the motivation and introduction of the project. The poster and video serve as the first impression of our projects, and we will keep updating them subsequently. 

*19 May 2023 - 23 May 2023*  
We have implemented the **Login Screen** based on the prototype that we have designed earlier. As this is still at the early stage of developing and we are not very familiar with Dart & Fluter yet, it takes a lot of time to figure out the way to adjust the layout of the interface and adding different components. Ultimately, the interface only contains the most basic components, which is some instructional texts, two textboxes for users to input email and password respectively, and a button to perform login.

*22 May 2023*  
There is a lot of different functionalities implemented in our apps, therefore we decide to divide them into different screens to ease the usage. There are four main screens that form the main contents of the apps: **Browse Screen**, **Map Screen**, **Camera Screen**, and **Profile Screen**. Before implementing the details of each screens, we have developed a navigation bar at the bottom of the apps, so that users can switch between different screens with the navigation bar.

*23 May 2023*  
Among the four main screens, the first screen that we decide to work on is the **Camera Screen** because the whole mentoring process starts from users uploading their query. At this time, the **Camera Screen** is able to utilize native camera to take picture, with the option of using device's flashlight, and switch to front-facing camera.

*24 May 2023*  
As an extension for the **Camera Screen**, besides capturing live picture, now the users can choose to select existing image from device gallery. The **Upload Query Screen** is also developed as the subsequent step of selecting an image for the query.

*25 May 2023*  
When the users want to upload a query, they also need to indicate the meeting location so that the mentor know where to go. Therefore, a **Set Location Screen** is implemented as one of the function in the **Upload Query Screen** to facilitate users in setting the meet up location. When users are searching for a location by typing the name of location, text autocomplete will be done based on the database of the locations.

*26 May 2023 - 28 May 2023*  
Moving back to the **Login Screen**, after placing the components, the next challenge will be reading the inputs and perform the authentication. For this goal, we will need to have a database that records the registered email and password, and the authentication mechanism should check if the users have input the matching credentials that exist in the database. Therefore, we have utilized Firebase for this purpose as it supports Flutter and provides the services that we require. With that, users can now register with their credentials in our **Login Screen**, and login to access the main contents of the apps subsequently.

*29 May 2023*  
The date of "Milestone 1" is around the corner, we treat it seriously as it serves as an important showcase of our progress within the past one month. We have updated the proposal, poster, and video with more details, and also build an Android Package Kit (APK) of our apps. Other groups who evaluate our project can download the APK and try the apps on their own devices without installing the softwares we have been using for development.

*30 May 2023*  
As an update in the **Upload Query Screen**, users can now search and select course codes of the query from remote JSON url. We also fix the user issue where pixel overflow happens when keyboard appears. 

*1 June 2023*  
As an update in the **Upload Query Screen**, we have added validation to the textfields. Furthermore, the query datas can now be passed to **Confirm Upload Screen**.

*2 June 2023*  
After we have collected the query data including text descriptions, image, course code, and meet up location, we need to store the data to a database in order to retrieve it and display it for other usage. Therefore, we have utilized Cloud Firestore, which is the Firebase's newest database for mobile app development, to store our query datas.

*3 June 2023*  
With the query datas in the Cloud Firestore, we are able to develop the next main screen that is closely related to the **Camera Screen**, which is the **Browse Screen**. As a recap, **Browse Screen** is the screen that gathers all the queries uploaded, so that users can browse the queries and choose to be mentor to help. We are able to retrieve the query datas from Cloud Firestore, and display them in the **Browse Screen**.

*4 June 2023*  
While we are working on the **Browse Screen**, we also start dealing with another screen that is relatively simple - **Map Screen**. We have integrated the Google Maps Platform API in our flutter apps to show the campus map, and have also implemented a button to indicate the users' current location on the map.  

*5 June 2023*  
As an update for the **Browse Screen**, users are able to filter queries by course codes based on their input in the search bar.

*6 June 2023*  
There are more small refinements to the **Browse Screen**. For instances, query images can be opened in full screen mode to provide a better view. To keep the queries fresh, each query will be removed from the screen after 60 minutes from the upload if no mentor decide to help. Furthermore, the screen will automatically sorts old posts to the top of the screen in order to increase exposure to users before they are gone.

*7 June 2023*  
As an extension to the **Browse Screen**, there is a **Query Info Screen** that displays more details of each queries listed.

*9 June 2023*  
As further enhancement to the **Browse Screen**, we have implemented the caching of network loaded images to improve user experience. We have also developed an animated pull screen down effect to refresh the queries in the screen.

*10 June 2023*  
Since most of the basic functionalities in the **Browse Screen** seems to be completed, we have added more details in the **Upload Query Screen**. Now, the "set location" function can get user's current location, add new markers in the map, and save the addresses by xy-coordinates.

*5 June 2023 - 10 June 2023*  
Since most of the main functionalities for the upload queries and browsing queries process, we start working on some assistive part that can provide more user experience. That leads us to our last main screen: **Profile Screen**. We have developed the whole interface based on the prototype we have designed earlier, with a setting button that leads to **Setting Screen**. Currently most of the functionalities are not implemented yet, except the logout button where user can logout from their current account. The logout functionality is also part of the authentication service provided by Firebase.

*11 June 2023*  
After settling most of the internal functionalities, we start to consider about pushing notification the the users while they are not using the apps. This is implemented using Firebase Messaging.

At the same time, we have received the update on NUS Authentication which we plan to implement in our apps. With NUS Authentication, users can login using their NUS Credentials instead of registering another account in our firebase database. However, after careful research and consideration, we have decided not to implement NUS Authentication in our mobile apps. 

Beside technical difficulties in redirecting the apps to an external link, we change our mind mainly because we realize that most of our user datas are stored in Firebase database. If we provide NUS Authentication as an alternative login method, it will bypass our Firebase authentication and we will face problem in retrieving and storing user data from Firebase database.

*12 June 2023*  
We have further developed the push notification function by adding more details. Now, we can send push notification to targetted device, show notification in application background. In apps, the notification will be displayed as an overlay alert, and is able to dismissed it. There is also an notification icon that can be dragged around on the screen.

On the other hand, as an alternative of NUS Authentication, we choose to verify the users' identity as NUS students by sending an One-Time-Pass (OTP) to their NUS email when they register at our apps. This requires us to set up Firebase Command Line Interface (CLI) in our device, and develop a cloud function to prepare for user OTP Verification.

*13 June 2023*  
When the mentors accept the query requests from **Browse Screen**, they are required to meet the mentee at the designated location within a time period. For this purpose, we have designed an in-apps timer that will countdown to record the reamining time. This timer can also be used to record the on-going timing of the mentoring session.

*16 June 2023 - 18 June 2023*  
Back to our OTP Verification feature, it has brought a lot of challenges in our development process. As we are a two-man team but the Firebase Console only recognize one of us as the main owner, some settings in the Firebase Console is only allowed to be modified by the main owner, which has brought some delay to the developer that is editor. Fortunately, these configuration settings only need to be done at the very first time deploying the cloud function. Any editor can freely deploy the modifed same name cloud function subsequently.

After developing the cloud functions, we need to provide our Google Account as the sender of the OTP email to the users. However, apparently Google has disabled this access method from third party previously due to account security reason. We are forced to seek for alternative mail service provider such as Mailgun, but it turns out that their free trial restricts to testing purpose and we may need to pay for it in order to send the email.

Surprisingly, we have found an OTP sending Flutter package that includes our desired features. We have tried on it and it works as we intended to. The only flaw is that the sender of email is set to be the developer's email. We will try to change its setting in order to let the sender of email be our own email soon. After that, we have touched up with our code and the **Login Screen** interface, which enables it to send an OTP email to the user's NUS email address, in order to verify user's student identity while registering an account in our apps.

*18 June 2023*  
When the mentor and the mentee meets up, we have design a qrcode scanning mechanism to verify their identities. In the **Profile Screen**, they can display their generated QR code based on UserID, and there is a QR code scanner for identity verification.


## Features

**Before matching mentor and mentee:**
- Academic questions can be posted and browsed by users, just like the **_Carousell_**'s page where users can browse different items in a screen and see if they want to buy anything.
- Mentors can search for questions that are specific to a certain course by entering the course code in a search bar. This feature can help them narrow down their target from a large question bank.
- Users can upload their question along with some descriptions to seek for assistance from others. To upload an image of the question, users can choose between capturing photo with native camera or get it from the device's photo gallery. After choosing an image, users can add descriptions about the question, e.g. pain point of the question and course code (if applicable), and also the location to meet up.
- First-come-first-serve mechanism, which means the first mentor who accept a help request can reserve the request in a limited time period.
- Live locations of users in the map. Ideally, we can implement a map interface similar to the popular mobile game **_Pokemon Go_**, where each "pokemon" around the user is replaced with different questions posted by other users.
- Profile page of users include informations such as mentor ranking, rating given by other users, current taking courses, and courses prefer to teach. 
- Gamification features to provide more fun and inclusive user experience.

**After matching mentor and mentee:**
- In-apps timer for the users to record the time after mentor has accepted a help request. The mentor's reservation will be cancelled if he or she fails to approach the mentee in a certain time limit.

**When mentoring session starts:**
- In-apps timer for the users to record the time after the mentoring session starts. The mentor and mentee can discuss and decide to adjust the time.

**After mentoring session:**
- Random generated qrcode for users for e-payment purpose.
- Mentee's can rate the mentor, which will show in the mentor's profile page, indicating the mentor's reliability.

## Installation
As we haven't plan to publish our mobile apps on Play Store so soon, the only way to try out the apps is to download the APK in local devices. The APK that contains the latest version of our apps will be updated for every "Milestone" event.

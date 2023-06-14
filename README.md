# Project's Title
**_TAanywhere_**

# Project Description
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
In our case, we want to develop a mobile application that can be deployed on various platforms. For simplicity, we start off with Android, and ideally we will extend to other operating system soon. While choosing the technology used for development, we notice that Flutter is a popular choice among mobile application developers, and hence we choose to employ this SDK as one of our main development tools.
\
The first challenge faced by a beginner in Flutter will be the installment process to the local device. We have put a lot of effort to install Flutter in our local devices and completed various settings to ensure our Flutter works properly.
\
Another major challenge faced by people who are not familiar in Flutter is the lack of existing examples. As a relatively new toolkit, it is challenging to find online resources or discussions regarding its syntax, especially if the issue is uncommon and specific to certain project. Most of the time, the flutter's official documentation only provide simple and limited example, which is not helpful when dealing with complex usage.

2. Dart:
Dart is a client-optimized language for developing fast apps on any platform. Its goal is to offer the most productive programming language for multi-platform development, paired with a flexible execution runtime platform for app frameworks.
\
Dart also forms the foundation of Flutter. Dart provides the language and runtimes that power Flutter apps, but Dart also supports many core developer tasks like formatting, analyzing, and testing code. 
\
Therefore, since we are using Flutter, we also need to learn and use Dart in writing the main codes. Fortunately, Dart is similar to another language, Java, which we are relatively familiar with. Despite unfamiliar with Dart at first, we can sense its semantic using experience in Java and eventually come in handy.

3. Android Studio
Android Studio is the official Integrated Development Environment (IDE) for Android app development. Based on the powerful code editor and developer tools from IntelliJ IDEA , Android Studio offers even more features that enhance the productivity when building Android apps. It is also one of the requirement for developing Android apps using Flutter.
\
As we are using another Integrated Development Environment (IDE) that we are more familiar with (Visual Studio Code), we mainly don't use Android Studio as an IDE. Instead, it provides the mobile emulator that can reflect the live change of our application, which is very useful in development process.

4. Github
GitHub, is an Internet hosting service for software development and version control using Git. It provides the distributed version control of Git plus access control, bug tracking, software feature requests, task management, continuous integration, and wikis for every project. It is commonly used to host open source software development projects.
\
As this project has two developers, it is extremely crucial to have an effective and efficient version control method to combine and share our works. Github has helped us a lot as we can easily get and share the latest version of each others' progress using simple and short command. We can also trackback to previous version of each file in Github to recover our progress in case of some unexpected error in the latest version. 

5. Firebase:
Firebase is a Backend-as-a-Service (BaaS) app development platform that provides hosted backend services such as a realtime database, cloud storage, authentication, crash reporting, machine learning, remote configuration, and hosting for static files. It supports Flutter as a plugin and we can use most of the functionality of Firebase in our Flutter project.
\
We have used firebase in several parts of our project. An example is the user email authentication via firebase, where the email and password registered by the user will be stored in the database of firebase and be used for login authentication purpose. We also plan to use firebase's database to store some users' information, and use firebase's cloud function for one-time-pass (OTP) authentication.

## Software Development Process
**Planning & Designing:**

Our project's motivation starts from the common problem most of the students will face: Who can help me when I'm facing academic problem? Inspired by other existing apps such as **_NUSNextBus_** and SCDF’s **_myResponder_**, we decide to combine their advantages and apply to our project.

Our idea starts from "Making an apps so that every NUS students can post their questions, and others can browse to help". This mode is similar to **_Carousell_**'s page where users can browse different items in a screen and see if they want to buy anything. This concept has been implemented as our **Browse Screen**, which is the first screen users will be interacted with after then login the apps. 

The **Browse Screen** shows all the questions posted by users, who are also known as "mentees". Users can browse the questions in **Browse Screen** and decide to help the mentees to solve their questions, these users who help others are known as "mentors". Furthermore, the mentors can search for questions that are specific to a certain course (a new term replacing "module") by entering the course code in a search bar. This feature can help them narrow down their target from a large question bank.

Now we have done the designing of our core feature. Intuitively, our next challenge will be, how should the users post their question? It leads us to our second screen - **Upload Screen**, where users can upload their question along with some descriptions to seek for assistance from others. To upload an image of the question, users can choose between capturing photo with native camera or get it from the device's photo gallery. After choosing an image, users can add descriptions about the question, e.g. pain point of the question and course code (if applicable), and also the location to meet up. These questions will be shown in **Browse Screen** eventually.

Until here, the apps are only managing the interaction between user and our system. Once a mentor decide to help a mentee with his or her question, the apps need to serve as a bridge between the mentor and mentee. Therefore, there are more new and challenging considerations.

First of all, when a mentor decide to help a mentee, we need to reserve the question to that mentor so that other users can't choose to be the mentor anymore. We choose to employ this first-come-first-serve mechanism because we don't want to form conflict between mentors as the result of fighting for the question. This is similar to the rider-hailing apps where the customers are assigned to only one driver who accepts the request first.

While providing convenience to the mentor by reserving the mentee for he or she, we also need to ensure that the mentee will receive the assistance as intended. As such, the reservation has a time limit, which means the mentor need to arrive to the designated location by the mentee within the time limit. The question will be reopened to other users if the mentor fail to meet the mentee within the time limit.

For sure, if the mentoring is profitable, there will be more users who are willing to help. But at the same time, we don't want to cost too much financial burden to the mentee. As a result, we decide to set a standard price around SGD$4 as the hourly rate for the mentoring session, as we deem that this should be sufficient to have a decent meal around the campus. This price only serves as a reference when the mentee post the question, but the final decision still depends on the discussion between both the mentor and the mentee. To assist, we will set an in-apps timer for the users to record the time once they start the mentoring session, and we will implement a random generated qrcode for users for e-payment purpose.

Until here, a full routine of mentoring session from uploading questions, matching mentors and mentees, processing the mentoring session to completing the session with payment, is considered completed. This is the main service of our mobile apps, and we will have other functionalities to assist this service.





## Features

- Import a HTML file and watch it magically convert to Markdown
- Drag and drop images (requires your Dropbox account be linked)
- Import and save files from GitHub, Dropbox, Google Drive and One Drive
- Drag and drop markdown and HTML files into Dillinger
- Export documents as Markdown, HTML and PDF

Markdown is a lightweight markup language based on the formatting conventions
that people naturally use in email.
As [John Gruber] writes on the [Markdown site][df1]

> The overriding design goal for Markdown's
> formatting syntax is to make it as readable
> as possible. The idea is that a
> Markdown-formatted document should be
> publishable as-is, as plain text, without
> looking like it's been marked up with tags
> or formatting instructions.

This text you see here is *actually- written in Markdown! To get a feel
for Markdown's syntax, type some text into the left window and
watch the results in the right.

## Tech

Dillinger uses a number of open source projects to work properly:

- [AngularJS] - HTML enhanced for web apps!
- [Ace Editor] - awesome web-based text editor
- [markdown-it] - Markdown parser done right. Fast and easy to extend.
- [Twitter Bootstrap] - great UI boilerplate for modern web apps
- [node.js] - evented I/O for the backend
- [Express] - fast node.js network app framework [@tjholowaychuk]
- [Gulp] - the streaming build system
- [Breakdance](https://breakdance.github.io/breakdance/) - HTML
to Markdown converter
- [jQuery] - duh

And of course Dillinger itself is open source with a [public repository][dill]
 on GitHub.

## Installation

Dillinger requires [Node.js](https://nodejs.org/) v10+ to run.

Install the dependencies and devDependencies and start the server.

```sh
cd dillinger
npm i
node app
```

For production environments...

```sh
npm install --production
NODE_ENV=production node app
```

## Plugins

Dillinger is currently extended with the following plugins.
Instructions on how to use them in your own application are linked below.

| Plugin | README |
| ------ | ------ |
| Dropbox | [plugins/dropbox/README.md][PlDb] |
| GitHub | [plugins/github/README.md][PlGh] |
| Google Drive | [plugins/googledrive/README.md][PlGd] |
| OneDrive | [plugins/onedrive/README.md][PlOd] |
| Medium | [plugins/medium/README.md][PlMe] |
| Google Analytics | [plugins/googleanalytics/README.md][PlGa] |

## Development

Want to contribute? Great!

Dillinger uses Gulp + Webpack for fast developing.
Make a change in your file and instantaneously see your updates!

Open your favorite Terminal and run these commands.

First Tab:

```sh
node app
```

Second Tab:

```sh
gulp watch
```

(optional) Third:

```sh
karma test
```

#### Building for source

For production release:

```sh
gulp build --prod
```

Generating pre-built zip archives for distribution:

```sh
gulp build dist --prod
```

## Docker

Dillinger is very easy to install and deploy in a Docker container.

By default, the Docker will expose port 8080, so change this within the
Dockerfile if necessary. When ready, simply use the Dockerfile to
build the image.

```sh
cd dillinger
docker build -t <youruser>/dillinger:${package.json.version} .
```

This will create the dillinger image and pull in the necessary dependencies.
Be sure to swap out `${package.json.version}` with the actual
version of Dillinger.

Once done, run the Docker image and map the port to whatever you wish on
your host. In this example, we simply map port 8000 of the host to
port 8080 of the Docker (or whatever port was exposed in the Dockerfile):

```sh
docker run -d -p 8000:8080 --restart=always --cap-add=SYS_ADMIN --name=dillinger <youruser>/dillinger:${package.json.version}
```

> Note: `--capt-add=SYS-ADMIN` is required for PDF rendering.

Verify the deployment by navigating to your server address in
your preferred browser.

```sh
127.0.0.1:8000
```

## License

MIT

**Free Software, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [dill]: <https://github.com/joemccann/dillinger>
   [git-repo-url]: <https://github.com/joemccann/dillinger.git>
   [john gruber]: <http://daringfireball.net>
   [df1]: <http://daringfireball.net/projects/markdown/>
   [markdown-it]: <https://github.com/markdown-it/markdown-it>
   [Ace Editor]: <http://ace.ajax.org>
   [node.js]: <http://nodejs.org>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [jQuery]: <http://jquery.com>
   [@tjholowaychuk]: <http://twitter.com/tjholowaychuk>
   [express]: <http://expressjs.com>
   [AngularJS]: <http://angularjs.org>
   [Gulp]: <http://gulpjs.com>

   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]: <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>

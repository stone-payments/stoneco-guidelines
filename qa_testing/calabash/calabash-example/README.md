#Calabash example

Install Calabash Android gem

```sh
gem install calabash-android
```
Resign APK File

```sh
calabash-android resign apps/app-debug.apk 
```

Install gems to run test

```sh
bundle install 
```

Run specific test

```sh
bundle exec calabash-android run apps/app.apk -p android --tags @Login
```
___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
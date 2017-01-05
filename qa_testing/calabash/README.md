# Calabash
Automated acceptance testing for mobile apps. 

![Logo](./static/calabash-top-bar.png "Calabash")

Calabash enables you to write and execute automated acceptance test of mobile apps. It's cross-platform, supporting android and iOS native apps. It's open source and free, developed and maintained by Xamarin.

## Index

* [Page objects pattern](#page-objects-pattern)
* [Project structure](#project-structure)
* [Background](#background)
* [Useful commands](#useful-commands)
* [References](#references)

### Page objects pattern

We've described how to improve the architecture of your test code base: using page objects you get better abstraction, reuse and cross-platform comes more easily.

A Page Object is an object that represents a single screen (page) in your application. For mobile, "screen object" would possibly be a better word, but Page Object is an established term that we'll stick with.

A page object should abstract a single screen in your application. It should expose methods to query the state and data of the screen as well as methods to take actions on the screen.

The most obvious benefit of this is abstraction and reuse. If you have several steps needing to navigate to details, the code for details(talk) is reused. Also, callers of this method need not worry about the details (e.g. query and touch) or navigating to this screen.

![Page object](./static/page_object.png "Page object")

You can learn about this pattern with the next guide: [Page object guide](https://github.com/calabash/x-platform-example)


### Project structure

![Project structure](./static/project_structure.png)

#### Folders

- app: contains the native app to test.
- features: contains only the .feature files. You can create subfolders to group the same concept.
- impl: contains the implementation necessary to run the test.
    - helpers: contains independent functions.
    - reports: contains the report with the results after run the test.
    - screens: contains the screens of the app.
        - general: shared screens.
        - android: specific android screens.
        - ios: specific iOS screens.
    - step_definitions: contains all the steps definitions reference inside features files.
    - support:
        - general: general config files.
        - android: calabash android config files.
        - ios: calabash android config files.


#### Useful files

- cucumber.yml: contains the application configurations.

![Cucumber YAML](./static/cucumber_yml.png "Cucumber YAML")

The *rerun* option allow to create a file with the failed scenarios. These scenarios can be run later with the *@impl/reports/failed-steps.txt* option. Examples:

```ruby
    
    android-rerun: PLATFORM=android SCREENSHOT_PATH=impl/reports/ <%= common_path %> <%= android_common_path %> -f 'Calabash::Formatters::Html' --out impl/reports/android.html -f rerun --out impl/reports/failed-steps.txt -v

    android-rerun-failed: PLATFORM=android SCREENSHOT_PATH=impl/reports/ <%= common_path %> <%= android_common_path %> -f 'Calabash::Formatters::Html' --out impl/reports/android_rerun_failed.html -f rerun --out impl/reports/final-failed-steps.txt @impl/reports/failed-steps.txt -v
```

Execution commands:

```sh
    
    bundle exec calabash-android run ../../../moom-tablet-android/app/build/outputs/apk/app-debug.apk -p android-rerun --tags @regression

    bundle exec calabash-android run ../../../moom-tablet-android/app/build/outputs/apk/app-debug.apk -p android-rerun-failed
```

- Gemfile: contains all the gem dependencies to install with *bundle install*

![Gemfile](./static/gemfile.png "Gemfile")

- Hook's files: contains the hooks for each platform.

This files are located inside *impl/support* directory, separated by one folder for each platform: *android* and *ios*.

Inside *impl/support/android* we can find the next files:

- app_installation_hooks.rb: contains the scenario and *AfterConfiguration* hooks.
- app_file_cycle_hooks.rb: contains the *Before* and *After* global hooks.
- hook.rb: contains the user custom hooks.

Inside *impl/support/ios* we can find the next files:

- 01_launch.rb: contains the default preconfigurated hooks.
- hooks.rb: contains the user custom hooks.

You can edit this files to accomplish your needs. You can read more about hooks [here](https://github.com/cucumber/cucumber/wiki/Hooks)

### Background

![Background format](./static/scenario_background.png "Scenario format")

The scenario data will be loaded in the initial background scenario. This data will be used by the different scenarios.
 
The background should be used for any generic task used by the feature's scenarios.


### Useful commands

```sh

    bundle exec calabash-android run ../../../moom-tablet-android/app/build/outputs/apk/app-debug.apk -p android-rerun --tags @regression

    bundle exec calabash-android run ../../../moom-tablet-android/app/build/outputs/apk/app-debug.apk -p android-rerun-failed

    show android devices run: adb devices -l

    show ios devices (DEVICE=XX) run: instruments -s devices

    Genymotion: VBoxManage list vms
```

### References

* [Calabash website](http://calaba.sh/)
* [Xamarin](https://developer.xamarin.com/guides/testcloud/calabash/introduction-to-calabash/) calabash guides and docs
* [calabash-android](https://github.com/calabash/calabash-android) calabash-android git repository
* [calabash-ios](https://github.com/calabash/calabash-ios) calabash-ios git repository

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies


# Weather Forecast Project

## How to Use

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/eleomilagrosa/weather_flutter_app.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter pub get 
```

**Step 3:**

Run the app using the following command

```
flutter run 
```


## Project Structure (MVVM architectural pattern)

```
-- Model-View-ViewModel File Structure --

assets/
    fonts/
    images/
lib/
    constant/
    utils/
    model/
        service/*.s.dart
        storage/
        *.m.dart
    view/
        ui/<modules>/*.v.dart
        widgets/
    view_model/
        *.vm.dart
    main.dart
```

```
-- File Structure Descriptions --

assets/fonts
    - Contains font files

assets/images
    - Contains images used internally 
    
lib/constant/
        - Contains static variables like string, color, dimens, styles

lib/utils/
    - Contains helpers

lib/model/service/*.s.dart
    - Contains REST - Service files
    - Contains functions that handles data from server (CRUD).

lib/model/storage/local_storage.dart
    - storing shared preference data

lib/model/*.m.dart
    - OOP/Objects/Models
    - format REST response to Objects

lib/view/ui/<modules>/*.v.dart
    - Contains Views/Pages per modules

lib/view/widgets/
    - Contains reusable widgets like alert, popups, input field, buttons

lib/view_model/*.vm.dart
    - ViewModel
    - Business Logic of the app
```
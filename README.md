# MoviesList.proj
Movies App is an iOS built with MVVM(Model View ViewModel) Architecture using Swift.

## Requirements
 - Xcode 12+
 - Swift 5.0+

## Contents

### Latest Movie List

A scrollable list of movies, ordered by descending release date, from [TMDb Discover Movies API](https://developers.themoviedb.org/3/discover/movie-discover)

### Movie Details

Page that features details of selected movies from [TMDb Movie Details API](https://developers.themoviedb.org/3/movies/get-movie-details)

## Design Considetations

### MVVM Architecture
MVVM architecture is used to maintain seperation of responsibilities to ensure maintainability and extensibility of code.
Code is separated into files to ensure manageability.

### Model Layer
Contained in `Services` folder, contains data logic, used to make API calls.
- `ApiService.swift`

### Controller Layer
Contained in `Controller` folder, prepares data received from the model. 
- `MovieViewController.swift` 
- `DetailViewController.swift` 

### ViewModel Layer
Contained in `ViewModel` folder, structures data as it should be represented in the view. 
- `MovieViewModel.swift` 
- `DetailViewModel.swift` 

### View layer
Contained in `View` folder, renders UI and passes user interactions to view model. 
- `MovieTableViewCell.swift` 

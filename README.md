# koolicar
koolicar test

##version
1.0

## IDE / Langage
xCode 9
SWIFT 4

## Main Pods
* Alamofire
* AlamofireObjectMapper
* AlamofireImage

#Pattern Design
* Singleton
* Factory
* ~MVC

### Issues known:
Stroyboard warning about Filter View Controller

### Left to do:
Localization implementation

## Structure:

* HomeViewController display home screen with VehicleMapViewController and VehicleTableViewController views embeded.
* FilterViewController display filter screen
* VehicleFileViewController display vehicle's file screen

* A Vehicle object is defined by the class Vehicle
* A vehicle list is managed by the class VehicleManager
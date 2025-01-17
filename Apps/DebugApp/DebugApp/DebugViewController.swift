import UIKit
import MapboxMaps

/**
 NOTE: This view controller should be used as a scratchpad
 while you develop new features. Changes to this file
 should not be committed.
 */

public class DebugViewController: UIViewController {

    internal var mapView: MapView!
    internal var runningAnimator: CameraAnimator?

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Deliberately set nil style
        mapView = MapView(frame: view.bounds, mapInitOptions: MapInitOptions(styleURI: nil))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.location.options.puckType = .puck2D()

        view.addSubview(mapView)

        // Convenience that takes a closure that's called when the style
        // is loaded or fails to load.
        //
        // Handling load callbacks is ALSO demonstrated below using the separate `onNext` & `onEvery`
        // callbacks
        mapView.mapboxMap.loadStyleURI(.streets) { result in
            switch result {
            case .success:
                print("The map has finished loading style")
            case let .failure(error):
                print("The map failed to load the style: \(error)")
            }
        }

        /**
         The closure is called when style data has been loaded. This is called
         multiple times. Use the event data to determine what kind of style data
         has been loaded.
         
         When the type is `style` this event most closely matches
         `-[MGLMapViewDelegate mapView:didFinishLoadingStyle:]` in SDK versions
         prior to v10.
         */
        mapView.mapboxMap.onEvery(.styleDataLoaded) { event in
            guard let data = event.data as? [String: Any],
                  let type = data["type"] else {
                return
            }

            print("The map has finished loading style data of type = \(type)")
        }

        /**
         The closure is called during the initialization of the map view and
         after any `styleDataLoaded` events; it is called when the requested
         style has been fully loaded, including the style, specified sprite and
         source metadata.

         This event is the last opportunity to modify the layout or appearance
         of the current style before the map view is displayed to the user.
         Adding a layer at this time to the map may result in the layer being
         presented BEFORE the rest of the map has finished rendering.

         Changes to sources or layers of the current style do not cause this
         event to be emitted.
         */
        mapView.mapboxMap.onNext(.styleLoaded) { (event) in
            print("The map has finished loading style ... Event = \(event)")
        }

        /**
         The closure is called whenever the map finishes loading and the map has
         rendered all visible tiles, either after the initial load OR after a
         style change has forced a reload.

         This is an ideal time to add any runtime styling or annotations to the
         map and ensures that these layers would only be shown after the map has
         been fully rendered.
         */
        mapView.mapboxMap.onNext(.mapLoaded) { (event) in
            print("The map has finished loading... Event = \(event)")
        }

        /**
         The closure is called whenever the map has failed to load. This could
         be because of a variety of reasons, including a network connection
         failure or a failure to fetch the style from the server.

         You can use the associated error message to notify the user that map
         data is unavailable.
         */
        mapView.mapboxMap.onNext(.mapLoadingError) { (event) in
            guard let data = event.data as? [String: Any],
                  let type = data["type"],
                  let message = data["message"] else {
                return
            }

            print("The map failed to load.. \(type) = \(message)")
        }
    }
}

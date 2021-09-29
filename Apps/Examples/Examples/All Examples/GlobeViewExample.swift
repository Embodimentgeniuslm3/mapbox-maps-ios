import UIKit
import MapboxMaps

@objc(GlobeViewExample)

public class GlobeViewExample: UIViewController, ExampleProtocol {

    internal var mapView: MapView!
    internal var skyLayer: SkyLayer!

    override public func viewDidLoad() {
        super.viewDidLoad()

        mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.ornaments.options.scaleBar.visibility = .visible
        mapView.mapboxMap.setProjection(mode: .globe)
        let projection = try? mapView.mapboxMap.getMapProjection()
        print("New projection: \(projection?.rawValue ?? "")")
        
        mapView.mapboxMap.onNext(.styleLoaded) { _ in
            self.addSkyLayer()
        }

        view.addSubview(mapView)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         // The below line is used for internal testing purposes only.
        finish()
    }
    
    func addSkyLayer() {
        skyLayer = SkyLayer(id: "sky-layer")
        skyLayer.skyType = .constant(.gradient)
        let azimuthalAngle: Double = 0
        let polarAngle: Double = 90
        skyLayer.skyAtmosphereSun = .constant([azimuthalAngle, polarAngle])
        skyLayer.skyAtmosphereSunIntensity = .constant(10)
        skyLayer.skyAtmosphereColor = .constant(StyleColor(.skyBlue))
        skyLayer.skyAtmosphereHaloColor = .constant(StyleColor(.lightPink))
        do {
            try mapView.mapboxMap.style.addLayer(skyLayer)
        } catch {
            print("Failed to add sky layer to the map's style.")
        }
    }
}

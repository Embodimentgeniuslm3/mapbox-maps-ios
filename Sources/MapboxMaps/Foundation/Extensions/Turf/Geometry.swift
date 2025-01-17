extension Geometry {

    /// Allows a Turf object to be initialized with an internal `Geometry` object.
    /// - Parameter geometry: The `Geometry` object to transform.
    internal init?(_ geometry: MapboxCommon.Geometry) {
        let optionalResult: Geometry?
        switch geometry.geometryType {
        case GeometryType_Point:
            optionalResult = geometry.extractLocations().map {
                .point(Point($0.coordinateValue()))
            }
        case GeometryType_Line:
            optionalResult = geometry.extractLocationsArray().map {
                .lineString(LineString($0.map { $0.coordinateValue() }))
            }
        case GeometryType_Polygon:
            optionalResult = geometry.extractLocations2DArray().map {
                .polygon(Polygon($0.map(NSValue.toCoordinates(array:))))
            }
        case GeometryType_MultiPoint:
            optionalResult = geometry.extractLocationsArray().map {
                .multiPoint(MultiPoint($0.map({ $0.coordinateValue() })))
            }
        case GeometryType_MultiLine:
            optionalResult = geometry.extractLocations2DArray().map {
                .multiLineString(MultiLineString($0.map(NSValue.toCoordinates(array:))))
            }
        case GeometryType_MultiPolygon:
            optionalResult = geometry.extractLocations3DArray().map {
                .multiPolygon(MultiPolygon($0.map(NSValue.toCoordinates2D(array:))))
            }
        case GeometryType_GeometryCollection:
            optionalResult = geometry.extractGeometriesArray().map {
                .geometryCollection(GeometryCollection(geometries: $0.compactMap(Geometry.init(_:))))
            }
        default:
            optionalResult = nil
        }

        guard let result = optionalResult else {
            return nil
        }
        self = result
    }
}

//
//  VertexDescription.swift
//  Geometry
//
//  Created by Eric Ito on 10/25/15.
//  Copyright © 2015 Eric Ito. All rights reserved.
//

import Foundation

/**
 Specifies how the attribute is interpolated along the segments. are
 represented as int64
*/
enum Interpolation: Int {
    case None = 0
    case Linear = 1
    case Angular = 2
}

/**
 Specifies the type of the attribute.
*/
enum Persistence: Int {
    case enumFloat = 0
    case enumDouble = 1
    case enumInt32 = 2
    case enumInt64 = 3
    /**
    8 bit integer. Can be signed or unsigned depending on platform.
    */
    case enumInt8 = 4
    case enumInt16 = 5
}

/**
 Describes the attribute and, in case of predefined attributes, provides a
 hint of the attribute use.
*/
public enum Semantics: Int {
    
    /** xy coordinates of a point (2D vector of double, linear interpolation)
    */
    case Position = 0
    
    /** z coordinates of a point (double, linear interpolation)
    */
    case Z = 1
    
    /** m attribute (double, linear interpolation)
    */
    case M = 2
    
    /** id (int, no interpolation)
    */
    case ID = 3
    
    /** xyz coordinates of normal vector (float, angular interpolation)
    */
    case NORMAL = 4
    
    /** u coordinates of texture (float, linear interpolation)
    */
    case TEXTURE1D = 5
    
    /** uv coordinates of texture (float, linear interpolation)
    */
    case TEXTURE2D = 6
    
    /** uvw coordinates of texture (float, linear interpolation)
    */
    case TEXTURE3D = 7
    
    /** two component ID
    */
    case ID2 = 8
    
    /** the max semantics value
    */
    case MAXSEMANTICS = 10
}

/**
* Describes the vertex format of a Geometry.
*
* Geometry objects store vertices. The vertex is a multi attribute entity. It
* has mandatory X, Y coordinates. In addition it may have Z, M, ID, and other
* user specified attributes. Geometries point to VertexDescription instances.
* If the two Geometries have same set of attributes, they point to the same
* VertexDescription instance. <br>
* To create a new VertexDescription use the VertexDescriptionDesigner class. <br>
* The VertexDescription allows to add new attribute types easily (see ID2). <br>
* The attributes are stored sorted by Semantics value. <br>
* Note: You could also think of the VertexDescription as a schema of a database
* table. You may look the vertices of a Geometry as if they are stored in a
* database table, and the VertexDescription defines the fields of the table.
*/
public class VertexDescription {
    
    /**
    
    Returns a packed array of double representation of all ordinates of
    attributes of a point, i.e.: X, Y, Z, ID, TEXTURE2D.u, TEXTURE2D.v
    */
    private var defaultPointAttributes = [Double]()
    
    private var pointAttributeOffsets = [Int]()
    
    /**
     Returns the attribute count of this description. The value is always
     greater or equal to 1. The first attribute is always a POSITION.
    */
    public private (set) final var attributeCount: Int = 0
    
    /**
     - returns: the semantics of the given attribute.
    
     - parameter attributeIndex:
                The index of the attribute in the description. Max value is
                GetAttributeCount() - 1.
    */
    public final func semanticsForIndex(index: Int) -> Int {
        if index < 0 || index > attributeCount {
            fatalError("Index out of bounds")
        }
        return semantics[index]
    }
    
    /**
     Returns the index the given attribute in the vertex description.
    
     - parameter semantics:
     - returns: Returns the attribute index or -1 of the attribute does not exist
    */
    public final func attributeIndexForSemantics(semantics: Int) -> Int {
        return semanticsToIndexMap[semantics];
    }
    
    /**
     Returns the interpolation type for the attribute.
    
     - parameter semantics: The semantics of the attribute.
    */
    func interpolationForSemantics(semantics: Int) -> Interpolation {
        return interpolation[semantics];
    }
    
    /**
     Returns the persistence type for the attribute.
    
     - parameter semantics: The semantics of the attribute.
    */
    func persistenceForSemantics(semantics: Int) -> Persistence {
        return persistence[semantics];
    }


    /**
     Returns the size of the persistence type in bytes.
    
     - parameter persistence: The persistence type to query.
    */
    func sizeForPersistence(persistence: Int) -> Int {
        return persistenceSize[persistence];
    }
    
    /**
      Returns the size of the semantics in bytes.
    */
    func persistenceSizeForSemantics(semantics: Int) -> Int {
        return persistenceSizeForSemantics(persistenceForSemantics(semantics).rawValue) * componentCountForSemantics(semantics)
    }
    
    /**
     Returns the number of the components of the given semantics. For example,
     it returns 2 for the POSITION.
    
     - parameter semantics: The semantics of the attribute.
    */
    public func componentCountForSemantics(semantics: Int) -> Int {
        return components[semantics];
    }
    
    /**
     Returns True for integer persistence type.
    */
    func isIntegerPersistence(persistence: Persistence) -> Bool {
        return persistence.rawValue < Persistence.enumInt32.rawValue;
    }
    
    /**
     Returns True for integer semantics type.
    */
    func isIntegerSemantics(semantics: Int) -> Bool {
        return isIntegerPersistence(persistenceForSemantics(semantics))
    }
    
    /**
     Returns True if the attribute with the given name and given set exists.
    
     - parameter semantics: The semantics of the attribute.
    */
    public func hasAttribute(semantics: Semantics) -> Bool {
        return semanticsToIndexMap[semantics.rawValue] >= 0;
    }
    
    /**
     Returns True, if the vertex has Z attribute.
    */
    public func hasZ() -> Bool {
        return hasAttribute(Semantics.Z);
    }
    
    /**
     Returns True, if the vertex has M attribute.
    */
    public func hasM() -> Bool {
        return hasAttribute(Semantics.M);
    }
    
    /**
     Returns True, if the vertex has ID attribute.
    */
    public func hasID() -> Bool {
        return hasAttribute(Semantics.ID);
    }
    
    /**
     Returns default value for each ordinate of the vertex attribute with
     given semantics.
    */
    public func defaultValueForSemantics(semantics: Semantics) -> Double {
        return defaultValues[semantics.rawValue];
    }
    
    /**
      Returns the total component count.
    */
    public private(set) var totalComponentCount: Int = 0
    
    /**
     Checks if the given value is the default one. The simple equality test
     with GetDefaultValue does not work due to the use of NaNs as default
     value for some parameters.
    */
    public func isDefaultValue(semantics: Int, v: Double) -> Bool {
        return false
        // FIXME:
//        return NumberUtils.doubleToInt64Bits(defaultValues[semantics]) == NumberUtils
//				.doubleToInt64Bits(v);
    }
    
    func persistenceFromSize(size: Int) -> Persistence {
        if (size == 4) {
            return Persistence.enumInt32;
        } else if (size == 8) {
            return Persistence.enumInt64;
        } else {
          fatalError("Invalid size")
        }
    }
    
    // FIXME:
//    public func equals(other: VertexDescription) -> Bool {
//        return (self as VertexDescription) == other
//    }
    
    func calculateHash() -> Int {
        var v: Int = NumberUtils.hash(semantics[0]);
        for i in 1..<attributeCount {
            v = NumberUtils.hash(v, n: semantics[i])
        }
        
        return v // if attribute size is 1, it returns 0
    }
    
    func defaultPointAttributeValueForIndex(attributeIndex: Int, ordinate: Int) -> Double {
        return defaultPointAttributes[pointAttributeOffsetForIndex(attributeIndex)
				+ ordinate]
    }
    
    /**
    
     Returns an offset to the first ordinate of the given attribute. This
     method is used for the cases when one wants to have a packed array of
     ordinates of all attributes, i.e.: X, Y, Z, ID, TEXTURE2D.u, TEXTURE2D.v
    */
    func pointAttributeOffsetForIndex(attributeIndex: Int) -> Int {
        return pointAttributeOffsets[attributeIndex]
    }
    
    func pointAttributeOffsetFromSemantics(semantics: Int) -> Int {
        return pointAttributeOffsets[attributeIndexForSemantics(semantics)]
    }
    
    func totalComponents() -> Int {
        return defaultPointAttributes.count
    }
    
    public func hashCode() -> Int {
        return hash
    }
    
    // TODO: clone, equald, hashcode - whats really needed?
    
    var semantics = [Int]()
    
    var semanticsToIndexMap = [Int]()
    
    var hash: Int = 0
    
    private let defaultValues: [Double] = [0.0, 0.0, Double.NaN, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    private let interpolation: [Interpolation] = [
        .Linear,
        .Linear,
        .Linear,
        .None,
        .Angular,
        .Linear,
        .Linear,
        .Linear,
        .None
    ]
    
    private let persistence: [Persistence] = [
        .enumDouble,
        .enumDouble,
        .enumDouble,
        .enumInt32,
        .enumFloat,
        .enumFloat,
        .enumFloat,
        .enumFloat,
        .enumInt32
    ]
    
    let persistenceSize: [Int] = [4, 8, 4, 8, 1, 2]
    
    let components: [Int] = [2, 1, 1, 1, 3, 1, 2, 3, 2]
    
    init() {}
    
//    init(hashValue: Int, other: VertexDescription) {
//        attributeCount = other.attributeCount
//        totalComponentCount = other.totalComponentCount
//        
//        // FIXME:
////        semantics = other.semantics.clone()
//        // FIXME:
////        semanticsToIndexMap = other.semanticsToIndexMap.clone()
//        
//        hash = other.hash
//        
//        // prepare default values for the Point geometry
//        //
//        pointAttributeOffsets = Array<Int>(count: attributeCount, repeatedValue: 0)
//        var offset: Int = 0
//        for i in 0..<attributeCount {
//            pointAttributeOffsets[i] = offset
//            offset += getComponentCount(semantics[i])
//        }
//        totalComponentCount = offset
//        defaultPointAttributes = Array<Double>(count: offset, repeatedValue: 0.0)
//        for i in 0..<attributeCount {
//            let components = getComponentCount(semantics[i])
//
//            
//        }
//    }
    

/*
    
    VertexDescription(int hashValue, VertexDescription other) {
    m_defaultPointAttributes = new double[offset];
    for (int i = 0; i < getAttributeCount(); i++) {
    int components = getComponentCount(getSemantics(i));
    double dv = getDefaultValue(getSemantics(i));
    for (int icomp = 0; icomp < components; icomp++)
				m_defaultPointAttributes[m_pointAttributeOffsets[i] + icomp] = dv;
    }
    }
  
    
*/
}
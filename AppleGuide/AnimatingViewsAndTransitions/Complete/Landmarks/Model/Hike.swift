/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A representation of a hike.
 */

import Foundation

struct Hike: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var distance: Double
    var difficulty: Int
    var observations: [Observation]
    
    static var formatter = LengthFormatter()
    
    var distanceText: String {
        Hike.formatter
            .string(fromValue: distance, unit: .kilometer)
    }
    
    /*
     {
         "name":"Lonesome Ridge Trail",
         "id":1001,
         "distance":4.5,
         "difficulty":3,
         "observations":[
             {
                 "elevation":[
                     291.65263635636268,
                     309.26016677925196
                 ],
                 "pace":[
                     396.08716481908732,
                     403.68937873525232
                 ],
                 "heartRate":[
                     117.16351898665887,
                     121.95815455919609
                 ],
                 "distanceFromStart":0
             },
             {
                 "elevation":[
                     299.24001936628116,
                     317.44584350790012
                 ],
                 "pace":[
                     380.19020240756623,
                     395.3978319010256
                 ],
                 "heartRate":[
                     117.6410892152911,
                     124.82185220506081
                 ],
                 "distanceFromStart":0.375
             },
             {
                 "elevation":[
                     303.62145464574394,
                     336.05569457646544
                 ],
                 "pace":[
                     380.55927782266116,
                     397.60789726832775
                 ],
                 "heartRate":[
                     121.52696452049059,
                     127.31525441110122
                 ],
                 "distanceFromStart":0.75
             },
             {
                 "elevation":[
                     319.90393365162629,
                     346.26966025518789
                 ],
                 "pace":[
                     357.94116421258531,
                     398.0750288648062
                 ],
                 "heartRate":[
                     123.75908585923588,
                     132.77069404486801
                 ],
                 "distanceFromStart":1.125
             },
             {
                 "elevation":[
                     354.17104439267905,
                     403.57031216972939
                 ],
                 "pace":[
                     335.07385149392701,
                     397.82674381875808
                 ],
                 "heartRate":[
                     130.8235194572915,
                     140.55700591418218
                 ],
                 "distanceFromStart":1.5
             },
             {
                 "elevation":[
                     357.42992871175124,
                     385.92155620623635
                 ],
                 "pace":[
                     395.16168913839374,
                     404.60294066527558
                 ],
                 "heartRate":[
                     131.5456052446734,
                     134.65984504627627
                 ],
                 "distanceFromStart":1.875
             },
             {
                 "elevation":[
                     345.47736721935661,
                     363.18776661379422
                 ],
                 "pace":[
                     340.82303041339082,
                     404.71689228682374
                 ],
                 "heartRate":[
                     125.1949698433959,
                     131.31354363122026
                 ],
                 "distanceFromStart":2.25
             },
             {
                 "elevation":[
                     346.23343025200535,
                     497.23376445462401
                 ],
                 "pace":[
                     261.27629148816021,
                     331.68516208719467
                 ],
                 "heartRate":[
                     131.67810544238606,
                     154.26779645311458
                 ],
                 "distanceFromStart":2.625
             },
             {
                 "elevation":[
                     491.57378483134391,
                     547.49535224251053
                 ],
                 "pace":[
                     296.05298644112088,
                     401.14092967732398
                 ],
                 "heartRate":[
                     151.36398089694217,
                     166.20454793289232
                 ],
                 "distanceFromStart":3
             },
             {
                 "elevation":[
                     472.06803233416338,
                     531.92570520228401
                 ],
                 "pace":[
                     395.50830663514012,
                     401.67837917543591
                 ],
                 "heartRate":[
                     134.41798110234078,
                     151.90886697564241
                 ],
                 "distanceFromStart":3.375
             },
             {
                 "elevation":[
                     339.81419476005283,
                     461.03832527824829
                 ],
                 "pace":[
                     395.31160487975183,
                     404.49550455974907
                 ],
                 "heartRate":[
                     129.97753472415462,
                     138.13531094848992
                 ],
                 "distanceFromStart":3.75
             },
             {
                 "elevation":[
                     303.1495508565697,
                     342.3532820173541
                 ],
                 "pace":[
                     395.02844559698116,
                     402.65878340653796
                 ],
                 "heartRate":[
                     127.72304232462609,
                     133.26322270764186
                 ],
                 "distanceFromStart":4.125
             }
         ]
     }
     */
    struct Observation: Codable, Hashable {
        var distanceFromStart: Double
        
        var elevation: Range<Double>
        var pace: Range<Double>
        var heartRate: Range<Double>
    }
}

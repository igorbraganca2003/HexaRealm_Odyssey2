//
//  Olds.swift
//  HexaRealm_Odyssey2
//
//  Created by Igor Bragança Toledo on 23/02/25.
//

//    func createHexagons(columns: Int, rows: Int, size: CGFloat) {
//        let width = 2 * size
//        let height = sqrt(3) * size
//
//        for row in 0..<rows {
//            for col in 0..<columns {
//                let x = CGFloat(col) * 1.5 * size
//                let y = CGFloat(row) * height
//
//                var hexPosition = CGPoint(x: x, y: y)
//
//                if col % 2 != 0 {
//                    hexPosition.y -= height / 2
//                }
//
//                let hexagon = createHexagon(size: size)
//                hexagon.position = hexPosition
//                hexagon.name = "hexagon"
//                addChild(hexagon)
//                hexagons[hexPosition] = hexagon
//            }
//        }
//    }

//
//  DrawView.swift
//  Assignment4
//
//  Created by Cole Dorma on 2016-03-28.
//  Copyright © 2016 Cole Dorma. All rights reserved.
//

import Foundation
import UIKit

class DrawView: UIView {
    var selectedLineIndex: Int?
    var newLine: Line?
    var endGameLine: Line?
    var prevPoint: CGPoint?
    
    var currentLines = [NSValue:Line]() //dictionary of key-value pairs
    var finishedLines: [Line] = [Line]();
    var playerLine: [Line] = [Line]();
    var gameBoardPOI : [CGPoint?] = []; //POI For the Gameboard
    var firstTurn = true;
    var touchesBegan = 0;
    var gameWinner = 0;
    var nextTurn = " "
    var numberOfPlays = 0;
    var gameFinished = false;
    var incorrectValue = false;
    
    var gameBoardP1 : CGPoint?
    var gameBoardP2 : CGPoint?
    var gameBoardP3 : CGPoint?
    var gameBoardP4 : CGPoint?
    
    // Making The Grid
    var C1 = " "
    var C2 = " "
    var C3 = " "
    var C4 = " "
    var C5 = " "
    var C6 = " "
    var C7 = " "
    var C8 = " "
    var C9 = " "
    
    var grid = ""
    
    var intersectCount = 0;
    
    var gameBoard: Bool = true;
    var playerTurn = 1;
    
    var turn = "";
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var currentLineColor: UIColor = UIColor.redColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func linesIntersect(line1: Line, line2: Line) -> (intersects: Bool, point : CGPoint?){
        //Intersect algorithm used from link below
        //http://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
        
        let p0_x = line1.begin.x
        let p1_x = line1.end.x
        let p2_x = line2.begin.x
        let p3_x = line2.end.x
        
        let p0_y = line1.begin.y
        let p1_y = line1.end.y
        let p2_y = line2.begin.y
        let p3_y = line2.end.y
        
        let s1_x = p1_x - p0_x
        let s1_y = p1_y - p0_y
        let s2_x = p3_x - p2_x
        let s2_y = p3_y - p2_y
        
        let s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y)
        let t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y)
        
        if (s >= 0 && s <= 1 && t >= 0 && t <= 1){
            //Intersect detected
            let finalX = p0_x + (t * s1_x)
            let finalY = p0_y + (t * s1_y)
            return (true, CGPointMake(finalX, finalY))
        }
        
        return (false, nil) // No intersect
        
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder);
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
    }
    
    
    func doubleTap(gestureRecognizer: UIGestureRecognizer){
        if (selectedLineIndex != nil){
            print("Game in progress...")
        } else if (gameWinner == 1 || gameWinner == 2 || gameFinished == true){ //Restart game
            gameWinner = 0;
            finishedLines = []
            playerLine = []
            gameBoard = true;
            touchesBegan = 0;
            intersectCount = 0;
            playerTurn = 1;
            gameBoardPOI = [];
            firstTurn = true;
            nextTurn = " "
            numberOfPlays = 0;
            gameFinished = false
            C1 = " "
            C2 = " "
            C3 = " "
            C4 = " "
            C5 = " "
            C6 = " "
            C7 = " "
            C8 = " "
            C9 = " "
            grid = ""
            intersectCount = 0;
            turn = "";
            
        } else {
            print("Game in progress...")
        }
        setNeedsDisplay()
    }
    
    func distanceBetween(from: CGPoint, to: CGPoint) -> CFloat{
        let distXsquared = Float((to.x-from.x)*(to.x-from.x))
        let distYsquared = Float((to.y-from.y)*(to.y-from.y))
        return sqrt(distXsquared + distYsquared);
    }
    
    func indexOfLineNearPoint(point: CGPoint) -> Int? {
        let tolerence: Float = 1.0 //experiment with this value
        for(index,line) in finishedLines.enumerate(){
            let begin = line.begin
            let end = line.end
            let lineLength = distanceBetween(begin, to: end)
            let beginToTapDistance = distanceBetween(begin, to: point)
            let endToTapDistance = distanceBetween(end, to: point)
            if (beginToTapDistance + endToTapDistance - lineLength) < tolerence {
                return index
            }
        }
        return nil
    }
    
    func strokeLine(line: Line){
        //User BezierPath to draw lines
        let path = UIBezierPath();
        path.lineWidth = 10;
        path.lineCapStyle = CGLineCap.Round;
        
        path.moveToPoint(line.begin);
        path.addLineToPoint(line.end);
        path.stroke(); //actually draw the path
    }
    
    override func drawRect(rect: CGRect) {
        
        
        //draw the finished lines
        finishedLineColor.setStroke() //finished lines in black
        for line in finishedLines{
            strokeLine(line);
            
        }
        
        //draw current line if it exists
        for(_,line) in currentLines {
            currentLineColor.setStroke(); //current line in red
            strokeLine(line);
        }
        
        
    }

    
    //-------------- FOR STRAIGHT LINES --------------------------
    //Override Touch Functions
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(__FUNCTION__) //for debugging
        for touch in touches {
            if(gameFinished == false){
                if(gameBoard == true){ //Board not made
                    let location = touch.locationInView(self)
                    newLine = Line(begin: location, end: location)
                    let key = NSValue(nonretainedObject: touch)
                    currentLines[key] = newLine
                } else if (gameBoard == false){ //Board made
                    if (touchesBegan == 0){
                        playerLine = [];
                    }
                    let location = touch.locationInView(self)
                    prevPoint = location;
                }
            }
        }
        setNeedsDisplay(); //this view needs to be updated
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //print(__FUNCTION__); //for debugging
        for touch in touches {
            if (gameFinished == false){
                if (gameBoard == true){ //Board not made
                    let location = touch.locationInView(self);
                    let key = NSValue(nonretainedObject: touch)
                    currentLines[key]?.end = location;
                    newLine?.end = location;
                } else if (gameBoard == false){ //Board made
                    let newPoint = touch.locationInView(self);
                    finishedLines.append(Line(begin: prevPoint!, end: newPoint));
                    playerLine.append(Line(begin: prevPoint!, end: newPoint));
                    prevPoint = newPoint;
                    setNeedsDisplay();
                }
            }
        }
        setNeedsDisplay(); //this view needs to be updated
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(__FUNCTION__); //for debugging
        for touch in touches {
            if (gameFinished == false){
                if (gameBoard == true){ // Board not made
                    let location = touch.locationInView(self); //get location in view co-ordinates
                    let key = NSValue(nonretainedObject: touch)
                    currentLines[key]?.end = location;
                    newLine?.end = location;
                    finishedLines.append(currentLines[key]!);
                    currentLines[key] = nil;
                } else if (gameBoard == false){ // Board made
                    touchesBegan++;
                    finishedLines.append(Line(begin: prevPoint!, end: prevPoint!));
                    playerLine.append(Line(begin: prevPoint!, end: prevPoint!));
                    
                }
            }
        }
        setNeedsDisplay(); //this view needs to be updated
        
        if(gameBoard == true){
            intersectCount = 0;
            
            for (var i = 1; i < finishedLines.count; i++) {
                for (var j = 0; j < i; j++) {
                    let intersect = linesIntersect(finishedLines[j], line2: finishedLines[i])

                    if (intersect.intersects == true){
                        intersectCount++;
                    }
                    
                    if (finishedLines.count > 3 && intersect.intersects == true){
                        gameBoardPOI.append(intersect.point);
                    }
                    
                }
            }
            
            if (finishedLines.count > 3 && intersectCount == 4){ // Find each point of intersection of the board and set the points
                
                gameBoardPOI.sortInPlace({ $0!.y < $1!.y });
                gameBoardP1 = gameBoardPOI[0];
                gameBoardP2 = gameBoardPOI[1];
                gameBoardP3 = gameBoardPOI[2];
                gameBoardP4 = gameBoardPOI[3];
                
                if (gameBoardP1!.x > gameBoardP2!.x){
                    gameBoardP1 = gameBoardPOI[1];
                    gameBoardP2 = gameBoardPOI[0];
                }
                
                if (gameBoardP3!.x > gameBoardP4!.x){
                    gameBoardP3 = gameBoardPOI[3];
                    gameBoardP4 = gameBoardPOI[2];
                }
                
                print("   |   |   ")
                print("---+---+---")
                print("   |   |   ")
                print("---+---+---")
                print("   |   |   ")
                
                gameBoard = false;
                
            }

            if (finishedLines.count > 3 && intersectCount < 4 ){ // CHECK FOR GAMEBOARD VALIDITY
                print("GAMEBOARD INVALID!")
                intersectCount = 0;
                finishedLines = []
                gameBoardPOI = []
                touchesBegan = 0
                playerLine = []
            }
            
        } else if (gameBoard == false){
            
            let checkForX = getRect(playerLine)
            
            if (touchesBegan == 1 && (nextTurn == "O" || nextTurn == " ") && distanceBetween(playerLine[0].begin, to: playerLine[playerLine.count-1].end) < 30){ // CORRECT O INPUT
                turn = "O";
                nextTurn = "X"
                
                updateGameBoard(playerLine[0].begin)
                if (incorrectValue == true){
                    numberOfPlays--
                    for lineOne in finishedLines {
                        for lineTwo in playerLine {
                            if (lineOne.begin == lineTwo.begin && lineOne.end == lineTwo.end){
                                let index = finishedLines.indexOf({$0.begin == lineOne.begin && $0.end == lineOne.end})
                                finishedLines.removeAtIndex(index!)
                            }
                        }
                    }
                    nextTurn = "O"
                }
                incorrectValue = false;
                touchesBegan = 0;
                
            } else if (touchesBegan == 1 && (nextTurn == "O" || nextTurn == " ") && distanceBetween(playerLine[0].begin, to: playerLine[playerLine.count-1].end) > 30){ //INCORRECT O INPUT
                if (firstTurn == true){
                    return;
                }
                
                for lineOne in finishedLines {
                    for lineTwo in playerLine {
                        if (lineOne.begin == lineTwo.begin && lineOne.end == lineTwo.end){
                            let index = finishedLines.indexOf({$0.begin == lineOne.begin && $0.end == lineOne.end})
                            finishedLines.removeAtIndex(index!)
                        }
                    }
                }

                touchesBegan = 0;
            
            } else if (touchesBegan == 2 && (nextTurn == "X" || nextTurn == " ")) { //CORRECT X INPUT
                var valid = false;
                for line in playerLine {
                    if (distanceBetween(checkForX.centre, to: line.begin) < 5){
                        turn = "X"
                        nextTurn = "O"
                        touchesBegan = 0;
                        if (firstTurn == true){
                            firstTurn = false;
                        }
                        
                        updateGameBoard(playerLine[0].begin)
                        valid = true;
                        if (incorrectValue == true){
                            numberOfPlays--
                            valid = false;
                        }
                        incorrectValue = false;
                        break;
                    } 
                }
                
                if (valid == false){ //INCORRECT X INPUT
                    for lineOne in finishedLines {
                        for lineTwo in playerLine {
                            if (lineOne.begin == lineTwo.begin && lineOne.end == lineTwo.end){
                                let index = finishedLines.indexOf({$0.begin == lineOne.begin && $0.end == lineOne.end})
                                finishedLines.removeAtIndex(index!)
                            }
                        }
                    }
                    if (firstTurn == false){
                        nextTurn = "X"
                    }
                    
                    touchesBegan = 0;
                }
                
            }

        }

        
    }
    
    
    
    func updateGameBoard(point: CGPoint?) { //For updating the gamebaord with the new values
        grid = ""
        numberOfPlays++
        
        if (point!.x <= gameBoardP1!.x && point!.y <= gameBoardP1!.y && C1 == " "){ // Cell 1
            if(turn == "O") {
                C1 = "O"
            } else if (turn == "X") {
                C1 = "X"
            }
        } else if (point!.x >= gameBoardP1!.x && point!.y <= gameBoardP1!.y && point!.x <= gameBoardP2!.x && C2 == " "){ // Cell 2
            if(turn == "O") {
                C2 = "O"
            } else if (turn == "X") {
                C2 = "X"
            }
        } else if (point!.x >= gameBoardP2!.x && point!.y <= gameBoardP2!.y && C3 == " "){ // Cell 3
            if(turn == "O") {
                C3 = "O"
            } else if (turn == "X") {
                C3 = "X"
            }
        } else if (point!.y >= gameBoardP1!.y && point!.y <= gameBoardP3!.y && point!.x <= gameBoardP3!.x && C4 == " "){ // Cell 4
            if(turn == "O") {
                C4 = "O"
            } else if (turn == "X") {
                C4 = "X"
            }
        } else if (point!.x >= gameBoardP3!.x && point!.x <= gameBoardP4!.x && point!.y >= gameBoardP1!.y && point!.y <= gameBoardP3!.y && C5 == " "){ // Cell 5
            if(turn == "O") {
                C5 = "O"
            } else if (turn == "X") {
                C5 = "X"
            }
        } else if (point!.x >= gameBoardP4!.x && point!.y >= gameBoardP2!.y && point!.y <= gameBoardP4!.y && C6 == " "){ // Cell 6
            if(turn == "O") {
                C6 = "O"
            } else if (turn == "X") {
                C6 = "X"
            }
        } else if (point!.x <= gameBoardP3!.x && point!.y >= gameBoardP3!.y && C7 == " "){ // Cell 7
            if(turn == "O") {
                C7 = "O"
            } else if (turn == "X") {
                C7 = "X"
            }
        } else if (point!.x >= gameBoardP3!.x && point!.x <= gameBoardP4!.x && point!.y >= gameBoardP3!.y && C8 == " "){ // Cell 8
            if(turn == "O") {
                C8 = "O"
            } else if (turn == "X") {
                C8 = "X"
            }
        } else if (point!.x >= gameBoardP4!.x && point!.y >= gameBoardP4!.y && C9 == " "){ // Cell 9
            if(turn == "O") {
                C9 = "O"
            } else if (turn == "X") {
                C9 = "X"
            }
        } else {
            incorrectValue = true;
            return;
        }
        
        grid += "\n" + " \(C1) | \(C2) | \(C3)  "
        grid += "\n" + "---+---+---"
        grid += "\n" + " \(C4) | \(C5) | \(C6)  "
        grid += "\n" + "---+---+---"
        grid += "\n" + " \(C7) | \(C8) | \(C9)  "
        
        print(grid)
        
        let currentGame = checkForWinner();
        currentGame;
        
        if (currentGame == true){ //Check for winners or not
            if(gameWinner == 1){
                print("X WINS!!!")
                gameFinished = true;
            } else if (gameWinner == 2){
                print("O WINS!!!")
                gameFinished = true;
            }
        } else {
            print("NO ONE HAS WON YET...")
        }
        
    }
    
    func checkForWinner() -> Bool { //Check for winners or not
        let amountX: CGFloat = 100.0
        let amountY: CGFloat = 50.0
        endGameLine = Line(begin: CGPoint.zero, end: CGPoint.zero)
        
        //case 1: Player one winner, case 2: Player two winner case 3: Draw ELSE NOT DONE
        if ((C1 == "X") && (C2 == "X") && (C3 == "X")){
            //ROW ONE ALL Xs
            endGameLine?.begin.x = gameBoardP1!.x - amountX
            endGameLine?.begin.y = gameBoardP1!.y - amountY
            endGameLine?.end.x = gameBoardP2!.x + amountX
            endGameLine?.end.y = gameBoardP2!.y - amountY
            finishedLines.append(endGameLine!)
            gameWinner = 1;
            return true;
        } else if ((C4 == "X") && (C5 == "X") && (C6 == "X")){
            //ROW TWO ALL Xs
            endGameLine?.begin.x = gameBoardP3!.x - amountX
            endGameLine?.begin.y = gameBoardP3!.y - amountY
            endGameLine?.end.x = gameBoardP4!.x + amountX
            endGameLine?.end.y = gameBoardP4!.y - amountY
            finishedLines.append(endGameLine!)
            gameWinner = 1;
            return true;
        } else if ((C7 == "X") && (C8 == "X") && (C9 == "X")){
            //ROW THREE ALL Xs
            endGameLine?.begin.x = gameBoardP3!.x - amountX
            endGameLine?.begin.y = gameBoardP3!.y + amountY
            endGameLine?.end.x = gameBoardP4!.x + amountX
            endGameLine?.end.y = gameBoardP4!.y + amountY
            finishedLines.append(endGameLine!)
            gameWinner = 1;
            return true;
        } else if ((C3 == "X") && (C5 == "X") && (C7 == "X")){
            //DIAGONAL FROM RIGHT CORNER ALL Xs
            endGameLine?.begin.x = gameBoardP2!.x + amountX
            endGameLine?.begin.y = gameBoardP1!.y - amountX
            endGameLine?.end.x = gameBoardP3!.x - amountX
            endGameLine?.end.y = gameBoardP3!.y + amountX
            finishedLines.append(endGameLine!)
            gameWinner = 1;
            return true;
        } else if ((C1 == "X") && (C5 == "X") && (C9 == "X")){
            //DIAGONAL FROM LEFT CORNER ALL Xs
            endGameLine?.begin.x = gameBoardP1!.x - amountX
            endGameLine?.begin.y = gameBoardP1!.y - amountX
            endGameLine?.end.x = gameBoardP4!.x + amountX
            endGameLine?.end.y = gameBoardP4!.y + amountX
            finishedLines.append(endGameLine!)
            gameWinner = 1;
            return true;
        } else if ((C1 == "X") && (C4 == "X") && (C7 == "X")){
            //COLUMN ONE ALL Xs
            endGameLine?.begin.x = gameBoardP1!.x - amountY
            endGameLine?.begin.y = gameBoardP1!.y - amountX
            endGameLine?.end.x = gameBoardP3!.x - amountY
            endGameLine?.end.y = gameBoardP3!.y + amountX
            finishedLines.append(endGameLine!)
            gameWinner = 1;
            return true;
        } else if ((C2 == "X") && (C5 == "X") && (C8 == "X")){
            //COLUMN TWO ALL Xs
            endGameLine?.begin.x = gameBoardP1!.x + amountY
            endGameLine?.begin.y = gameBoardP1!.y - amountX
            endGameLine?.end.x = gameBoardP3!.x + amountY
            endGameLine?.end.y = gameBoardP3!.y + amountX
            finishedLines.append(endGameLine!)
            gameWinner = 1;
            return true;
        } else if ((C3 == "X") && (C6 == "X") && (C9 == "X")){
            //COLUMN THREE ALL Xs
            endGameLine?.begin.x = gameBoardP2!.x + amountY
            endGameLine?.begin.y = gameBoardP2!.y - amountX
            endGameLine?.end.x = gameBoardP4!.x + amountY
            endGameLine?.end.y = gameBoardP4!.y + amountX
            finishedLines.append(endGameLine!)
            gameWinner = 1;
            return true;
        } else if ((C1 == "O") && (C2 == "O") && (C3 == "O")){
            //ROW ONE ALL Os
            endGameLine?.begin.x = gameBoardP1!.x - amountX
            endGameLine?.begin.y = gameBoardP1!.y - amountY
            endGameLine?.end.x = gameBoardP2!.x + amountX
            endGameLine?.end.y = gameBoardP2!.y - amountY
            finishedLines.append(endGameLine!)
            gameWinner = 2;
            return true;
        } else if ((C4 == "O") && (C5 == "O") && (C6 == "O")){
            //ROW TWO ALL Os
            endGameLine?.begin.x = gameBoardP3!.x - amountX
            endGameLine?.begin.y = gameBoardP3!.y - amountY
            endGameLine?.end.x = gameBoardP4!.x + amountX
            endGameLine?.end.y = gameBoardP4!.y - amountY
            finishedLines.append(endGameLine!)
            gameWinner = 2;
            return true;
        } else if ((C7 == "O") && (C8 == "O") && (C9 == "O")){
            //ROW THREE ALL Os
            endGameLine?.begin.x = gameBoardP3!.x - amountX
            endGameLine?.begin.y = gameBoardP3!.y + amountY
            endGameLine?.end.x = gameBoardP4!.x + amountX
            endGameLine?.end.y = gameBoardP4!.y + amountY
            finishedLines.append(endGameLine!)
            gameWinner = 2;
            return true;
        } else if ((C3 == "O") && (C5 == "O") && (C7 == "O")){
            //DIAGONAL FROM RIGHT CORNER ALL Os
            endGameLine?.begin.x = gameBoardP2!.x + amountX
            endGameLine?.begin.y = gameBoardP1!.y - amountX
            endGameLine?.end.x = gameBoardP3!.x - amountX
            endGameLine?.end.y = gameBoardP3!.y + amountX
            finishedLines.append(endGameLine!)
            gameWinner = 2;
            return true;
        } else if ((C1 == "O") && (C5 == "O") && (C9 == "O")){
            //DIAGONAL FROM LEFT CORNER ALL Os
            endGameLine?.begin.x = gameBoardP1!.x - amountX
            endGameLine?.begin.y = gameBoardP1!.y - amountX
            endGameLine?.end.x = gameBoardP4!.x + amountX
            endGameLine?.end.y = gameBoardP4!.y + amountX
            finishedLines.append(endGameLine!)
            gameWinner = 2;
            return true;
        } else if ((C1 == "O") && (C4 == "O") && (C7 == "O")){
            //COLUMN ONE ALL Os
            endGameLine?.begin.x = gameBoardP1!.x - amountY
            endGameLine?.begin.y = gameBoardP1!.y - amountX
            endGameLine?.end.x = gameBoardP3!.x - amountY
            endGameLine?.end.y = gameBoardP3!.y + amountX
            finishedLines.append(endGameLine!)
            gameWinner = 2;
            return true;
        } else if ((C2 == "O") && (C5 == "O") && (C8 == "O")){
            //COLUMN TWO ALL Os
            endGameLine?.begin.x = gameBoardP1!.x + amountY
            endGameLine?.begin.y = gameBoardP1!.y - amountX
            endGameLine?.end.x = gameBoardP3!.x + amountY
            endGameLine?.end.y = gameBoardP3!.y + amountX
            finishedLines.append(endGameLine!)
            gameWinner = 2;
            return true;
        } else if ((C3 == "O") && (C6 == "O") && (C9 == "O")){
            //COLUMN THREE ALL Os
            endGameLine?.begin.x = gameBoardP2!.x + amountY
            endGameLine?.begin.y = gameBoardP2!.y - amountX
            endGameLine?.end.x = gameBoardP4!.x + amountY
            endGameLine?.end.y = gameBoardP4!.y + amountX
            finishedLines.append(endGameLine!)
            gameWinner = 2;
            return true;
        } else if (numberOfPlays == 9){
            print("DRAW!")
            gameFinished = true;
            return true;
        } else {
            //Still not done	
            return false;
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
    }
    
    func getRect(lines: [Line]) -> (rect: CGRect,diff: CGFloat,centre: CGPoint) { //Rect, difference and centre of rect function of CGPoints
        var min_x: CGFloat = lines[0].begin.x
        var max_x: CGFloat = lines[0].begin.x
        var min_y: CGFloat = lines[0].begin.y
        var max_y: CGFloat = lines[0].begin.y
        
        for line in lines {
            if (line.begin.x < min_x) { min_x = line.begin.x }
            else if (line.begin.x > max_x) { max_x = line.begin.x }
            else if (line.begin.y < min_y) { min_y = line.begin.y }
            else if (line.begin.y > max_y) { max_y = line.begin.y }
        }
        
        let rect: CGRect = CGRectMake(min_x, min_y, max_x - min_x, max_y - min_y)
        let center: CGPoint = CGPoint(x: rect.origin.x + (rect.width)/2, y: rect.origin.y + (rect.height)/2)
        
        return (rect, abs(rect.width - rect.height), center)
    }
    
    
}
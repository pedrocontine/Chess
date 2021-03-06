import Foundation

//Exercise`s protocol
protocol ExerciseProtocol{
    func printBoard()
    func move(from: (x:Int,y:Int), to: (x:Int,y:Int)) -> Bool
}

// ----------------------------------------------------------------------------------------------------------------
// ENUMERATIONS
// ----------------------------------------------------------------------------------------------------------------

//Pieces colors
public enum Color{
    case black
    case white
}

//Types of moviments
public enum TypeOfMove{
    case horizontal
    case vertical
    case diagonal1
    case diagonal2
    case diagonal3
    case diagonal4
    case knight
    case castling
    case error
}

// ----------------------------------------------------------------------------------------------------------------
// CLASSES
// ----------------------------------------------------------------------------------------------------------------

//Generic class
class Piece{
    var color: Color
    var symbol: String
    
    init(color: Color, symbol: String){
        self.color = color
        self.symbol = symbol
    }
    
    func move(from: (x:Int,y:Int), to: (x:Int,y:Int)) -> (valid:Bool,type:TypeOfMove){
        var moveReturn: (valid:Bool, type:TypeOfMove)
        print("Move")
        moveReturn = (false, .error)
        return moveReturn
    }
}

//Classes of diferent types of pieces
class Paw: Piece{
    
    override func move(from: (x:Int,y:Int), to: (x:Int,y:Int)) -> (valid:Bool,type:TypeOfMove){
        
        var moveReturn: (valid:Bool, type:TypeOfMove)
        moveReturn.type = typeOfMove(fromX: from.x, fromY: from.y, toX: to.x, toY: to.y)
        
        //Verify if is only one square you are trying to move
        if abs(from.y - to.y) == 1{
            //Verify if the move match the color rule
            if isPawnMoveAllowedByColor(fromY:from.y, toY:to.y){
                //Verify if the move is allowed
                if isPawnMoveValid(pieceColor: game.turn, moveType: moveReturn.type, toX:to.x, toY:to.y){
                    moveReturn.valid = true
                }
                //Move invalid
                else{
                    moveReturn.valid = false
                }
            }
            //This pawn color cant move this way
            else{
                moveReturn.valid = false
            }
        }
        //If is the first move, paw can move 2 squares 
        else if abs(from.y - to.y) == 2 && isPawnFirstMove(fromY:from.y, toY:to.y){
           moveReturn.valid = true
        }
        //Invalid move
        else{
            moveReturn.valid = false
        }

        return moveReturn
    }
}

class Rook: Piece{
    
    //Property to verify if the rock move is possible
    var rightMoved:Bool
    var leftMoved:Bool

    init(color:Color, symbol:String, rightMoved:Bool, leftMoved:Bool){
        self.rightMoved = rightMoved
        self.leftMoved = leftMoved
        super.init(color:color, symbol:symbol)
    }

    override func move(from: (x:Int,y:Int), to: (x:Int,y:Int)) -> (valid:Bool,type:TypeOfMove){
        
        var moveReturn: (valid:Bool, type:TypeOfMove)
        moveReturn.type = typeOfMove(fromX: from.x, fromY: from.y, toX: to.x, toY: to.y)
        
        //Verify what types of moves are valid
        switch moveReturn.type{
        case .horizontal, .vertical:
            moveReturn.valid = true
        default:
            moveReturn.valid = false
        }
        
        return moveReturn
    }
}

class Knight: Piece{
    
    override func move(from: (x:Int,y:Int), to: (x:Int,y:Int)) -> (valid:Bool,type:TypeOfMove){
        
        var moveReturn: (valid:Bool, type:TypeOfMove)
        moveReturn.type = typeOfMove(fromX: from.x, fromY: from.y, toX: to.x, toY: to.y)
        
        //Verify what types of moves are valid
        switch moveReturn.type{
        case .knight:
            moveReturn.valid = true
        default:
            moveReturn.valid = false
        }
        
        return moveReturn
    }
}

class Bishop: Piece{
    
    override func move(from: (x:Int,y:Int), to: (x:Int,y:Int)) -> (valid:Bool,type:TypeOfMove){
        
        var moveReturn: (valid:Bool, type:TypeOfMove)
        moveReturn.type = typeOfMove(fromX: from.x, fromY: from.y, toX: to.x, toY: to.y)
        
        //Verify what types of moves are valid
        switch moveReturn.type{
        case .diagonal1, .diagonal2, .diagonal3, .diagonal4 :
            moveReturn.valid = true
        default:
            moveReturn.valid = false
        }
        
        return moveReturn
    }
}

class Queen: Piece{
    
    override func move(from: (x:Int,y:Int), to: (x:Int,y:Int)) -> (valid:Bool,type:TypeOfMove){
        
        var moveReturn: (valid:Bool, type:TypeOfMove)
        moveReturn.type = typeOfMove(fromX: from.x, fromY: from.y, toX: to.x, toY: to.y)
        
        //Verify what types of moves are valid
        switch moveReturn.type{
        case .horizontal, .vertical, .diagonal1, .diagonal2, .diagonal3, .diagonal4 :
            moveReturn.valid = true
        default:
            moveReturn.valid = false
        }
        
        return moveReturn
    }
}

class King: Piece{

    //Property to verify if the rock move is possible
    var moved:Bool

    init(color:Color, symbol:String, moved:Bool){
        self.moved = moved
        super.init(color:color, symbol:symbol)
    }

    override func move(from: (x:Int,y:Int), to: (x:Int,y:Int)) -> (valid:Bool,type:TypeOfMove){
        
        var moveReturn: (valid:Bool, type:TypeOfMove)
        moveReturn.type = typeOfMove(fromX: from.x, fromY: from.y, toX: to.x, toY: to.y)
        
        //Verify if is only one square you are trying to move
        if abs(from.x - to.x) == 1 || abs(from.y - to.y) == 1{
            //Verify what types of moves are valid
            switch moveReturn.type{
            case .horizontal, .vertical, .diagonal1, .diagonal2, .diagonal3, .diagonal4 :
                moveReturn.valid = true
            default:
                moveReturn.valid = false
            }
        }
        //Verify if is a castling type move
        else if moveReturn.type == .castling{
            //Verify if is the first move of the king and the selected rook
            if isCastlingValid(fromX:from.x, fromY:from.y, toX:to.x, toY:to.y){
                moveReturn.valid = true
            }
            //Cant to the castling
            else{
                moveReturn.valid = false
            }
        }
        else{
            moveReturn.valid = false
        }

        return moveReturn
    }
}

//Class to start a new game and to use the functions to play
class Chess: ExerciseProtocol{
    var turn: Color
    var chessBoard: [[Piece?]]
    var endGame: Bool
    
    //Set the initial parameters
    init(){
        self.turn = .white
        self.chessBoard = createChessBoard()
        self.endGame = false
    }
    
    //Call the function to print the board
    func printBoard(){
       // printChessBoard(chessBoard: game.chessBoard)
       printChessBoard_ONLINEPLAYGROUND(chessBoard: game.chessBoard)
    }
    
    //Call the function to move a piece
    func move(from: (x:Int,y:Int), to: (x:Int,y:Int)) -> Bool{
        
        //Variable to catch the return bool
        var valid = false
        
        //Verify if the coordinates are valid
        guard areCoordinatesInChessboard(from: (x: from.x, y: from.y), to: (x: to.x, y: to.y)) else { return false }
        
        //Convert the coordinates given to matrix axes
        let coordinates = convertCoordinates(from: (x: from.x, y: from.y), to: (x: to.x, y: to.y))
        
        //Verify if in the origin has a piece
        if let piece = game.chessBoard[coordinates.fromY][coordinates.fromX]{

            //Verify if the color of the piece selected is the color of the turn
            if piece.color == game.turn{

                //Call the especific piece move function
                var moveResult = piece.move(from: (x:coordinates.fromX, y:coordinates.fromY), to: (x:coordinates.toX, y:coordinates.toY))
                
                //Make all the verifications if the move is possible
                if isMovePossible(piece:piece, moveResult: moveResult, coordinates:coordinates) == true{
                    valid = true
                }
                //The selected piece cant move this way
                else{
                    valid = false
                }
            }
            //Isnt your turn to play
            else{
                valid = false
            }
        }
        //If there isnt a piece to move
        else{
            valid = false
        }

        //If the move was made, change the turn
        //changeTurn(valid:valid)

        return valid
    }
}

// ----------------------------------------------------------------------------------------------------------------
//  BASIC FUNCTIONS
// ----------------------------------------------------------------------------------------------------------------

//Function to create a filled chessBoard to start a new game
func createChessBoard() -> [[Piece?]]{
    
    //Matriz to use as board, without pieces by default
    var chessBoard = [[Piece?]](repeating: [Piece?](repeating: nil, count: 8), count: 8)
    
    //Array to storage the pieces
    let arrayPieces = createPieces()
    
    //Fill the chessboard with the pieces in the original position
    chessBoard = putPiecesOnChessboard(emptyChessBoard: chessBoard, arrayPieces: arrayPieces)
    
    return chessBoard
}

//Function that create the pieces and save in an array.
func createPieces() -> [Piece]{
    
    /*

    MUDEI OS SIMBOLOS PARA FICAR MELHOR NO PLAYGROUND ONLINE

    //b is short for Black, w is short for White.
    let bPaw: Paw = Paw(color: .black, symbol: "♙")
    let bRook: Rook = Rook(color: .black, symbol: "♖")
    let bKnight: Knight = Knight(color: .black, symbol: "♘")
    let bBishop: Bishop = Bishop(color: .black, symbol: "♗")
    let bQueen: Queen = Queen(color: .black, symbol: "♕")
    let bKing: King = King(color: .black, symbol: "♔")
    
    let wPaw: Paw = Paw(color: .white, symbol: "\u{265F}\u{fe0e}")
    let wRook: Rook = Rook(color: .white, symbol: "♜")
    let wKnight: Knight = Knight(color: .white, symbol: "♞")
    let wBishop: Bishop = Bishop(color: .white, symbol: "♝")
    let wQueen: Queen = Queen(color: .white, symbol: "♛")
    let wKing: King = King(color: .white, symbol: "♚")
    */

    let bPaw: Paw = Paw(color: .black, symbol: "bP")
    let bRook: Rook = Rook(color: .black, symbol: "bR", rightMoved: false, leftMoved: false)
    let bKnight: Knight = Knight(color: .black, symbol: "bH")
    let bBishop: Bishop = Bishop(color: .black, symbol: "bB")
    let bQueen: Queen = Queen(color: .black, symbol: "bQ")
    let bKing: King = King(color: .black, symbol: "bK", moved: false)
    
    let wPaw: Paw = Paw(color: .white, symbol: "wP")
    let wRook: Rook = Rook(color: .white, symbol: "wR", rightMoved: false, leftMoved: false)
    let wKnight: Knight = Knight(color: .white, symbol: "wH")
    let wBishop: Bishop = Bishop(color: .white, symbol: "wB")
    let wQueen: Queen = Queen(color: .white, symbol: "wQ")
    let wKing: King = King(color: .white, symbol: "wK", moved: false)
    
    let arrayPieces: [Piece] = [bPaw, bRook, bKnight, bBishop, bQueen, bKing, wPaw, wRook, wKnight, wBishop, wQueen, wKing]
    
    return arrayPieces
}

//Function to put the pieces on the chessboard
func putPiecesOnChessboard(emptyChessBoard: [[Piece?]], arrayPieces: [Piece]) -> [[Piece?]]{
    
    var filledChessBoard: [[Piece?]] = emptyChessBoard
    let arrayPieces: [Piece] = arrayPieces
    
    for line in 0...7{
        for column in 0...7{
            //Black Pieces
            if line == 0{
                if (column == 0 || column == 7){
                    filledChessBoard[line][column] = arrayPieces[1]
                }
                else if (column == 1 || column == 6){
                    filledChessBoard[line][column] = arrayPieces[2]
                }
                else if (column == 2 || column == 5){
                    filledChessBoard[line][column] = arrayPieces[3]
                }
                else if column == 3{
                    filledChessBoard[line][column] = arrayPieces[4]
                }
                else if column == 4{
                    filledChessBoard[line][column] = arrayPieces[5]
                }
            }
            //Black Paws
            else if line == 1{
                filledChessBoard[line][column] = arrayPieces[0]
            }
            //White Paws
            else if line == 6{
                filledChessBoard[line][column] = arrayPieces[6]
            }
            //White Pieces
            else if line == 7{
                if (column == 0 || column == 7){
                    filledChessBoard[line][column] = arrayPieces[7]
                }
                else if (column == 1 || column == 6){
                    filledChessBoard[line][column] = arrayPieces[8]
                }
                else if (column == 2 || column == 5){
                    filledChessBoard[line][column] = arrayPieces[9]
                }
                else if column == 3{
                    filledChessBoard[line][column] = arrayPieces[10]
                }
                else if column == 4{
                    filledChessBoard[line][column] = arrayPieces[11]
                }
            }
            else{
                filledChessBoard[line][column] = nil
            }
        }
    }
    
    return filledChessBoard
}

//Function that print the chessboard (TO USE ON MAC)
func printChessBoard(chessBoard: [[Piece?]]){
    
    let chessBoard: [[Piece?]] = chessBoard
    let arrayEmojis: [String] = ["①","②","③","④","⑤","⑥","⑦","⑧"]
    
    for line in 0...8{
        var printedLine = ""
        print("")
        for column in 0...8{
            if (line != 0 && column != 0){
                if chessBoard[line-1][column-1] == nil{
                    printedLine += ("  ▢ ")
                }
                else{
                    printedLine += "  " + (chessBoard[line-1][column-1]?.symbol)! + " "
                }
            }
            else if (line == 0 && column == 0){
                printedLine += ("    ")
            }
            else if (line == 0){
                printedLine += ("  \(arrayEmojis[column-1]) ")
            }
            else{
                printedLine += (" \(arrayEmojis[8 - line]) ")
            }
        }
        print(printedLine)
    }
}

//Function that print the chessboard (TO USE ON ONLINE PLAYGROUND)
func printChessBoard_ONLINEPLAYGROUND(chessBoard: [[Piece?]]){
    
    let chessBoard: [[Piece?]] = chessBoard
    print("")
    print("")
    for line in 0...8{
        var printedLine = ""
        for column in 0...8{
            if (line != 0 && column != 0){
                if chessBoard[line-1][column-1] == nil{
                    printedLine += (" .. ")
                }
                else{
                    printedLine += " " + (chessBoard[line-1][column-1]?.symbol)! + " "
                }
            }
            else if (line == 0 && column == 0){
               // printedLine += ("0")
            }
            else if (line == 0){
              //  printedLine += ("  \(column) ")
            }
            else{
                printedLine += ("\(9 - line) ")
            }
        }
        print(printedLine)
    }
}

//Function to change the turn
func changeTurn(valid:Bool){
    //If the move was made, change the turn
        if valid == true{
            switch game.turn{
            case .white:
                game.turn = .black
            case .black:
                game.turn = .white
            }
        }
        //Dont change the turn
        else{
        }
}

// ----------------------------------------------------------------------------------------------------------------
//  MOVEMENT FUNCTIONS
// ----------------------------------------------------------------------------------------------------------------

//Function to validate if the coordinates given are in the chessboard
func areCoordinatesInChessboard(from: (x:Int,y:Int), to: (x:Int,y:Int)) -> Bool{
    
    //Check board limits
    guard case 1...8 = from.x,
          case 1...8 = from.y,
          case 1...8 = to.x,
          case 1...8 = to.y
    else {
        // out of range
        return false
    }
    return true
}

//Function that convert the coordinates typed to the matriz scale
func convertCoordinates(from: (x:Int,y:Int), to: (x:Int,y:Int)) -> (fromX:Int, fromY:Int, toX:Int, toY:Int){
    
    //Create a tuple
    var coordinates: (fromX:Int, fromY:Int, toX:Int, toY:Int)
    
    //Make the conversions
    coordinates.fromY = 8 - from.y
    coordinates.fromX = from.x - 1
    coordinates.toY = 8 - to.y
    coordinates.toX = to.x - 1
    
    return coordinates
}

//Function that return the type of moviment you are trying to do
func typeOfMove(fromX:Int, fromY:Int, toX:Int, toY:Int) -> TypeOfMove{
    var typeOfMove:TypeOfMove
    
    //Verify if the move is in "L" format (Knight)
    if isKnightMove(fromX: fromX, fromY: fromY, toX: toX, toY: toY){
        typeOfMove = .knight
    }
    //Verify if the moviment is castling
    else if isCastling(fromX: fromX, fromY: fromY, toX: toX, toY: toY){
        typeOfMove = .castling
    }
    //Verify if the moviment is horizontal
    else if isHorizontalMove(fromX: fromX, fromY: fromY, toX: toX, toY: toY){
        typeOfMove = .horizontal
    }
    //Verify if the moviment is vertical
    else if isVerticalMove(fromX: fromX, fromY: fromY, toX: toX, toY: toY){
        typeOfMove = .vertical
    }
    //Verify if the moviment is diagonal1 (up and right)
    else if isDiagonal1Move(fromX: fromX, fromY: fromY, toX: toX, toY: toY){
        typeOfMove = .diagonal1
    }
    //Verify if the moviment is diagonal2 (up and left)
    else if isDiagonal2Move(fromX: fromX, fromY: fromY, toX: toX, toY: toY){
        typeOfMove = .diagonal2
    }
    //Verify if the moviment is diagonal3 (down and left)
    else if isDiagonal3Move(fromX: fromX, fromY: fromY, toX: toX, toY: toY){
        typeOfMove = .diagonal3
    }
    //Verify if the moviment is diagonal4 (down and right)
    else if isDiagonal4Move(fromX: fromX, fromY: fromY, toX: toX, toY: toY){
        typeOfMove = .diagonal4
    }
    else{
        typeOfMove = .error
    }
    
    return typeOfMove
}

//Function to verify if the movimnent is in "L" format
func isKnightMove(fromX:Int, fromY:Int, toX:Int, toY:Int) -> Bool{
    //If you move two columns and one line, the moviment is in L shape
    if abs(fromX - toX) == 2 && abs(fromY - toY) == 1{
        return true
    }
    //If you move one column and two lines, the moviment is in L shape
    else if abs(fromX - toX) == 1 && abs(fromY - toY) == 2{
        return true
    }
    //Is not a valid knight move
    else{
        return false
    }
}

//Function to verify if the moviment is horizontal
func isHorizontalMove(fromX:Int, fromY:Int, toX:Int, toY:Int) -> Bool{
    //If the original line is the same as the final line, but the column changed, the moviment is horizontal
    if (abs(fromY - toY) == 0 && abs(fromX - toX) != 0){
        return true
    }
    //Isnt horizontal
    else{
        return false
    }
}

//Function to verify if the moviment is horizontal
func isVerticalMove(fromX:Int, fromY:Int, toX:Int, toY:Int) -> Bool{
    //If the original column is the same as the final column, but the line changed, the moviment is horizontal
    if (abs(fromX - toX) == 0 && abs(fromY - toY) != 0){
        return true
    }
        //Isnt horizontal
    else{
        return false
    }
}

//Function to verify if the moviment is diagonal1
func isDiagonal1Move(fromX:Int, fromY:Int, toX:Int, toY:Int) -> Bool{
    //If the piece went right and up, is diagonal 1
    if isRight(fromX: fromX, toX: toX) && isUp(fromY: fromY, toY: toY){
        return true
    }
        //Isnt diagonal1
    else{
        return false
    }
}

//Function to verify if the moviment is diagonal2
func isDiagonal2Move(fromX:Int, fromY:Int, toX:Int, toY:Int) -> Bool{
    //If the piece went left and up, is diagonal 2
    if isLeft(fromX: fromX, toX: toX) && isUp(fromY: fromY, toY: toY){
        return true
    }
        //Isnt diagonal2
    else{
        return false
    }
}

//Function to verify if the moviment is diagonal3
func isDiagonal3Move(fromX:Int, fromY:Int, toX:Int, toY:Int) -> Bool{
    //If the piece went left and down, is diagonal 3
    if isLeft(fromX: fromX, toX: toX) && isDown(fromY: fromY, toY: toY){
        return true
    }
        //Isnt diagonal3
    else{
        return false
    }
}

//Function to verify if the moviment is diagonal4
func isDiagonal4Move(fromX:Int, fromY:Int, toX:Int, toY:Int) -> Bool{
    //If the piece went right and down, is diagonal 4
    if isRight(fromX: fromX, toX: toX) && isDown(fromY: fromY, toY: toY){
        return true
    }
        //Isnt diagonal4
    else{
        return false
    }
}

//Function to verify if the moviment is a castling
func isCastling(fromX:Int, fromY:Int, toX:Int, toY:Int) -> Bool{

    //If there is a king in the origin
    if let originPiece = game.chessBoard[fromY][fromX] as? King {
        //If there is a rook in the destiny
        if let destinyPiece = game.chessBoard[toY][toX] as? Rook {
            //If they are the same color
            if originPiece.color == destinyPiece.color{
                return true
            }
            //They arent
            else{
                return false
            }
        }
        //Isnt a rook
        else{
            return false
        }
    } 
    //Isnt a king
    else {
        return false
    }
}

//Function to verify if the moviment is to the right
func isRight(fromX:Int, toX:Int) -> Bool{
    if toX > fromX{
        return true
    }
    else{
        return false
    }
}

//Function to verify if the moviment is to the left
func isLeft(fromX:Int, toX:Int) -> Bool{
    if toX < fromX{
        return true
    }
    else{
        return false
    }
}

//Function to verify if the moviment is up
func isUp(fromY:Int, toY:Int) -> Bool{
    if toY < fromY{
        return true
    }
    else{
        return false
    }
}

//Function to verify if the moviment is down
func isDown(fromY:Int, toY:Int) -> Bool{
    if toY > fromY{
        return true
    }
    else{
        return false
    }
}

//Function to verify if its the pawn first move
func isPawnFirstMove(fromY:Int, toY:Int) -> Bool{
    var valid:Bool = false
    //Verify if is in inicial position
    switch game.turn{
        case .white:
            if (fromY == 6 && toY == 4){
                valid = true
            }
            //Isnt in inicial position, cant move
            else{
                valid = false
            }
        case .black:
            if (fromY == 1 && toY == 3){
                valid = true
            }
            //Isnt in inicial position, cant move
            else{
                valid = false
            }
    }
    return valid
}

//Function to verify if the pawn move match with the pawn color
func isPawnMoveAllowedByColor(fromY:Int, toY:Int) -> Bool{

    var valid:Bool = false

    //Verify if is white and move up
    if (game.turn == .white && isUp(fromY: fromY, toY: toY)) {
        valid = true
    }
    //Verify if is black and move down
    else if (game.turn == .black && isDown(fromY: fromY, toY: toY)){
        valid = true
    }
    //Invalid move
    else{
        valid = false
    }

    return valid
}

//Function to verify if the pawn move is valid
func isPawnMoveValid(pieceColor:Color, moveType: TypeOfMove, toX:Int, toY:Int) -> Bool{

    var valid:Bool = false

    //Verify if is a vertical move, only valid if destiny is empty
    if moveType == .vertical && isDestinyEmpty(toX:toX, toY:toY){
        valid = true
    }
    //If its a diagonal move, allowed only if it has an enemy piece
    else{
        switch moveType{
        case .diagonal1, .diagonal2, .diagonal3, .diagonal4 :
            //If its empty, cant move
            if isDestinyEmpty(toX:toX, toY:toY){
                valid = false
            }
            //Isnt empty
            else{
                //Verify if is an enemy
                if isPieceEnemy(pieceColor:pieceColor, toX:toX, toY:toY){
                    valid = true
                }
                //Isnt enemy, cant move
                else{
                    valid = false
                }
            }
        default:
            valid = false
        }
    }

    return valid
}

//Function to verify if the castling move is valid
func isCastlingValid(fromX:Int, fromY:Int, toX:Int, toY:Int) -> Bool{
    //If its a king selected
    if let king = game.chessBoard[fromY][fromX] as? King {
        //If its a rook selected
        if let rook = game.chessBoard[toY][toX] as? Rook {
            //If its the king first move
            if king.moved == false{
                //If its the left rook first move
                if toX == 0 && rook.leftMoved == false{
                    return true
                }
                //If its the right rook first move
                else if toX == 7 && rook.rightMoved == false{
                    return true
                }
                //Isnt the first move, cant castling
                else{
                    return false
                }
            }
            //Isnt
            else{
                return false
            }
        }
        //Isnt a rook
        else{
            return false
        }
    }
    //Isnt a king
    else{
        return false
    }
}

//Function to verify if the destiny is empty
func isDestinyEmpty(toX:Int, toY:Int) -> Bool{
    if game.chessBoard[toY][toX] == nil{
        return true
    }
    //Isnt empty
    else{
        return false
    }
}

//Function to verify if the piece in the destiny is an enemy
func isPieceEnemy(pieceColor:Color, toX:Int, toY:Int) -> Bool{
    //If their colors are diferent, they are enemys
    if pieceColor != game.chessBoard[toY][toX]?.color{
        return true
    }
        //Isnt empty
    else{
        return false
    }
}

//Function to move the piece to the destination
func movePiece(moveType: TypeOfMove, fromX:Int, fromY:Int, toX:Int, toY:Int){

    //Update the moved status if it was a rook
    if let piece = game.chessBoard[fromY][fromX] as? Rook{
        //If it was the right rook that moved
        if fromX == 7{
            piece.rightMoved = true
        }
        //If it was the left rook that moved
        else if fromX == 0{
             piece.leftMoved = true
        }
        else{
        }
    } 
    //It wasnt a rook that moved
    else {
    }

    //Update the moved status if it was a king
    if let piece = game.chessBoard[fromY][fromX] as? King{
        piece.moved = true
    } 
    //It wasnt a king that moved
    else {
    }

    //If the move is castling type
    if moveType == .castling{
        //Verify if is castling right
        if isRight(fromX: fromX, toX: toX){
            //Move the king two squares right
            game.chessBoard[fromY][fromX+2] = game.chessBoard[fromY][fromX]
            //Move the rook to the left square of the king
            game.chessBoard[fromY][fromX+1] = game.chessBoard[toY][toX]
            //Clean the original king position
            game.chessBoard[fromY][fromX] = nil
            //Clean the original rook position
            game.chessBoard[toY][toX] = nil
        }
        //Its castling left
        else{
            //Move the king two squares left
            game.chessBoard[fromY][fromX-2] = game.chessBoard[fromY][fromX]
            //Move the rook to the right square of the king
            game.chessBoard[fromY][fromX-1] = game.chessBoard[toY][toX]
            //Clean the original king position
            game.chessBoard[fromY][fromX] = nil
            //Clean the original rook position
            game.chessBoard[toY][toX] = nil
        }
    }
    //Other moves, just change the pieces
    else{
        //Move the selected piece from the origin to the destiny
        game.chessBoard[toY][toX] = game.chessBoard[fromY][fromX]
        //Clean the original position
        game.chessBoard[fromY][fromX] = nil
    }

    //Update the chessboard print
    game.printBoard()
}

//Function to verify if there are pieces between the origin and the destiny
func isPathFree(moveType:TypeOfMove, fromX:Int, fromY:Int, toX:Int, toY:Int) -> Bool{

    var valid:Bool = true
    let squares:Int

    switch moveType{
        case .horizontal, .castling:
            squares = abs(fromX - toX)
        case .vertical, .diagonal1, .diagonal2, .diagonal3, .diagonal4:
            squares = abs(fromY - toY)
        default:
            squares = 2
    }

    //If its only one square to move, the path is already free
    if squares == 1{
        valid = true
    }
    //If its more than one, verify if the path is free
    else if squares > 1{
        for i in 1...(squares-1){
            if valid == false{
                break
            }
            else if (moveType == .horizontal || moveType == .castling){ 
                if isRight(fromX: fromX, toX: toX){
                    if game.chessBoard[fromY][fromX+i] != nil{
                        valid = false
                    }
                }
                if isLeft(fromX: fromX, toX: toX){
                    if game.chessBoard[fromY][fromX-i] != nil{
                        valid = false
                    }
                }
            }
            else if moveType == .vertical{ 
                if isUp(fromY: fromY, toY: toY){
                    if game.chessBoard[fromY-i][fromX] != nil{
                        valid = false
                    }
                }
                if isDown(fromY: fromY, toY: toY){
                    if game.chessBoard[fromY+i][fromX] != nil{
                        valid = false
                    }
                }
            }
            else if moveType == .diagonal1{ 
                if game.chessBoard[fromY-i][fromX+i] != nil{
                    valid = false
                }
            }
            else if moveType == .diagonal2{ 
                if game.chessBoard[fromY-i][fromX-i] != nil{
                    valid = false
                }
            }
            else if moveType == .diagonal3{ 
                if game.chessBoard[fromY+i][fromX-i] != nil{
                    valid = false
                }
            }
            else if moveType == .diagonal4{
                if game.chessBoard[fromY+i][fromX+i] != nil{
                    valid = false
                }
            }
        }
    }
    return valid
}

//Function that unit all the other functions that verify if move is possible
func isMovePossible(piece:Piece, moveResult:(valid:Bool, type: TypeOfMove), coordinates:(fromX:Int, fromY:Int, toX:Int, toY:Int)) -> Bool{
    
    var valid:Bool = false

    //If the moviment is valid
    if moveResult.valid{
        //Verify if there are pieces on the way
        if isPathFree(moveType: moveResult.type, fromX:coordinates.fromX, fromY:coordinates.fromY, toX:coordinates.toX, toY:coordinates.toY){
           
            //Verify if the destiny is empty
            if isDestinyEmpty(toX: coordinates.toX, toY: coordinates.toY){
                //Move, just changing position
                movePiece(moveType: moveResult.type, fromX: coordinates.fromX, fromY: coordinates.fromY, toX: coordinates.toX, toY: coordinates.toY)
                valid = true
            }
            //Isnt empty
            else{
                //Verify if the piece is an enemy
                if isPieceEnemy(pieceColor: piece.color, toX: coordinates.toX, toY: coordinates.toY){
                    //Move, capturing the enemy piece
                    movePiece(moveType: moveResult.type, fromX: coordinates.fromX, fromY: coordinates.fromY, toX: coordinates.toX, toY: coordinates.toY)
                    valid = true
                }
                //Its an ally piece
                else{
                    //If the move is a castling
                    if moveResult.type == .castling{
                        movePiece(moveType: moveResult.type, fromX: coordinates.fromX, fromY: coordinates.fromY, toX: coordinates.toX, toY: coordinates.toY)
                        valid = true
                    }
                    //Isnt a castling, cant move
                    else{
                        valid = false
                    }
                }
            }
        }
        //Path isnt free, cant move
        else{
            valid = false
        }
    }
    return valid
}

// ----------------------------------------------------------------------------------------------------------------
// TESTS
// ----------------------------------------------------------------------------------------------------------------

//Start a new game
var game = Chess()
game.printBoard()

game.turn = .black

game.move(from: (x:1,y:7), to: (x:1,y:5))

// return color == .black ? "b" : "w"

//Arquitetura de solucoes
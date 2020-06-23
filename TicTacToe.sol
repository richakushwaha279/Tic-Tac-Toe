pragma solidity ^0.4.7;
contract TicTacToe {

    uint[][3] board;
    mapping(address => uint) participantNumber;
    mapping(uint => address) playerTrack;
    mapping(address => bool) playerTurn;
    uint participantRegistered;
    bool flag;
    bool gameOver;
    bool draw;
    address organizer;
    uint numberOfMovesPlayed;
   
    struct Player
    {
        address playerId;
        bool winner;
    }
    event printInt(uint);
    
    Player[] participants;
    
    constructor() public
    {
        for(uint i=0; i<3; i++)
        {
            for(uint j=0; j<3; j++)
                board[i].push(0);
        }
        
        participantRegistered = 0;
        flag = true;
        draw = false;
        organizer = msg.sender;
    }
    modifier notOrganizer()
    {
        require(!(msg.sender == organizer), "Organizer cannot play");
        _;
    }
    modifier onlyTwoPlayer()
    {
        require(participantRegistered <= 1 , "There can only be two players");
        _;
    }
    
    modifier indexInRange(uint x1, uint y1)
    {
        require(x1>=0 && x1<=2 && y1>=0 && y1<=2, "Range for board location should be between 0 and 2");
        _;
    }
    modifier cannotPlayAgain()
    {
        require(flag == playerTurn[msg.sender], "You already played your move");
        _;
    }
    modifier notAlreadyRegistered()
    {
        require ( !(participantNumber[msg.sender] > 0) , "You are already registered in the game.");
        _;
    }
    modifier gameOverMod()
    {
        require(gameOver == false && draw == false," Game over! ");
        _;
    } 
    modifier registered()
    {
        require(!(participantNumber[msg.sender] == 0), " You are not registered for this game! ");
        _;
    }
    modifier exactlyTwoPlayer(){
        require (participantRegistered == 2 , "Exactly two players can participate! ");
        _;
    }
    modifier notAlreadyMarked(uint _x, uint _y)
    {
        require(!(board[_x][_y] > 0),"You cannot play here!");
        _;
    }

    
    function registerPlayers()
    notOrganizer()
    notAlreadyRegistered()
    onlyTwoPlayer()
    {
        participantRegistered += 1;
        participantNumber[msg.sender] = participantRegistered;
        Player newPlayer;
        newPlayer.playerId = msg.sender;
        newPlayer.winner = false;
        
        participants.push(newPlayer);
        if(participantRegistered == 1)
        {
            playerTurn[msg.sender] = true;
        }
        else
        {
             playerTurn[msg.sender] = false;   
        }
    }
    
    function setMove(uint x, uint y)
    registered()
    // notAlreadyMarked(x, y)
    gameOverMod()
    exactlyTwoPlayer()
    indexInRange(x, y)
    cannotPlayAgain()
    {
        emit printInt(board[x][y]);
        uint temp = participantNumber[msg.sender];
        board[x][y] = temp;
        
        flag = !flag;
        numberOfMovesPlayed += numberOfMovesPlayed + 1;
        
        if(evaluateDiagonal(temp) || checkRows(temp) || checkColumn(temp))
        {
            gameOver = true;
            participants[temp-1].winner = true;
        }
        
        if( numberOfMovesPlayed == 9 && gameOver== false)
        {
            draw = true;
        }
    }
    
    function evaluateDiagonal(uint number) returns(bool)
    {
        if(number == board[0][0] && board[0][0]==board[1][1] && board[2][2]==board[1][1])
        {
            return true;
        }
        if(number == board[0][2] && board[0][2]==board[1][1] && board[2][0]==board[1][1])
        {
            return true;
        }
        return false;
    }
    
    function checkRows(uint number) returns(bool)
    {
        if(number == board[0][0] && board[0][0]==board[0][1] && board[0][2]==board[0][1])
        {
            return true;
        }
        if(number == board[1][0] && board[1][0]==board[1][1] && board[1][0]==board[1][2])
        {
            return true;
        }
        if(number == board[2][0] && board[2][0]==board[2][1] && board[2][2]==board[2][1])
        {
            return true;
        }
        return false;
    }
    
    function checkColumn(uint number) returns(bool)
    {
        if(number == board[0][0] && board[0][0]==board[1][0] && board[1][0]==board[2][0])
        {
            return true;
        }
        if(number == board[0][1] && board[0][1]==board[1][1] && board[1][1]==board[2][1])
        {
            return true;
        }
        if(number == board[0][2] && board[0][2]==board[1][2] && board[1][2]==board[2][2])
        {
            return true;
        }
        return false;
    }
    
    function getWinner() view returns(string)
    {
        if(draw == true)
        {
            return "Draw";
        }
        else
        {
            bool val = participants[0].winner;
            if(val==true)
            {
                return "Player1";
            }
            return "Player2";
        }
    }
}


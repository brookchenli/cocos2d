/**************************************************************************************
在本次"五子棋"程序的编写中（参考了《Visual C++游戏设计》），只编写了人机对弈部分，
运用了博弈树进行搜索，在选取最优的走步时使用极大极小分析法，
考虑到搜索的时间复杂度和空间复杂度，在程序中只进行了2步搜索，
即计算机在考虑下一步的走法时，只对玩家进行一步的推测。（程序中的棋盘规格为15*15）
估价函数的选取方法：
e=p1+p2;
p1为下完当前这步棋时计算机的得分；p2为下完当前这步棋时玩家的得分（p2其实为负），
这样做即考虑了进攻的因数，由考虑了防守的因数，两个方面都进行了考虑，
防止计算机只考虑进攻而忽略防守，同时也防止计算机只考虑防守而忽略进攻，达到比较好的情况。
如果您有更好的方法，
***************************************************************************************/

#ifndef  CHESSITEM_H
#define CHESSITEM_H

#include <string>
#include <stdint.h>
#include <stdlib.h>
#define BOARD_W  11
#define BOARD_H  11
#define WIN_COM  (BOARD_W*(BOARD_H-4)*2+(BOARD_H-4)*(BOARD_H-4)*2)

typedef int   BOOL;
typedef long LONG;

typedef struct tagSIZE
{
    LONG        cx;
    LONG        cy;
} SIZE, *PSIZE, *LPSIZE;
/////////////////////////////////////////////////////////////////////////////
typedef struct _BOARD_STRUCT{
	char *ctable;  //[15][15][572];
	int *win   ; //[2][572];
	char *ptable ;  //[15][15][572];
	char *board; //[15][15];

}BOARD_STRUCT;

typedef struct _CHESS_DATA{
	int score;
	int x;
	int y;
}CHESS_DATA;

typedef struct _RETURN_CHESS{
    CHESS_DATA chess[6];
    int type;
    int n;
}RETURN_CHESS;


namespace cocos2d {
class   MyChessClass
{
protected:
	
	BOOL start;
	int player_n; //玩家走的步数
	int computer_n; //计算机走的步数
	BOARD_STRUCT board_struct;
	int board_w;
	int board_h;
	int win[2][WIN_COM];
	char ptable[BOARD_W][BOARD_H][WIN_COM];
	char ctable[BOARD_W][BOARD_H][WIN_COM];
	char board[BOARD_W][BOARD_H];
	SIZE old_chess_c;
	SIZE old_chess_p;
  RETURN_CHESS tmp_return;

public:
	MyChessClass();	
       ~MyChessClass();
       // 返回 ：0 人嬴， 1计算机嬴， -1：继续 -2：和棋
       int  poschess(int type, int x,int y) ;
       // type =0 ，人先下， type =1 计算机下
       int  OnGameStart(int type) ;
       // 返回字符json格式字符串，
      //例如：{"type":1, 
      //       "count":6,
      //       "chess":[{"score":100 , "x":4, "y":5},
      //                 {"score":80 , "x":4, "y":6},
      //                 {"score":90 , "x":5, "y":5},
      //                 {"score":200 , "x":3, "y":5},
      //                 {"score":20 , "x":4, "y":4},
      //                 {"score":30 , "x":2, "y":5}]}

	     std::string get_chess_return();
	

// Implementation
protected:
      void GetBoard(char tempboard[][BOARD_H], char nowboard[][BOARD_H]);
       BOOL SearchBlank(int &i, int &j, char nowboard[][BOARD_H]);
      int GiveScore(int type, int x, int y);
     RETURN_CHESS  ComTurn(int type);
	void InitializeBoard();

     int  IsWin();
};
} //namespace cocos2d

#endif

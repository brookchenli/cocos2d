/**************************************************************************************
�ڱ���"������"����ı�д�У��ο��ˡ�Visual C++��Ϸ��ơ�����ֻ��д���˻����Ĳ��֣�
�����˲�����������������ѡȡ���ŵ��߲�ʱʹ�ü���С��������
���ǵ�������ʱ�临�ӶȺͿռ临�Ӷȣ��ڳ�����ֻ������2��������
��������ڿ�����һ�����߷�ʱ��ֻ����ҽ���һ�����Ʋ⡣�������е����̹��Ϊ15*15��
���ۺ�����ѡȡ������
e=p1+p2;
p1Ϊ���굱ǰ�ⲽ��ʱ������ĵ÷֣�p2Ϊ���굱ǰ�ⲽ��ʱ��ҵĵ÷֣�p2��ʵΪ������
�������������˽������������ɿ����˷��ص��������������涼�����˿��ǣ�
��ֹ�����ֻ���ǽ��������Է��أ�ͬʱҲ��ֹ�����ֻ���Ƿ��ض����Խ������ﵽ�ȽϺõ������
������и��õķ�����
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
	int player_n; //����ߵĲ���
	int computer_n; //������ߵĲ���
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
       // ���� ��0 ������ 1��������� -1������ -2������
       int  poschess(int type, int x,int y) ;
       // type =0 �������£� type =1 �������
       int  OnGameStart(int type) ;
       // �����ַ�json��ʽ�ַ�����
      //���磺{"type":1, 
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

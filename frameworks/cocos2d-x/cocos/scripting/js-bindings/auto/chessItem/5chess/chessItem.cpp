

#include "chessItem.h"

cocos2d::MyChessClass::MyChessClass()
	 
{
     board_w = BOARD_W;
	 board_h = BOARD_H;
	InitializeBoard();

}

cocos2d::MyChessClass::~MyChessClass()
{

}

/////////////////////////////////////////////////////////////////////////////

std::string cocos2d::MyChessClass::get_chess_return()
{
	using namespace std;
	int i=0;
    char buf[2048];
    char tmp_buf[256];
//	ostringstream buf;
    sprintf( buf , "{\"type\":%d ,\"count\":%d,\"chess\":[", tmp_return.type, tmp_return.n);

//		buf<<"{\"type\":"<< tmp_return.type << ",\"count\":" << tmp_return.n <<",\"chess\":[";
		for (i=0; i<6; i++)
		{
            sprintf(tmp_buf, "{\"score\":%d,\"x\":%d,\"y\":%d}",tmp_return.chess[i].score,tmp_return.chess[i].x, tmp_return.chess[i].y);
                 strncat(buf,tmp_buf,2048);
    //        buf << "{\"score\":" << tmp_return.chess[i].score << ",\"x\":" << tmp_return.chess[i].x << ",\"y\":" << tmp_return.chess[i].y << "}";
			if (i < 5)
                strncat(buf,",",2048);
			//	buf <<","
			else
                strncat(buf,"]}",2048);
			//	buf << "]}"
		}
	return buf;
}

int  cocos2d::MyChessClass::poschess(int type, int x,int y) 
{
	if(board[x][y]==2)
	{
          if (type)
          {
		board[x][y]=0;//设为玩家的棋子
		for(int i=0;i<WIN_COM;i++)
		{//修改玩家下子后棋盘状态的变化
			if(ctable[x][y][i]&&win[1][i]!=7)
				win[1][i]++;
			if(ptable[x][y][i])
			{
				ptable[x][y][i]=false;
				win[0][i]=7;
			}
		}
		computer_n++;
	old_chess_c.cx = x;
	old_chess_c.cy = y;
	if ((old_chess_p.cx ==-1)||(old_chess_p.cy ==-1))
		{
				old_chess_p.cx = x;
				old_chess_p.cy = y;
			
		}

          }
	   else
	   {
		board[x][y]=1;
		for(int i=0;i<WIN_COM;i++)
		{//修改计算机下子后，棋盘的变化状况
			if(ptable[x][y][i]&&win[0][i]!=7)
				win[0][i]++;
			if(ctable[x][y][i])
			{
				ctable[x][y][i]=false;
				win[1][i]=7;
			}
		}
 	player_n++;
      old_chess_p.cx = x;
	old_chess_p.cy =y;
	if ((old_chess_c.cx ==-1)||(old_chess_c.cy ==-1))
		{
				old_chess_c.cx = x;
				old_chess_c.cy = y;
			
		}
	   }
	   int tmp = IsWin();
	   if (tmp >=0)
	   	{
                tmp_return.n = 0;
		  tmp_return.type = type;
		  return tmp;
	   	}
	   tmp_return= ComTurn((~type)&0x01);
	   return tmp;
	}
	 tmp_return.type = type;
        tmp_return.n = 0;
	
	return -2;
}


void cocos2d::MyChessClass::GetBoard(char tempboard[][BOARD_H], char nowboard[][BOARD_H])
{
	int j;
		for(j=0;j<BOARD_W;j++)
		{
			memcpy((char*)tempboard[j],(char*)nowboard[j],BOARD_H);
		}
}

BOOL cocos2d::MyChessClass::SearchBlank(int &i, int &j, char nowboard[][BOARD_H])
{
	int x,y;
	for(x=0;x<BOARD_W;x++)
		for(y=0;y<BOARD_H;y++)
		{
			if(nowboard[x][y]==2)
			{
				i=x;
				j=y;
				return true;
			}
		}
    return false;
}

int cocos2d::MyChessClass::GiveScore(int type, int x, int y)
{
		int i,score=0;
		int s_3 = 0;
		int h_4 =0;
	for(i=0;i<WIN_COM;i++)
	{
		//计算机下
		if(type)
		{
			if(ctable[x][y][i])
			{
				switch(win[1][i])
				{
				case 1:
					score+=5;
					break;
				case 2:
					score+=50;
					s_3 ++;
					break;
				case 3:
					score+=500;
					h_4++;
					break;
				case 4:
					score+=500000;
					break;
                default:
					break;
				}
			}
		}
		//人下
		else
		{
			if(ptable[x][y][i])
			{
				switch(win[0][i])
				{
				case 1:
					score-=5;
					break;
			    case 2:
				    score-=50;
					  s_3 ++;
				    break;
			    case 3:
				    score-=500;
						h_4++;
				    break;
			    case 4:
			    score-=500000;
					break;
			    default:
				break;
			}
			}
		}
	}
	if (h_4 > 1)
		score = (type>0) ? score+20000: score-20000;
	else
		if (s_3 >4)
			score = (type>0) ? score+10000: score-10000;
	return score;
}

RETURN_CHESS cocos2d::MyChessClass::ComTurn(int type)
{
		//bestx,best为当前最佳位置，i，j是人能下的各种位置；pi，pj是计算机能下的各种位置
	int  i,j,i_x,i_y,pi,pj,ptemp,ctemp,pscore=10,cscore=-10000;
       char ctempboard[BOARD_W][BOARD_H],ptempboard[BOARD_W][BOARD_H];
	int m,n,temp1[20],temp2[20];//暂存第一步搜索的信息
	int tmp_n=0;
	//RETURN_CHESS tmp_return;
	CHESS_DATA tmp_chess;
	if(start)
	{
		srand((unsigned) time(NULL));
        tmp_return.chess[0].x= rand()%6 + (BOARD_W-6)/2;
		tmp_return.chess[0].y= rand()%6 + (BOARD_H-6)/2;
		tmp_return.chess[0].score = 0;
		tmp_n++;
		start=false;
	}
	else
	{//寻找最佳位置
	if (type )  //计算机走
	{
		GetBoard(ctempboard,board);
	  for(i=0;i<BOARD_W;i++)
		for(j=0;j<BOARD_H;j++)
		{
		   if(ctempboard[i][j]==2)
		  {
			n=0;
			pscore=10;
			GetBoard(ptempboard,board);
			ctemp=GiveScore(1,i,j);
			for(m=0;m<WIN_COM;m++)
			{//暂时更改玩家信息
				if(ptable[i][j][m])
				{
					temp1[n]=m;
					ptable[i][j][m]=false;
					temp2[n]=win[0][m];
					win[0][m]=7;
					n++;
				}
			}
			ptempboard[i][j]=1;
			
			pi=i;
			pj=j;
	             for(i_x=0;i_x<BOARD_W;i_x++)
		        for(i_y=0;i_y<BOARD_H;i_y++)
		       {
				 if(ptempboard[i_x][i_y]==2)
				{
					ptemp=GiveScore(0,i_x,i_y);
					if(pscore>ptemp)////此时为玩家下子，运用极小极大法时应选取最小值
						pscore=ptemp;
				}
		        }
			for(m=0;m<n;m++)
			{//恢复玩家信息
				ptable[pi][pj][temp1[m]]=true;
				win[0][temp1[m]]=temp2[m];
			}
	           tmp_return.chess[tmp_n].score = ctemp+pscore;
			   tmp_return.chess[tmp_n].x =pi;
			   tmp_return.chess[tmp_n].y =pj;
			   
	                 for (int ii = tmp_n; ii>0;ii--)
	                 {
	                    for (int jj = ii-1; jj >=0 ; jj--)
	                    	{
	                    	   if ((tmp_return.chess[ii].score >tmp_return.chess[jj].score) ||
					((tmp_return.chess[ii].score == tmp_return.chess[jj].score)&&
					( (abs(tmp_return.chess[jj].x-old_chess_p.cx)+abs(tmp_return.chess[jj].y-old_chess_p.cy) )
					>(abs(tmp_return.chess[ii].x-old_chess_p.cx)+abs(tmp_return.chess[ii].y-old_chess_p.cy) ))))		   	
	                    	   {
				      tmp_chess =tmp_return.chess[jj];
				      tmp_return.chess[jj] =	tmp_return.chess[ii];
				      tmp_return.chess[ii] = tmp_chess;
	                    	   }
	                    	}
	                 }
					   
	             if (tmp_n <5)
	              {
	                 tmp_n++;
	              }
		}
		}
		 if ((tmp_n>=3)&&(player_n ==1)&&(computer_n ==0))
		 	{
		     int tmp_i;
		     CHESS_DATA tmp_ii;
		         srand((unsigned) time(NULL));
            tmp_i= rand()%3 ;
            tmp_ii = tmp_return.chess[0];
            tmp_return.chess[0]=  tmp_return.chess[tmp_i];
            tmp_return.chess[tmp_i] = tmp_ii;
		 	}
	}
	else
	{
		GetBoard(ptempboard,board);
	  for(i=0;i<BOARD_W;i++)
		for(j=0;j<BOARD_H;j++)
		{
		   if(ptempboard[i][j]==2)
		  {
			n=0;
			cscore=-10000;
			GetBoard(ctempboard,board);
			ptemp=GiveScore(0,i,j);
			for(m=0;m<WIN_COM;m++)
			{//暂时更改玩家信息
				if(ctable[i][j][m])
				{
					temp1[n]=m;
					ctable[i][j][m]=false;
					temp2[n]=win[1][m];
					win[1][m]=7;
					n++;
				}
			}
			ctempboard[i][j]=1;
			
			pi=i;
			pj=j;

	             for(i_x=0;i_x<BOARD_W;i_x++)
		        for(i_y=0;i_y<BOARD_H;i_y++)
		       {
				 if(ctempboard[i_x][i_y]==2)
				{
					ctemp=GiveScore(1,i_x,i_y);
					if(cscore<ctemp)////此时为玩家下子，运用极小极大法时应选取最小值
						cscore=ctemp;
				}
		        }

			for(m=0;m<n;m++)
			{//恢复玩家信息
				ctable[pi][pj][temp1[m]]=true;
				win[1][temp1[m]]=temp2[m];
			}
	                  tmp_return.chess[tmp_n].score = ptemp+cscore;
			   tmp_return.chess[tmp_n].x =pi;
			   tmp_return.chess[tmp_n].y =pj;
	                 for (int ii = tmp_n; ii>0;ii--)
	                 {
	                    for (int jj = ii-1; jj >=0 ; jj--)
	                    	{
	                    	   if ((tmp_return.chess[ii].score <tmp_return.chess[jj].score) ||
					((tmp_return.chess[ii].score == tmp_return.chess[jj].score)&&
					( (abs(tmp_return.chess[jj].x-old_chess_c.cx)+abs(tmp_return.chess[jj].y-old_chess_c.cy) )
					>(abs(tmp_return.chess[ii].x-old_chess_c.cx)+abs(tmp_return.chess[ii].y-old_chess_c.cy) ))))		   	
	                    	   {
				      tmp_chess =tmp_return.chess[jj];
				      tmp_return.chess[jj] =	tmp_return.chess[ii];
				      tmp_return.chess[ii] = tmp_chess;
	                    	   }
	                    	}
	                 }
	             if (tmp_n <5)
	              {
	                 tmp_n++;
	              }
		}
	   }
			 if ((tmp_n>=3)&&(player_n ==0)&&(computer_n ==1))
		 	{
		     int tmp_i;
		     CHESS_DATA tmp_ii;
		         srand((unsigned) time(NULL));
            tmp_i= rand()%3 ;
            tmp_ii = tmp_return.chess[0];
            tmp_return.chess[0]=  tmp_return.chess[tmp_i];
            tmp_return.chess[tmp_i] = tmp_ii;
		 	}
   
	}
	}
   tmp_return.n =tmp_n;
   tmp_return.type = type;
   
   return tmp_return;
	
}




int cocos2d::MyChessClass::OnGameStart(int type) 
{
	// TODO: Add your command handler code here
	InitializeBoard();
       tmp_return = ComTurn(type);
  return -1;
}

int cocos2d::MyChessClass::IsWin()
{
	int i;
	if ( (player_n+computer_n)==BOARD_W*BOARD_H)
		return 2;
	for(i=0;i<WIN_COM;i++)
	{
		if(win[0][i]==5)
		{
			return 0;
		}
		if(win[1][i]==5)
		{
			return 1;
		}
	}
	return -1;
}

void cocos2d::MyChessClass::InitializeBoard()
{
	//初始化函数
	int i,j,count=0,k;
	player_n=0; //玩家走的步数
	computer_n=0; //计算机走的步数

	start=true;
       old_chess_c.cx = -1;
	old_chess_c.cy =-1;
	old_chess_p.cx = -1;
	old_chess_p.cy = -1;
	memset((void*)&tmp_return, 0 , sizeof(RETURN_CHESS));
	//判断哪方先开始
	//初始化计算机和玩家的获胜组合情况
	for(i=0;i<BOARD_W;i++)
		for(j=0;j<BOARD_H;j++)
			for(k=0;k<WIN_COM;k++)
			{
				ptable[i][j][k]=false;
				ctable[i][j][k]=false;
			}
	for(i=0;i<2;i++)
		for(j=0;j<WIN_COM;j++)
			win[i][j]=0;
	for(i=0;i<BOARD_W;i++)
		for(j=0;j<BOARD_H;j++)
			board[i][j]=2;
    for(i=0;i<BOARD_H;i++)
		for(j=0;j<(BOARD_W-4);j++)
		{
			for(k=0;k<5;k++)
			{
				ptable[j+k][i][count]=true;
				ctable[j+k][i][count]=true;
			}
			count++;
		}
	for(i=0;i<BOARD_W;i++)
		for(j=0;j<(BOARD_H-4);j++)
		{
			for(k=0;k<5;k++)
			{
				ptable[i][j+k][count]=true;
				ctable[i][j+k][count]=true;
			}
			count++;
		}
	for(i=0;i<(BOARD_H-4);i++)
		for(j=0;j<(BOARD_W-4);j++)
		{
			for(k=0;k<5;k++)
			{
				ptable[j+k][i+k][count]=true;
				ctable[j+k][i+k][count]=true;
			}
			count++;
		}
	for(i=0;i<(BOARD_H-4);i++)
		for(j=(BOARD_W-1);j>=4;j--)
		{
			for(k=0;k<5;k++)
			{
				ptable[j-k][i+k][count]=true;
				ctable[j-k][i+k][count]=true;
			}
			count++;
		}
}



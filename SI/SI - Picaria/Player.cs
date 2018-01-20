using SbsSW.SwiPlCs;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SIPicaria
{
    public class Player
    {

        int[] MoveTable = new int[2];
        bool secondMove = false;
        public bool doMove = false;
        public bool playerWin = false;
        // lista pionów gracza
        public List<int> listOfPawns = new List<int>();

        // funkcja dzieki ktorej stawiamy pionek
        public bool spacingPawns(int index, List<int> listOfPawnsOpponent, List<OvalShapeExtended> listOfOvalShapes, Image textureOfPawn)
        {

            #region Konwersje list pionow do stringow
            String listPawns = convertListToString(listOfPawns);
            String listOpponentPawns = convertListToString(listOfPawnsOpponent);


            #endregion

            PlTermV para = new PlTermV(4);
            para[0] = new PlTerm(index);
            para[1] = new PlTerm(listPawns);
            para[3] = new PlTerm(listOpponentPawns);


            PlQuery q = new PlQuery("dodaj_pion", para);
            q.NextSolution();



            if (para[1] == para[2])
            {
                return false;

            }
            else
            {

                var list = para[2].ToString().Replace("[", "").Replace("]", "").Split(',');
                listOfPawns.Clear();
                foreach (var x in list)
                {
                    listOfPawns.Add(Convert.ToInt32(x));
                }

                foreach (var x in list)
                {
                    listOfOvalShapes[Convert.ToInt32(x)].BackgroundImage = textureOfPawn;
                }




                bool win;
                q = new PlQuery(string.Format("wygrywajace({0})", para[2]));
                win = q.NextSolution();

                if (win)
                {
                    playerWin = true;
                }

                return true;

            }

        }
        public void MovePawn(int index, List<int> listOfPawnsOpponent, List<OvalShapeExtended> listOfOvalShapes, Image textureOfPawn)
        {
            PlQuery q;
            PlQuery winQuery;
            bool x;

            if (!secondMove)
            {
                doMove = false;
                bool goodVertex = false;
                for (int i = 0; i < listOfPawns.Count; i++)
                {

                    if (index == listOfPawns[i])
                    {
                        goodVertex = true;
                        break;
                    }

                }
                if (goodVertex)
                {

                    MoveTable[0] = index;
                    secondMove = true;
                    listOfOvalShapes[index].BorderColor = Color.Red;
                }

            }
            else
            {
                if (MoveTable[0] == index)
                {
                    listOfOvalShapes[index].BorderColor = Color.Black;
                    secondMove = false;
                }
                else
                {
                    String listPawns = "";
                    String listOpponentPawns = "";
                    for (int i = 0; i < listOfPawns.Count; i++)
                    {
                        if (i == 0)
                        {
                            listPawns = "[" + listOfPawns[i].ToString() + ",";
                            listOpponentPawns = "[" + listOfPawnsOpponent[i].ToString() + ",";
                        }
                        else if (i == listOfPawns.Count - 1)
                        {
                            listPawns += listOfPawns[i].ToString() + "]";
                            listOpponentPawns += listOfPawnsOpponent[i].ToString() + "]";
                        }
                        else
                        {
                            listPawns += listOfPawns[i].ToString() + ",";
                            listOpponentPawns += listOfPawnsOpponent[i].ToString() + ",";
                        }
                    }

                    MoveTable[1] = index;
                    PlTermV par = new PlTermV(5);

                    par[0] = new PlTerm(listPawns);
                    par[2] = new PlTerm(MoveTable[0]);
                    par[3] = new PlTerm(MoveTable[1]);
                    par[4] = new PlTerm(listOpponentPawns);


                    q = new PlQuery("przesun", par);
                    x = q.NextSolution();
                    // q.Dispose();

                    if (par[0].ToString() != par[1].ToString())
                    {

                        // wykonanie ruchu - narysowanie przemieszenia pionkow
                        listOfOvalShapes[MoveTable[0]].BackgroundImage = Properties.Resources.BlackCircle;
                        listOfOvalShapes[MoveTable[1]].BackgroundImage = textureOfPawn;
                        secondMove = false;
                        listOfOvalShapes[MoveTable[0]].BorderColor = Color.Black;
                        // zamiana pionkow na liscie
                        for (int i = 0; i < listOfPawns.Count; i++)
                        {
                            if (listOfPawns[i] == MoveTable[0])
                            {
                                listOfPawns[i] = MoveTable[1];
                            }
                        }
                        bool win;
                        winQuery = new PlQuery(string.Format("wygrywajace({0})", par[1]));
                        win = winQuery.NextSolution();
                        // winQuery.Dispose();


                        if (win)
                        {
                            playerWin = true;
                        }
                        doMove = true;
                        // sprawdzenie czy otrzymana lista ma wartosc win

                    }

                }
            }


        }
        string convertListToString(List<int> localListOfPawns)
        {
            localListOfPawns.Sort();
            String localListPawns = "";
            if (localListOfPawns.Count == 0)
            {
                localListPawns = "[]";
            }

            for (int i = 0; i < localListOfPawns.Count; i++)
            {
                if (i == 0)
                {
                    localListPawns = "[";
                }
                if (i % 2 != 0)
                {
                    localListPawns += "," + localListOfPawns[i].ToString();
                }
                else if (i % 2 == 0)
                {
                    if (i != 0)
                    {
                        localListPawns += "," + localListOfPawns[i].ToString();
                    }
                    else
                    {
                        localListPawns += localListOfPawns[i].ToString();
                    }
                }
            }
            if (localListOfPawns.Count != 0)
            {
                localListPawns += "]";
            }
            return localListPawns;
        }
    }
}

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
    public class Computer
    {
        public List<int> listOfPawns = new List<int>();
        public bool win = false;

        public void addPawn(List<int> listOfPawnsPlayer, List<OvalShapeExtended> listOfOvalShapes, Image textureOfPawn)
        {
            String listComputerPawns = convertListToString(listOfPawns);
            String listPlayerPawns = convertListToString(listOfPawnsPlayer);


            PlTermV para = new PlTermV(3);
            para[0] = new PlTerm(listComputerPawns);
            para[2] = new PlTerm(listPlayerPawns);


            PlQuery q = new PlQuery("nowy_pionek_komputera", para);
            q.NextSolution();



            var list = para[1].ToString().Replace("[", "").Replace("]", "").Split(',');
            listOfPawns.Clear();
            foreach (var x in list)
            {
                listOfPawns.Add(Convert.ToInt32(x));
            }
            foreach (var x in list)
            {
                listOfOvalShapes[Convert.ToInt32(x)].BackgroundImage = textureOfPawn;
            }


            q = new PlQuery(string.Format("wygrywajace({0})", para[1]));
            var checkWin = q.NextSolution();

            if (checkWin)
            {
                win = true;
            }


        }
        public void MovePawn(List<int> listOfPawnsPlayer, List<OvalShapeExtended> listOfOvalShapes, Image textureOfPawn, Image BlacktextureOfPawn)
        {
            String listComputerPawns = convertListToString(listOfPawns);
            String listPlayerPawns = convertListToString(listOfPawnsPlayer);

            PlTermV para = new PlTermV(3);
            para[0] = new PlTerm(listComputerPawns);
            para[1] = new PlTerm(listPlayerPawns);


            PlQuery q = new PlQuery("ruch_komputera", para);
            q.NextSolution();

            var listBefore = para[0].ToString().Replace("[", "").Replace("]", "").Split(',');
            foreach (var x in listBefore)
            {
                listOfOvalShapes[Convert.ToInt32(x)].BackgroundImage = BlacktextureOfPawn;
            }

            var list = para[2].ToString().Replace("[", "").Replace("]", "").Split(',');
            listOfPawns.Clear();
            foreach (var x in list)
            {
                listOfPawns.Add(Convert.ToInt32(x));
            }
            Thread.Sleep(100);
            foreach (var x in list)
            {
                listOfOvalShapes[Convert.ToInt32(x)].BackgroundImage = textureOfPawn;
            }
            q = new PlQuery(string.Format("wygrywajace({0})", para[2]));
            var checkWin = q.NextSolution();
            if (checkWin)
            {
                win = true;
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

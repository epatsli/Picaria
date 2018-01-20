using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.VisualBasic;
using Microsoft.VisualBasic.PowerPacks;
using SbsSW.SwiPlCs;
using System.Threading;

namespace SIPicaria
{
    public partial class Form1 : Form
    {

        int shapeLimit = 0;
        enum GameDescription
        {
            PvsPMode,
            PvsCMode,
            AddPawnPlayerOne,
            AddPawnComputer,
            MovePlayerOne,
            WinPlayerOne,
            WinComputer
        };

        GameDescription controlVariable = GameDescription.AddPawnPlayerOne;
        GameDescription controlMove = GameDescription.AddPawnPlayerOne;


        Player playerOne;
        Computer computerPlayer;
        Thread checkWinner;

        //ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
        private ShapeContainer shapeCont;


        private List<OvalShapeExtended> listOfOvalShapes = new List<OvalShapeExtended>();
        private List<LineShape> listOfLineShapes = new List<LineShape>();


        public void CheckWinner()
        {
            while (true)
            {
                if (controlVariable == GameDescription.WinPlayerOne)
                {
                    MessageBox.Show("Gracz pierwszy zwyciezyl!");
                    break;
                }
                else if (controlVariable == GameDescription.WinComputer)
                {
                    MessageBox.Show("Komputer zwyciezyl!");
                    break;
                }
            }
        }

        public void CreatePicariaBoard(int width, int height, int marginTop)
        {

            shapeCont = new ShapeContainer();


            checkWinner = new Thread(CheckWinner);
            checkWinner.Start();

            int row = 0;
            int corner = 0; // 0 2 4 dajemy po trzy wierzochlki dla 1 3 dajemy 2 wierzcholki


            #region Rysowanie Wierzcholkow
            for (int i = 0; i < 13; i++)
            {
                if (row % 2 == 0)
                {

                        listOfOvalShapes.Add(new OvalShapeExtended 
                        { shapeId = i, Location = new Point(width * corner + 1, height * row + 1 + marginTop), 
                            positionX = width * corner + 1, 
                            positionY = height * row + 1 + marginTop, 
                            Size = new Size(30, 30), 
                            Name = "Shape: " + i.ToString(), 
                            BackgroundImage = Properties.Resources.BlackCircle 
                        });
                    if (!(corner < 2))
                    {
                        corner = 0;
                        row++;
                    }
                    else
                    {

                        corner++;
                    }
                }
                else
                {

                    listOfOvalShapes.Add(new OvalShapeExtended 
                        { shapeId = i, Location = new Point(width / 2 + (width * corner + 3), height * row + 2 + marginTop), 
                            positionX = (width / 2 + (width * corner + 2)), 
                            positionY = height * row + 2 + marginTop, 
                            Size = new Size(30, 30), 
                            Name = "Shape: " + i.ToString(), 
                            BackgroundImage = Properties.Resources.BlackCircle 
                        });

                    if (!(corner < 1))
                    {
                        corner = 0;
                        row++;
                    }
                    else
                    {
                        corner++;
                    }
                }
            }
            shapeCont.Shapes.AddRange(listOfOvalShapes.ToArray());

            this.Controls.Add(shapeCont);

            #endregion

            #region Rysowanie Linii

            // linie przekatne dlugie
            listOfLineShapes.Add(new LineShape(listOfOvalShapes[0].positionX + 15, listOfOvalShapes[0].positionY + 15,
                listOfOvalShapes[12].positionX + 15, listOfOvalShapes[12].positionY + 15));
            listOfLineShapes.Add(new LineShape(listOfOvalShapes[2].positionX + 15, listOfOvalShapes[2].positionY + 15,
                listOfOvalShapes[10].positionX + 15, listOfOvalShapes[10].positionY + 15));
            //linie gorna srodkowa i dolna
            listOfLineShapes.Add(new LineShape(listOfOvalShapes[0].positionX + 15, listOfOvalShapes[0].positionY + 15,
                listOfOvalShapes[2].positionX + 15, listOfOvalShapes[2].positionY + 15));

            listOfLineShapes.Add(new LineShape(listOfOvalShapes[5].positionX + 15, listOfOvalShapes[5].positionY + 15,
           listOfOvalShapes[7].positionX + 15, listOfOvalShapes[7].positionY + 15));

            listOfLineShapes.Add(new LineShape(listOfOvalShapes[10].positionX + 15, listOfOvalShapes[10].positionY + 15,
              listOfOvalShapes[12].positionX + 15, listOfOvalShapes[12].positionY + 15));

            // line lewa i prawa
            listOfLineShapes.Add(new LineShape(listOfOvalShapes[0].positionX + 15, listOfOvalShapes[0].positionY + 15,
              listOfOvalShapes[10].positionX + 15, listOfOvalShapes[10].positionY + 15));

            listOfLineShapes.Add(new LineShape(listOfOvalShapes[2].positionX + 15, listOfOvalShapes[2].positionY + 15,
              listOfOvalShapes[12].positionX + 15, listOfOvalShapes[12].positionY + 15));

            // linie przekatne krotkie
            listOfLineShapes.Add(new LineShape(listOfOvalShapes[1].positionX + 15, listOfOvalShapes[1].positionY + 15,
            listOfOvalShapes[5].positionX + 15, listOfOvalShapes[5].positionY + 15));

            listOfLineShapes.Add(new LineShape(listOfOvalShapes[2].positionX + 15, listOfOvalShapes[2].positionY + 15,
            listOfOvalShapes[6].positionX + 15, listOfOvalShapes[6].positionY + 15));

            listOfLineShapes.Add(new LineShape(listOfOvalShapes[1].positionX + 15, listOfOvalShapes[1].positionY + 15,
            listOfOvalShapes[7].positionX + 15, listOfOvalShapes[7].positionY + 15));

            listOfLineShapes.Add(new LineShape(listOfOvalShapes[5].positionX + 15, listOfOvalShapes[5].positionY + 15,
            listOfOvalShapes[11].positionX + 15, listOfOvalShapes[11].positionY + 15));

            listOfLineShapes.Add(new LineShape(listOfOvalShapes[7].positionX + 15, listOfOvalShapes[7].positionY + 15,
            listOfOvalShapes[11].positionX + 15, listOfOvalShapes[11].positionY + 15));

            listOfLineShapes.Add(new LineShape(listOfOvalShapes[1].positionX + 15, listOfOvalShapes[1].positionY + 15,
            listOfOvalShapes[6].positionX + 15, listOfOvalShapes[6].positionY + 15));

            listOfLineShapes.Add(new LineShape(listOfOvalShapes[6].positionX + 15, listOfOvalShapes[6].positionY + 15,
            listOfOvalShapes[11].positionX + 15, listOfOvalShapes[11].positionY + 15));
            foreach (LineShape x in listOfLineShapes)
            {
                x.BorderWidth = 1;
                x.BorderColor = Color.Black;
                x.Enabled = false;
                x.BorderStyle = System.Drawing.Drawing2D.DashStyle.Dot;
            }
            shapeCont.Shapes.AddRange(listOfLineShapes.ToArray());
            #endregion


            foreach (OvalShapeExtended x in listOfOvalShapes)
            {
                x.Click += ShapeClick;
            }

        }


        private void ShapeClick(object sender, EventArgs e)
        {

           if (controlVariable == GameDescription.PvsCMode)
            {

                OvalShapeExtended s = (OvalShapeExtended)sender;
                if (shapeLimit < 3)
                {
                    if (controlMove == GameDescription.AddPawnPlayerOne)
                    {
                        if (playerOne.spacingPawns(s.shapeId, computerPlayer.listOfPawns, listOfOvalShapes, (Image)Properties.Resources.OrangePawn))
                        {
                            controlMove = GameDescription.AddPawnComputer;
                            computerPlayer.addPawn(playerOne.listOfPawns, listOfOvalShapes, (Image)Properties.Resources.GreenPawn);
                            if (computerPlayer.win)
                            {
                                controlVariable = GameDescription.WinComputer;
                            }
                            shapeLimit++;
                            controlMove = GameDescription.AddPawnPlayerOne;
                            if (shapeLimit == 3)
                            {
                                controlMove = GameDescription.MovePlayerOne;
                            }

                        }
                    }
                }
                else
                {
                    if (controlMove == GameDescription.MovePlayerOne)
                    {
                        playerOne.MovePawn(s.shapeId, computerPlayer.listOfPawns, listOfOvalShapes, (Image)Properties.Resources.OrangePawn);
                        if (playerOne.playerWin)
                        {
                            controlVariable = GameDescription.WinPlayerOne;
                        }
                        if (playerOne.doMove)
                        {

                            computerPlayer.MovePawn(playerOne.listOfPawns, listOfOvalShapes, (Image)Properties.Resources.GreenPawn, Properties.Resources.BlackCircle);
                            if (computerPlayer.win)
                            {
                                controlVariable = GameDescription.WinComputer;
                            }
                        }
                    }
                }
            }


        }

        public Form1()
        {

            InitializeComponent();

            // CreatePicariaBoard(200, 100,30);

        }



        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (checkWinner != null)
            {
                if (checkWinner.ThreadState == ThreadState.Running)
                {
                    checkWinner.Abort();
                }
            }
            PlEngine.PlCleanup();

        }

        private void graczKontraKomputerToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (checkWinner != null)
            {
                if (checkWinner.ThreadState == ThreadState.Running)
                {
                    checkWinner.Abort();
                }
                shapeCont.Dispose();
                listOfLineShapes.Clear();
                listOfOvalShapes.Clear();
                // playerOne.listOfPawns.Clear();
                //  computerPlayer.listOfPawns.Clear();

                shapeLimit = 0;
            }


            playerOne = new Player();
            computerPlayer = new Computer();
            controlVariable = GameDescription.PvsCMode;
            controlMove = GameDescription.AddPawnPlayerOne;
            CreatePicariaBoard(200, 100, 30);
        }


    }

    public class OvalShapeExtended : OvalShape
    {
        public int shapeId { get; set; }
        public int positionX { get; set; }
        public int positionY { get; set; }

    }

}



using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SbsSW.SwiPlCs;


namespace SIPicaria
{
    public class PrologConnection
    {
        public PrologConnection(String programNet, String programProlog)
        {
            //String[] arg = { programNet, "-x", programProlog, "null" };
            //PlEngine.Initialize(arg);
        }
        public bool PrologQuery(String query, PlTermV parameters)
        {
            PlQuery q = new PlQuery(query, parameters);
            bool x = q.NextSolution();
            return x;
        }

        public bool PrologQuery(String query)
        {
            PlQuery q = new PlQuery(query);
            bool x = q.NextSolution();
            return x;
        }
        public void Disconnect()
        {
            PlEngine.PlCleanup();
        }

    }
}

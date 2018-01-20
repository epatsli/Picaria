using SbsSW.SwiPlCs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SIPicaria
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {

            if (!PlEngine.IsInitialized)
            {
                Environment.SetEnvironmentVariable("SWI_HOME_DIR", @"C:\\Program Files (x86)\\swipl");
                Environment.SetEnvironmentVariable("Path", @"C:\\Program Files (x86)\\swipl");
                Environment.SetEnvironmentVariable("Path", @"C:\\Program Files (x86)\\swipl\\bin");
                
                 String[] arg = { " - q", "-f", @"picaria.pl" };
                PlEngine.Initialize(arg);
            }

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());
        }
    }
}

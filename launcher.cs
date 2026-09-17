using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Diagnostics;
using System.Collections.Generic;
using System.Windows.Forms;

namespace CvBuilderApp
{
    static class Program
    {
        private static HttpListener _listener;
        private static string _webRoot;
        private static readonly Dictionary<string, string> MimeTypes = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            { ".html", "text/html; charset=utf-8" },
            { ".htm", "text/html; charset=utf-8" },
            { ".js", "application/javascript" },
            { ".mjs", "application/javascript" },
            { ".json", "application/json" },
            { ".css", "text/css" },
            { ".png", "image/png" },
            { ".jpg", "image/jpeg" },
            { ".jpeg", "image/jpeg" },
            { ".gif", "image/gif" },
            { ".svg", "image/svg+xml" },
            { ".ico", "image/x-icon" },
            { ".wasm", "application/wasm" },
            { ".ttf", "font/ttf" },
            { ".otf", "font/otf" },
            { ".woff", "font/woff" },
            { ".woff2", "font/woff2" },
            { ".pdf", "application/pdf" }
        };

        [STAThread]
        static void Main(string[] args)
        {
            string appDir = AppDomain.CurrentDomain.BaseDirectory;
            string potentialRoot1 = Path.Combine(appDir, "build", "web");
            string potentialRoot2 = Path.Combine(appDir, "web");
            string potentialRoot3 = @"c:\Users\TAHAR\Desktop\CV\build\web";

            if (Directory.Exists(potentialRoot1))
                _webRoot = potentialRoot1;
            else if (Directory.Exists(potentialRoot2))
                _webRoot = potentialRoot2;
            else if (Directory.Exists(potentialRoot3))
                _webRoot = potentialRoot3;
            else
            {
                MessageBox.Show("Could not find web assets directory: " + potentialRoot3, "CV Builder Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            int port = GetFreePort();

            _listener = new HttpListener();
            _listener.Prefixes.Add("http://127.0.0.1:" + port + "/");
            _listener.Start();

            Thread serverThread = new Thread(ListenLoop)
            {
                IsBackground = true
            };
            serverThread.Start();

            string appUrl = "http://127.0.0.1:" + port + "/";

            string edgePath = @"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe";
            if (!File.Exists(edgePath))
            {
                edgePath = @"C:\Program Files\Microsoft\Edge\Application\msedge.exe";
            }

            Process appProc = null;
            if (File.Exists(edgePath))
            {
                ProcessStartInfo psi = new ProcessStartInfo
                {
                    FileName = edgePath,
                    Arguments = "--app=" + appUrl + " --window-size=1366,820",
                    UseShellExecute = false
                };
                appProc = Process.Start(psi);
            }
            else
            {
                Process.Start(appUrl);
            }

            if (appProc != null)
            {
                appProc.WaitForExit();
            }
            else
            {
                Thread.Sleep(5000);
            }
        }

        private static int GetFreePort()
        {
            TcpListener l = new TcpListener(IPAddress.Loopback, 0);
            l.Start();
            int port = ((IPEndPoint)l.LocalEndpoint).Port;
            l.Stop();
            return port;
        }

        private static void ListenLoop()
        {
            while (_listener != null && _listener.IsListening)
            {
                try
                {
                    HttpListenerContext ctx = _listener.GetContext();
                    ThreadPool.QueueUserWorkItem(ProcessRequest, ctx);
                }
                catch
                {
                    break;
                }
            }
        }

        private static void ProcessRequest(object state)
        {
            HttpListenerContext ctx = (HttpListenerContext)state;
            try
            {
                string rawUrl = ctx.Request.Url.LocalPath;
                if (rawUrl == "/" || string.IsNullOrEmpty(rawUrl))
                {
                    rawUrl = "/index.html";
                }

                string relPath = rawUrl.TrimStart('/').Replace('/', Path.DirectorySeparatorChar);
                string filePath = Path.Combine(_webRoot, relPath);

                if (File.Exists(filePath))
                {
                    string ext = Path.GetExtension(filePath);
                    string mime;
                    if (!MimeTypes.TryGetValue(ext, out mime))
                    {
                        mime = "application/octet-stream";
                    }

                    ctx.Response.ContentType = mime;
                    ctx.Response.StatusCode = 200;
                    ctx.Response.AddHeader("Access-Control-Allow-Origin", "*");

                    byte[] bytes = File.ReadAllBytes(filePath);
                    ctx.Response.ContentLength64 = bytes.Length;
                    ctx.Response.OutputStream.Write(bytes, 0, bytes.Length);
                }
                else
                {
                    ctx.Response.StatusCode = 404;
                }
            }
            catch
            {
                ctx.Response.StatusCode = 500;
            }
            finally
            {
                try { ctx.Response.OutputStream.Close(); } catch { }
            }
        }
    }
}

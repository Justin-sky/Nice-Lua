using UnityEngine;
using System.Collections;
using System;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Net;

public class IPv6SupportMidleware
{
	public static void getIPType(String serverIp, String serverPorts, out AddressFamily  mIPType)
	{
		mIPType = AddressFamily.InterNetwork;

        //解析是否ipv6
        IPAddress[] address = Dns.GetHostAddresses(serverIp);
        if (address[0].AddressFamily == AddressFamily.InterNetworkV6)
        {
            mIPType = AddressFamily.InterNetworkV6;
        }
	}

}

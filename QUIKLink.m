BeginPackage["QUIKLink`"]

DLLConnect::usage := "DLLConnect[] - connect to TRANS2QUIK dynamic library"

DLLConnectedQ::usage := "DLLConnectedQ[] - find out whether connection is established to TRANS2QUIK dynamic library"

DLLDisconnect::usage := "DLLDisconnect[] - close connection to TRANS2QUIK dynamic library"

QUIKConnectedQ::usage := "QUIKConnectedQ[] - find out whether QUIK terminal is connected to server"

SendAsyncTransaction::usage := "SendAsyncTransaction[transaction] - send transaction. See transaction format in QUIK documentation."

Begin["`Private`"]

Needs["NETLink`"];
ReinstallNET["Force32Bit" -> True];

DLLPath = "C:\\OTKRITIE\\TRANS2QUIK.dll";
QUIKPath = "C:\\OTKRITIE";
ExtErrorCode = 0;
ErrorMsg = "";
ErrorMsgSize = 0;
transaction = "";

defDLLConnect = DefineDLLFunction[
   "TRANS2QUIK_CONNECT",
   DLLPath,
   "long",
   {"LPCSTR", "out long", "out LPSTR", "DWORD"}
   ];

DLLConnect[] :=
 Switch[
    #,
    0, "CONNECTED",
    4, "ALREADY_CONNECTED_TO_QUIK",
    2, "QUIK_TERMINAL_NOT_FOUND",
    1, "CONNECT_FAILED",
    3, "DLL_VERSION_NOT_SUPPORTED"
    ] &@defDLLConnect[QUIKPath, ExtErrorCode, ErrorMsg, ErrorMsgSize]

defDLLConnectedQ = DefineDLLFunction[
   "TRANS2QUIK_IS_DLL_CONNECTED",
   DLLPath,
   "long",
   {"out long", "out LPSTR", "DWORD"}
   ];

DLLConnectedQ[] :=
 Switch[
    #,
    10, "DLL_CONNECTED",
    7, "DLL_NOT_CONNECTED"
    ] &@defDLLConnectedQ[ExtErrorCode, ErrorMsg, ErrorMsgSize]

defDLLDisconnect = DefineDLLFunction[
   "TRANS2QUIK_DISCONNECT",
   DLLPath,
   "long",
   {"out long", "out LPSTR", "DWORD"}
   ];

DLLDisconnect[] :=
 Switch[
    #,
    0, "DISCONNECTED",
    7, "DLL_NOT_CONNECTED",
    1, "DISCONNECT_FAILED"
    ] &@defDLLDisconnect[ExtErrorCode, ErrorMsg, ErrorMsgSize]	

defQUIKConnectedQ = DefineDLLFunction[
   "TRANS2QUIK_IS_QUIK_CONNECTED",
   DLLPath,
   "long",
   {"out long", "out LPSTR", "DWORD"}
   ];

QUIKConnectedQ[] :=
 Switch[
    #,
    8, "QUIK_CONNECTED_TO_SERVER",
    9, "QUIK_DISCONNECTED",
    6, "QUIK_NOT_CONNECTED",
    7, "DLL_NOT_CONNECTED"
    ] &@defQUIKConnectedQ[ExtErrorCode, ErrorMsg, ErrorMsgSize]

defSendAsyncTransaction = DefineDLLFunction[
   "TRANS2QUIK_SEND_ASYNC_TRANSACTION",
   DLLPath,
   "long",
   {"LPSTR", "out long", "out LPSTR", "DWORD"}
   ];

SendAsyncTransaction[paramtransaction_] :=
 Switch[
    #,
    0, "SUCCESSFUL",
    6, "QUIK_NOT_CONNECTED",
    7, "DLL_NOT_CONNECTED",
    5, "WRONG_SYNTAX",
    1, "CONNECT_FAILED"
    ] &@defSendAsyncTransaction[paramtransaction, ExtErrorCode, ErrorMsg, ErrorMsgSize]

End[]

EndPackage[]
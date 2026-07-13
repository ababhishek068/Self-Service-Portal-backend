dotnet
{
    assembly(mscorlib)
    {
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';
        Version = '4.0.0.0';

        type(System.Array; Array) { }
        type(System.Convert; Convert) { }
        type(System.IO.File; File) { }
        type(System.IO.MemoryStream; MemoryStream) { }
    }

    // 	assembly("Microsoft.VisualBasic")
    // 	{

    // 		Culture='neutral';
    // 		PublicKeyToken='b03f5f7f11d50a3a';
    // 		Version='10.0.0.0';

    // 		type("Microsoft.VisualBasic.Interaction";"Interaction"){}
    // 	}
}

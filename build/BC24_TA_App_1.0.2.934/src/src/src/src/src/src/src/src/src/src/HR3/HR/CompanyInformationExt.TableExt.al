tableextension 50019 "Company Information Ext" extends "Company Information"
{
    fields
    {
        field(50100; Vision; Text[500]) { }
        field(50101; Mission; Text[500]) { }
        field(50102; Philosophy; Text[500]) { }
        field(50103; "Core values"; Text[500]) { }
        field(50104; Motto; Text[500]) { }
        field(50106; "Company Watermark"; Blob)
        {
            SubType = Bitmap;
        }

    }


}
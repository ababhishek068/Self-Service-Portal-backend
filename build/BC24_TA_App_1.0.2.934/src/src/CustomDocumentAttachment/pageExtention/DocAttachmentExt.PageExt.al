namespace Hijra.Hijra;

using Microsoft.Foundation.Attachment;

pageextension 50069 "Doc Attachment Ext" extends "Document Attachment Details"
{
    layout
    {
        addafter("File Type")
        {
            field("Document Category"; Rec."Document Category")
            {
                ToolTip = 'Specifies the value of the Document Category field.';
            }
            field(Current; Rec.Current)
            {
                ToolTip = 'Specifies the value of the Current field.';
            }
        }
    }
}

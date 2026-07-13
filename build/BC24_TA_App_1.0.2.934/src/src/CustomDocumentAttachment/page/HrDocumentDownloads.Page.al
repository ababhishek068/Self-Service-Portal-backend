namespace Hijra.Hijra;
using Microsoft.Foundation.Attachment;

page 51564 "Hr Document Downloads"
{
    ApplicationArea = All;
    Caption = 'Hr Document Downloads';
    PageType = List;
    SourceTable = "Hr Document Downloads";
    UsageCategory = None;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No")
                {
                    ToolTip = 'Specifies the value of the Document No field.', Comment = '%';
                    Editable = false;
                }
                field("Document Category"; Rec."Document Category")
                {
                    ToolTip = 'Specifies the value of the Document Category field.', Comment = '%';
                }
                field("Document Description"; Rec."Document Description")
                {
                    ToolTip = 'Specifies the value of the Document Description field.', Comment = '%';
                }
                field(Publish; Rec.Publish)
                {
                    ToolTip = 'Specifies the value of the Publish field.', Comment = '%';
                }
            }
        }
        area(FactBoxes)
        {
            part("Attachmented Documents"; "Document Attachment Factbox")
            {
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Hr Document Downloads"),
                              "No." = field("Document No");
            }
        }
    }
}

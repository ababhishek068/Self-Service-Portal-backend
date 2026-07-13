Page 51238 "Asset Transfer List"
{
    CardPageID = "Asset Transfer Card";
    Editable = false;
    PageType = List;
    SourceTable = "Asset Transfer";
    SourceTableView = where(Transferred = filter(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(RaisedBy; Rec."Raised By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Raised By field.';
                }
                field(AssettoTransfer; Rec."Asset to Transfer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset to Transfer field.';
                }
                field(FromLocation; Rec."From Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Location field.';
                }
                field(FromResponsibleEmployee; Rec."From Responsible Employee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Responsible Employee field.';
                }
                field(ToLocation; Rec."To Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Location field.';
                }
                field(ToResponsibleEmployee; Rec."To Responsible Employee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Responsible Employee field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Transferred; Rec.Transferred)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transferred field.';
                }
            }
        }
    }

    actions { }
}


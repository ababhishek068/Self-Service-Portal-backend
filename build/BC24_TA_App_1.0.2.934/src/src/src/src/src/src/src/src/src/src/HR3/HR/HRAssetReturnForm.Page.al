Page 50296 "HR Asset Return Form"
{
    DeleteAllowed = true;
    InsertAllowed = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "HR Misc. Article Information";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(MiscArticleCode; Rec."Misc. Article Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Misc. Article Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(FromDate; Rec."From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field(ToDate; Rec."To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field(InUse; Rec."In Use")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the In Use field.';
                }
                field(SerialNo; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Serial No. field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
            }
        }
    }

    actions { }

    var
    // EI: Record "prEmployee Motor Vehicles";

    procedure refresh()
    begin
        CurrPage.Update(false);
    end;
}


Page 50389 "Security Gatepass List"
{
    CardPageID = "Approved Gate Pass Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Gate Pass";
    SourceTableView = where(Status = filter(Approved));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(GatePassNo; Rec."Gate Pass No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gate Pass No. field.';
                }
                field(DateOut; Rec."Date Out")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Out field.';
                }
                field(TimeOut; Rec."Time Out")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Out field.';
                }
                field(AssetTransferNo; Rec."Asset Transfer No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Transfer No field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(AssetDescription; Rec."Asset Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Description field.';
                }
                field(AssetFromLocation; Rec."Asset From Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset From Location field.';
                }
                field(AssetToLocation; Rec."Asset To Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset To Location field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control13; Outlook) { }
        }
    }

    actions { }
}


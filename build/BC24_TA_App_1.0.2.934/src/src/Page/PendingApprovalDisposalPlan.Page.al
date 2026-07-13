page 51440 "Pending Approval Disposal Plan"
{
    Caption = 'Pending Approval Disposal Plan';
    CardPageID = "Disposal Plan Card";
    PageType = List;
    SourceTable = "Disposal Plan Header";
    SourceTableView = WHERE(Status = FILTER('Pending Approval'));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Disposal No."; Rec."Disposal No.")
                {
                    ToolTip = 'Specifies the value of the Disposal No. field.';
                }
                field("Disposal Period"; Rec."Disposal Period")
                {
                    ToolTip = 'Specifies the value of the Disposal Period field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Disposal Status"; Rec."Disposal Status")
                {
                    ToolTip = 'Specifies the value of the Disposal Status field.';
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ToolTip = 'Specifies the value of the Prepared By field.';
                }
            }
        }
    }

    actions { }
}


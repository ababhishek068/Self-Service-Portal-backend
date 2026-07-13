Page 50810 "Disposal List"
{
    Caption = 'Disposal Plan';
    CardPageID = "Disposal Plan Card";
    Editable = false;
    PageType = List;
    SourceTable = "Disposal Plan Header";
    SourceTableView = WHERE(Status = FILTER('Open'));
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
                field("Prepared By"; Rec."Prepared By")
                {
                    ToolTip = 'Specifies the value of the Prepared By field.';
                }
                field("Disposal Status"; Rec."Disposal Status")
                {
                    ToolTip = 'Specifies the value of the Disposal Status field.';
                }
            }
        }
    }

    actions { }
}


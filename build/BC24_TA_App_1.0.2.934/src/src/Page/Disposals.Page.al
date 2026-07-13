Page 51153 "Disposals"
{
    Caption = 'Disposals Consolidation';
    CardPageID = "Disposals Card";
    PageType = List;
    SourceTable = Disposals;
    SourceTableView = where("Disposal Status" = filter(Open));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Disposal No."; Rec."Disposal No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal No. field.';
                }
                field("Disposal Period"; Rec."Disposal Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Period field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }

                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepared By field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions { }
}


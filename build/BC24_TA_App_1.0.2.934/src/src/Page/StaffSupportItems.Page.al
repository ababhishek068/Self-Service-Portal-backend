Page 50356 "Staff Support Items"
{
    PageType = List;
    SourceTable = "Project Task Allocation";
    SourceTableView = where("Allocation Type" = const(" "));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project No"; Rec."Project No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project No field.';
                }
                field("Support Entry No"; Rec."Support Entry No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Support Entry No field.';
                }
                field("Support Issue Description"; Rec."Support Issue Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Support Issue Description field.';
                }
                field("Solution Type"; Rec."Solution Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Solution Type field.';
                }
                field("Solution Remarks"; Rec."Solution Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Solution Remarks field.';
                }
            }
        }
    }

    actions { }
}


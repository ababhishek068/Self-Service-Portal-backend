Page 50354 "Task Allocation"
{
    PageType = List;
    SourceTable = "Project Task Allocation";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff No field.';
                }
                field("Project Module"; Rec."Project Module")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Module field.';
                }
                field("Allocation Remarks"; Rec."Allocation Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allocation Remarks field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Consoltant Status"; Rec."Consoltant Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Consoltant Status field.';
                }
            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Allocation Type" := Rec."allocation type"::Implementation;
    end;
}


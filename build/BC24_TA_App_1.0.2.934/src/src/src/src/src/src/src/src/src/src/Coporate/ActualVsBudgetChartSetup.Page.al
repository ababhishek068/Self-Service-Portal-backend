namespace ABH_UAT_LIVE.ABH_UAT_LIVE;

page 51588 "Actual Vs Budget Chart Setup"
{
    ApplicationArea = All;
    Caption = 'Actual Vs Budget Chart Setup';
    PageType = ListPart;
    SourceTable = "Actual Target Chart Setup";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Project; Rec.Project)
                {
                    ToolTip = 'Specifies the value of the Project field.', Comment = '%';
                }
                field("Baseline Type"; Rec."Baseline Type")
                {
                    ToolTip = 'Specifies the value of the Baseline Type field.', Comment = '%';
                }
                field("Activity Type"; Rec."Activity Type")
                {
                    ToolTip = 'Specifies the value of the Activity Type field.', Comment = '%';
                }
                
                field("Task No";"Task No"){
                    ApplicationArea=basic;
                }
                field("Task Description";"Task Description")
                {
                    ToolTip = 'Specifies the value of the task description field.', Comment = '%';
                }
                field(ChartType; Rec.ChartType)
                {
                    ToolTip = 'Specifies the value of the ChartType field.', Comment = '%';
                }
                field("Exclude From Chart"; Rec."Exclude From Chart")
                {
                    ToolTip = 'Specifies the value of the Exclude From Chart field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Get(UserID) then begin
            "User ID":=UserID;
            Insert();
        end;
        FilterGroup(2);
        SetRange("User ID",UserID);
        FilterGroup(0);
    end;
}


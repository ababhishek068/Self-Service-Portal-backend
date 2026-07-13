Page 51291 "HR Jobs List"
{
    CardPageID = "HR Jobs Card";
    DelayedInsert = true;
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Functions,Job,Administration';
    RefreshOnActivate = true;
    SourceTable = "HR Jobs";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(JobID; Rec."Job ID")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field(JobTitle; Rec."Job Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Job Description field.';
                }

                field("Job Grade";"Job Grade")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Job Grade field.';
                }

                field("PSC Job Grade"; Rec."PSC Job Grade")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PSC Job Grade field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755004; Outlook) { }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OrnStr)
            {
                Caption = 'Organizational Structure';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = report "Organizational Structure";
                ToolTip = 'Executes the Organizational Structure action.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(Rec."Vacant Positions");
        Rec.CalcFields("Occupied Positions");

        //if ("No. Of Positions Available" > 0) and ("No. Of Positions Available" >= "Occupied Positions") then
        //Vacant Positions" := "No. Of Positions Available" - "Occupied Positions";

    end;
}


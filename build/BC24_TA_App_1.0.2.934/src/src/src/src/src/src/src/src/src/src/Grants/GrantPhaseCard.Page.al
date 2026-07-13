page 50083 "Grant Phase Card"
{
    PageType = Card;
    SourceTable = "Grant Phases";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Phase)
            {
                Caption = 'Phase';
                Image = Intrastat;
                action("Reporting Schedules")
                {
                    Caption = 'Reporting Schedules';
                    Promoted = true;
                    RunObject = Page "Phase Reporting Schedules";
                    RunPageLink = Phase = FIELD(Code);
                    ToolTip = 'Executes the Reporting Schedules action.';
                }
                action("Reporting Audit Dates")
                {
                    Caption = 'Reporting Audit Dates';
                    RunObject = Page "Phase Reporting Schedules";
                    ToolTip = 'Executes the Reporting Audit Dates action.';
                }
            }
        }
    }
}


page 50119 "Audit Meeting Agenda"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Audit Meetings Agenda List";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field("Agenda Desc 1"; Rec."Agenda Desc 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Agenda Desc 1 field.';

                }
                field("Agenda Desc 2"; Rec."Agenda Desc 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Agenda Desc 2 field.';

                }
                field("Discussed?"; Rec."Discussed?")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discussed? field.';

                }
                field("Date Created"; Rec.Code)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field("Date Edited"; Rec."Date Edited")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Edited field.';

                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Created By field.';

                }
                field("Edited By"; Rec."Edited By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Edited By field.';

                }
            }
        }
    }




}
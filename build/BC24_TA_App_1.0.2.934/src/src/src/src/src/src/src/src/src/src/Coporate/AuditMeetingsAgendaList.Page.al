Page 50549 "Audit Meetings Agenda List"
{
    PageType = List;
    SourceTable = "Audit Meetings Agenda List";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(MeetingCode; Rec."Meeting Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Meeting Code field.';
                }
                field(AgendaDesc1; Rec."Agenda Desc 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Agenda Desc 1 field.';
                }
                field(AgendaDesc2; Rec."Agenda Desc 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Agenda Desc 2 field.';
                }
                field(Discussed; Rec."Discussed?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Discussed? field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(DateEdited; Rec."Date Edited")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Edited field.';
                }
                field(EditedBy; Rec."Edited By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Edited By field.';
                }
            }
        }
    }

    actions { }
}


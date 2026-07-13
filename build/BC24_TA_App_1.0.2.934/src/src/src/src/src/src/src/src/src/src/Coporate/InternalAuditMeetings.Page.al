Page 50548 "Internal Audit Meetings"
{
    CardPageID = "Audit Meetings Card";
    PageType = List;
    SourceTable = "Audit Meetings";
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
                field(AuditCode; Rec."Audit Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Code field.';
                }
                field(Description1; Rec."Description 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description 1 field.';
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field(AuditProgramme; Rec."Audit Programme")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Programme field.';
                }
                field(AuditNo; Rec."Audit No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit No. field.';
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
                field(MeetingDate; Rec."Meeting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Meeting Date field.';
                }
            }
        }
    }

    actions { }
}


page 50118 "Audit Meetings Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Audit Meetings";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Audit Code"; Rec."Audit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit Code field.';

                }
                field("Audit No."; Rec."Audit No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit No. field.';

                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category field.';

                }
                field("Audit Programme"; Rec."Audit Programme")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit Programme field.';

                }
            }
            group(Agenda)
            {
                part(MeetingAgends; "Audit Meeting Agenda")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Meeting Code" = field(Code);
                }
            }
            group(Attendance)
            {
                part(Attendee; "Audit meeting Attendance")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Meeting Code" = field(Code);
                }
            }
        }
        area(factboxes)
        {


            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(51584),
                              "No." = FIELD("Code");
            }

            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }
}
Page 51457 "Approved LV App List"
{
    CardPageID = "HR Leave App Card1";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HR Leave Application";
    SourceTableView = where(Status = const("Approved"));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Editable = false;
                field(ApplicationNo; Rec."Application Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Application No';
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Application No field.';
                }
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(EmpoyeeName; Rec."Empoyee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Empoyee Name field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }

                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(LeaveType; Rec."Leave Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Leave Type field.';
                }
                field(DaysApplied; Rec."Days Applied")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Days Applied field.';
                }
                field(ReturnDate; Rec."Return Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Return Date field.';
                }
                field(StartDate; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    StyleExpr = StyleText;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755004; Outlook) { }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    var
        HRCodeunit: Codeunit "HR Codeunit";
    begin
        StyleText := HRCodeunit.fn_SetStyle(Format(Rec.Status));
    end;

    trigger OnOpenPage()
    begin
        //SetFilter("User ID", UserId);
    end;

    var
        StyleText: Text;
}


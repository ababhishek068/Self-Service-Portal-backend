namespace PTL.HRMIS;
using System.Security.User;

page 52202753 "HR Attendance List"
{
    ApplicationArea = All;
    Caption = 'HR Attendance List';
    // Editable = false;
    PageType = List;
    SourceTable = "HR Attendance Ledger";
    // SourceTableView = where("Entry Type" = filter(Present));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Staff No."; Rec."Staff No.")
                {
                    ToolTip = 'Specifies the value of the Staff No. field.';
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ToolTip = 'Specifies the value of the Staff Name field.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                // field(Market; Rec.Market)
                // {
                //     ToolTip = 'Specifies the value of the Market field.';
                // }
                field("Posting Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the transaction Date .';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }
                field("Time In"; Rec."Time In")
                {
                    ToolTip = 'Specifies the value of the Time In field.';
                }
                field("Time out"; Rec."Time out")
                {
                    ToolTip = 'Specifies the value of the Time out field.';
                }
                field("Hours Worked"; Rec."Hours Worked")
                {
                    ToolTip = 'Specifies the value of the Hours Worked field.';
                }
                field("Location Coordinates"; Rec."Location Coordinates")
                {
                    ToolTip = 'Specifies the value of the Location Coordinates field.';
                }
                field("Location Name"; Rec."Location Name")
                {
                    ToolTip = 'Specifies the value of the Location Name field.';
                    visible = false;
                }
                field("Signin Location"; Rec."Signin Location")
                {
                    ToolTip = 'Specifies the value of the Signin Location field.';
                }
                field("Signout Location"; Rec."Signout Location")
                {
                    ToolTip = 'Specifies the value of the Signout Location field.';
                }
                field("Checked Out"; Rec."Checked Out")
                {
                    ToolTip = 'Specifies the value of the is Checked Out? field.';
                }
                field("login date time"; Rec."login date time")

                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the login date time field.';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(CheckIn)
            {
                Caption = 'Check In';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Check In action.';
                Visible = true;

                trigger OnAction()
                begin
                    IF Rec."Time In" <> 0T then
                        Error('Already Checked In');

                    if Confirm('Check in ' + Rec."Staff Name", true) = false then
                        Error('Operation Cancelled');
                    Rec."Date" := Today;
                    Rec."Time In" := Time;
                    Rec.Modify();

                    Message('Clock in Successful');
                end;
            }

            action(CheckOut)
            {
                Caption = 'Check Out';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Check Out action.';
                Visible = true;

                trigger OnAction()
                begin
                    If Rec."Time In" = 0T then
                        Error('Not Checked In');
                    If Rec."Checked Out" = true then
                        Error('Already Checked Out');

                    if Confirm('Check out ' + Rec."Staff Name", true) = false then
                        Error('Operation Cancelled');
                    Rec."Checked Out" := true;
                    Rec."Checked Out By" := UserId;
                    Rec."Time out" := Time;
                    rec.Validate("Time out");
                    Rec.Modify();

                    CurrPage.Update();
                end;
            }
        }
        area(Reporting)
        {
            group(Reports)
            {
                action(AttendanceReport)
                {
                    Caption = 'Attendance Report';
                    Image = Report2;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = report "HR Attendance Report";
                    ToolTip = 'Executes the Attendance Report action.';
                }
                action(AttendanceSummary)
                {
                    Caption = 'Attendance Summary';
                    Image = Report2;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = report "HR Monthly Attendance Summary";
                    ToolTip = 'Get HR Monthly Attendance Summary in a range of days';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        TodayDatetime: DateTime;
        hoursText: text;
    begin
        hoursText := '';
        TodayDatetime := CreateDateTime(Today, Time);
        if Rec.Date = Today then begin
            if Rec."login date time" <> 0DT then
                Rec."Hours Worked" := Round((TodayDatetime - Rec."login date time") / 3600000, 0.01, '=');
            if Rec."Time out" = 0T then
                Rec."Signout Location" := '';

            Rec.Modify();
        end;
    end;

    trigger OnOpenPage()
    begin
        UserSetup.Reset();
        if UserSetup.get(UserId) then
            Rec.SetFilter("Global Dimension 1 Code", UserSetup."Global Dimension 1 Code");

        Rec.SetFilter(Date, '=%1', Today);
    end;

    var
        UserSetup: Record "User Setup";
}

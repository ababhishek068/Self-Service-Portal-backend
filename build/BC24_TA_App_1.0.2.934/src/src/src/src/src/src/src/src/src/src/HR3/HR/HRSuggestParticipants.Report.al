Report 50181 "HR Suggest Participants"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRSuggestParticipants.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employees"; "HR-Employee")
        {
            DataItemTableView = where(Status = const(Active));
            RequestFilterFields = Gender, "Global Dimension 1 Code", "Global Dimension 2 Code";
            column(ReportForNavId_1; 1) { }
        }
        dataitem("HR Training App Lines"; "HR Training App Lines")
        {
            //DataItemTableView = sorting("Line No.","Application No.") order(ascending);
            column(ReportForNavId_2; 2) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        ApplicationNoFilter: Code[10];
        HRShiftScheduleLines: Record "HR Shift Schedule Lines";

    local procedure fn_InsertEntries()
    begin
        HRShiftScheduleLines.Init;

        HRShiftScheduleLines."Line No." := fn_GetLastEntryNo;
        HRShiftScheduleLines.Code := ApplicationNoFilter;
        HRShiftScheduleLines."Employee No." := "HR-Employees"."No.";
        HRShiftScheduleLines.Validate(HRShiftScheduleLines."Employee No.");

        HRShiftScheduleLines.Insert;
    end;

    local procedure fn_GetLastEntryNo() LastEntryNo: Integer
    var
        HRShiftScheduleLines_2: Record "HR Shift Schedule Lines";
    begin
        HRShiftScheduleLines_2.Reset;
        if HRShiftScheduleLines_2.FindLast then begin
            LastEntryNo := HRShiftScheduleLines_2."Line No." + 1;
        end else begin
            LastEntryNo := 1;
        end;
    end;
}


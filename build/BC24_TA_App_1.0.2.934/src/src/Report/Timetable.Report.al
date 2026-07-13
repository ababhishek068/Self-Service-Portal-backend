Report 50276 "Time table"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Timetable.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Time Table"; "Time Table")
        {
            DataItemTableView = sorting(Programme, Stage, Unit, Semester, Period, "Day of Week", Class, "Unit Class", Exam, Released, "Campus Code");
            RequestFilterFields = "Campus Code", "Mode of Study", Programme, Stage;
            column(ReportForNavId_1; 1) { }
            column(Department; "Time Table".DPTNM) { }
            column(Programme; "Time Table".progname) { }
            column(Stage; "Time Table".Stage) { }
            column(Day; "Time Table"."Day of Week") { }
            column(Time; "Time Table".Period) { }
            column(UnitCode; "Time Table".Unit) { }
            column(Description; "Time Table".unitNm) { }
            column(Venue; "Time Table"."Lecture Room") { }
            column(Lecturer; "Time Table"."Lecturer Name") { }
            column(Daycode; "Time Table"."Day Code") { }
            column(pic; info.Picture) { }
            column(Companyname; info.Name) { }
            column(college; info."Name 2") { }
            column(campus; "Time Table"."Campus Code") { }
            column(Session; "Time Table".semNM) { }
            column(dep; dpt) { }
            column(Unit_Class; "Unit Class") { }

            trigger OnAfterGetRecord()
            begin
                info.Reset;
                if info.Find('-') then
                    info.CalcFields(Picture);

                dpt := UpperCase("Time Table".DPTNM);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        info: Record "Company Information";
        dpt: Text[200];
}


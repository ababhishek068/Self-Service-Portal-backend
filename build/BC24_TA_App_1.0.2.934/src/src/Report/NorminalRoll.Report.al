Report 50084 "Norminal Roll"
{
    DefaultLayout = RDLC;
    Caption = 'Norminal Roll';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Layouts/NorminalRoll.rdlc';

    dataset
    {
        dataitem("Course Registration"; "Course Registration")
        {
            DataItemTableView = sorting(Programme, Stage) where(Reversed = filter(false), "Cust Exist" = filter(> 0), Posted = filter(true));
            RequestFilterFields = "Semester Filter", Stage, "Student Type", Programme, "Settlement Type", "Campus Filter", "Entry Intake";
            column(ReportForNavId_1; 1) { }
            column(Names_CourseRegistration; "Course Registration".Names) { }
            column(Gender_CourseRegistration; "Course Registration".Gender) { }
            column(Programme_CourseRegistration; "Course Registration".Programme) { }
            column(Stage_CourseRegistration; "Course Registration".Stage) { }
            column(SettlementType_CourseRegistration; "Course Registration"."Settlement Type") { }
            column(StudentNo_CourseRegistration; "Course Registration"."Student No.") { }
            column(Nm; Nm) { }
            column(N; N) { }
            column(Semester_CourseRegistration; "Course Registration".Semester) { }
            column(CompName; CompInf.Name) { }
            column(CompPic; CompInf.Picture) { }
            column(ProgName; Prog.Description) { }
            column(CustID; Cust."ID No") { }
            column(Stage; "Course Registration".Stage) { }
            column(Semester_CF; "Semester CF") { }

            trigger OnAfterGetRecord()
            begin

                Nm := Nm + 1;

                /*
                 IF CurrStage <>"Course Registration".Stage THEN BEGIN
                CurrStage:="Course Registration".Stage;
                Nm:=1;
                END;
                 */

                if Prog.Get("Course Registration".Programme) then;
                if Cust.Get("Course Registration"."Student No.") then;

            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(Picture);

                "Course Registration".SetFilter("Course Registration".Semester, GetFilter("Course Registration"."Semester Filter"));

                N := "Course Registration".Count;
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
        Nm: Integer;
        N: Integer;
        CompInf: Record "Company Information";
        Prog: Record Programme;
        Cust: Record Customer;
}


report 50063 "Student Transfer"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Transfer-School.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Students Transfer"; "Students Transfer")
        {
            RequestFilterFields = "New Student No";
            column(ReportForNavId_1; 1) { }
            column(StudentNo_StudentsTransfer; "Students Transfer"."Student No") { }
            column(Name_StudentsTransfer; "Students Transfer".Name) { }
            column(NewStudentNo_StudentsTransfer; "Students Transfer"."New Student No") { }
            column(NewProgramme_StudentsTransfer; "Students Transfer"."New Programme") { }
            column(DeptName; DeptName) { }
            column(SchoolName; SchoolName) { }
            column(CompName; CompInf.Name) { }
            column(CompLogo; CompInf.Picture) { }
            column(OldProg; OldProg) { }
            column(NewProg; NewProg) { }
            column(OldStudentNo_StudentsTransfer; "Students Transfer"."Old Student No") { }
            column(OldSchool; OldSchool) { }
            column(Date_StudentsTransfer; "Students Transfer".Date) { }
            column(Approval_Date; ApprovalDate) { }
            column(Names; Names) { }

            trigger OnAfterGetRecord()
            begin
                if Prog.Get("Students Transfer"."New Programme") then begin
                    NewProg := Prog.Description;
                    DimRec.Reset;
                    DimRec.SetRange(DimRec.Code, Prog."Department");
                    if DimRec.Find('-') then DeptName := DimRec.Name;

                    DimRec.Reset;
                    DimRec.SetRange(DimRec.Code, Prog."School Code");
                    if DimRec.Find('-') then SchoolName := DimRec.Name;

                end;
                if Prog.Get("Students Transfer"."Current Programme") then begin
                    OldProg := Prog.Description;

                    DimRec.Reset;
                    DimRec.SetRange(DimRec.Code, Prog."School Code");
                    if DimRec.Find('-') then OldSchool := DimRec.Name;
                end;
                GenSetup.Get();
                ApprovalDate := GenSetup."Prog. Transfer Approval Date";

                if Cust.Get("Students Transfer"."Student No") then
                    Names := Cust.Name;
            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(Picture);
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
        CompInf: Record "Company Information";
        DimRec: Record "Dimension Value";
        Prog: Record Programme;
        DeptName: Text[100];
        SchoolName: Text[100];
        OldProg: Text[100];
        NewProg: Text[100];
        OldSchool: Text[100];
        ApprovalDate: Date;
        GenSetup: Record "General Set-Up";
        Cust: Record Customer;
        Names: Text[200];
}
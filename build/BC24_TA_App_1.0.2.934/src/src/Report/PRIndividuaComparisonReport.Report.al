Report 50165 "PR Individua Comparison Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRIndividuaComparisonReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("PR Transaction Codes"; "PR Transaction Codes")
        {
            DataItemTableView = sorting("Transaction Code") order(descending);
            column(ReportForNavId_9; 9) { }
            column(TransactionCode_PRTransactionCodes; "PR Transaction Codes"."Transaction Code") { }
            column(TransactionName_PRTransactionCodes; "PR Transaction Codes"."Transaction Name") { }
            dataitem("PR Salary Card"; "PR Salary Card")
            {
                DataItemTableView = sorting("Employee Code");
                RequestFilterFields = "Employee Code";
                column(ReportForNavId_2; 2) { }
                column(Names; Names) { }
                column(EmpNo; EmpNo) { }
                column(VPast; VPast) { }
                column(VCurr; VCurr) { }
                column(VVar; VVar) { }
                column(Reason; Reason) { }

                trigger OnAfterGetRecord()
                begin

                    Employee.Get("PR Salary Card"."Employee Code");

                    if HrEmp.Get("PR Salary Card"."Employee Code") then
                        Names := HrEmp."First Name" + ' ' + HrEmp."Middle Name" + ' ' + HrEmp."Last Name";
                    EmpNo := HREmp."No.";
                    VPast := 0;
                    VCurr := 0;
                    VVar := 0;

                    Matrix.Reset;
                    Matrix.SetRange(Matrix."Employee Code", "PR Salary Card"."Employee Code");
                    Matrix.SetRange(Matrix."Payroll Period", PrevPeriod);
                    Matrix.SetRange(Matrix."Transaction Code", "PR Transaction Codes"."Transaction Code");
                    Matrix.SetRange(Matrix."Posting Group", PostingGroup);
                    if Matrix.FindFirst() then begin
                        VPast := Abs(Matrix.Amount);
                        TransCode := Matrix."Transaction Code";
                        TransName := Matrix."Transaction Name";
                    end;

                    Matrix.Reset;
                    Matrix.SetRange(Matrix."Employee Code", "PR Salary Card"."Employee Code");
                    Matrix.SetRange(Matrix."Payroll Period", CurrPeriod);
                    Matrix.SetRange(Matrix."Transaction Code", "PR Transaction Codes"."Transaction Code");
                    Matrix.SetRange(Matrix."Posting Group", PostingGroup);
                    if Matrix.FindFirst() then begin
                        VCurr := Abs(Matrix.Amount);
                        TransCode := Matrix."Transaction Code";
                        TransName := Matrix."Transaction Name";
                    end;

                    VVar := VCurr - VPast;
                    VPastTot := VPastTot + VPast;
                    VCurrTot := VCurrTot + VCurr;
                    VVarTot := VVarTot + VVar;

                    //IF (VPast=0) AND (VCurr=0) AND (VVar=0) THEN CurrReport.SKIP;

                    if (VVar = 0) then CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    VPastTot := 0;
                    VCurrTot := 0;
                    VVarTot := 0;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Previous Period"; PrevPeriod)
                {
                    ApplicationArea = Basic;
                    TableRelation = "PR Payroll Periods"."Date Opened";
                    ToolTip = 'Specifies the value of the PrevPeriod field.';
                }
                field("Current Period"; CurrPeriod)
                {
                    ApplicationArea = Basic;
                    TableRelation = "PR Payroll Periods"."Date Opened";
                    ToolTip = 'Specifies the value of the CurrPeriod field.';
                }
                field(PostingGroup; PostingGroup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Group';
                    TableRelation = "PR Employee Posting Groups";
                    ToolTip = 'Specifies the value of the Posting Group field.';
                }
            }
        }

        actions { }
    }

    labels { }

    var
        Employee: Record "PR Salary Card";
        VPast: Decimal;
        VCurr: Decimal;
        VVar: Decimal;
        VPastTot: Decimal;
        VCurrTot: Decimal;
        VVarTot: Decimal;
        PrevPeriod: Date;
        CurrPeriod: Date;
        Matrix: Record "PR Period Transactions";
        Names: Text[80];
        HrEmp: Record "HR-Employee";
        EmpNo: Code[100];
        TransCode: Code[100];
        TransName: Text[100];
        Reason: Text[100];
        PostingGroup: Code[20];
}


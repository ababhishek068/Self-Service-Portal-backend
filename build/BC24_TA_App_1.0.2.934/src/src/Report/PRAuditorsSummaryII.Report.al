Report 50173 "PR Auditors Summary II"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRAuditorsSummaryII.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("PR Period Transactions"; "PR Period Transactions")
        {
            column(ReportForNavId_1; 1) { }
            column(PayrollPeriod; "PR Period Transactions"."Payroll Period") { }
            column(TransactionCode; "PR Period Transactions"."Transaction Code") { }
            column(Amount; "PR Period Transactions".Amount) { }
            column(TransactionName; "PR Period Transactions"."Transaction Name") { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoPhoneNo; CompInfo."Phone No.") { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPicture; CompInfo.Picture) { }

            trigger OnPreDataItem()
            begin

                "PR Period Transactions".SetRange("PR Period Transactions"."Transaction Type", "PR Period Transactions"."transaction type"::Income);

                "PR Period Transactions".SetRange("PR Period Transactions"."Payroll Period", Curr_StartDate, Curr_EndDate);

                "PR Period Transactions".SetRange("PR Period Transactions"."Posting Group", Curr_PostingGroup);

                "PR Period Transactions".SetRange("PR Period Transactions"."Transaction Type", Curr_TransType);

                if Cur_TransCode <> '' then "PR Period Transactions".SetRange("PR Period Transactions"."Transaction Code", Cur_TransCode);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(Curr_StartDate; Curr_StartDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Start Date';
                        TableRelation = "PR Payroll Periods"."Date Opened";
                        ToolTip = 'Specifies the value of the Start Date field.';
                    }
                    field(Curr_EndDate; Curr_EndDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'End Date';
                        TableRelation = "PR Payroll Periods"."Date Opened";
                        ToolTip = 'Specifies the value of the End Date field.';
                    }
                    label(Control5)
                    {
                        ApplicationArea = Basic;
                        Caption = '**';
                        Editable = false;
                    }
                    field(Curr_PostingGroup; Curr_PostingGroup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Group';
                        TableRelation = "PR Employee Posting Groups".Code;
                        ToolTip = 'Specifies the value of the Posting Group field.';
                    }
                    label(Control9)
                    {
                        ApplicationArea = Basic;
                        Caption = '***';
                        Editable = false;
                    }
                    field(Curr_TransType; Curr_TransType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Transaction Type';
                        ToolTip = 'Specifies the value of the Transaction Type field.';
                    }
                    label(Control10)
                    {
                        ApplicationArea = Basic;
                        Caption = '****';
                        Editable = false;
                    }
                    field(Cur_TransCode; Cur_TransCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Transaction Code';
                        TableRelation = "PR Transaction Codes"."Transaction Code";
                        ToolTip = 'Specifies the value of the Transaction Code field.';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompInfo.Reset();
        CompInfo.Get();

        CompInfo.CalcFields(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        Curr_StartDate: Date;
        Curr_EndDate: Date;
        Curr_PostingGroup: Code[10];
        Curr_TransType: Option Income,Deduction,Benefit;
        Cur_TransCode: Code[10];
}

